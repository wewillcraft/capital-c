import { join } from "@std/path";
import { parseArgs } from "@std/cli/parse-args";
import { RecordId, Surreal } from "surrealdb";

import config from "./lib/config.ts";
import { connect } from "./lib/db.ts";

const db = new Surreal();

function nowTimestamp() {
  const d = new Date();
  const pad = (n: number) => n.toString().padStart(2, "0");
  return (
    d.getFullYear().toString() +
    pad(d.getMonth() + 1) +
    pad(d.getDate()) + "_" +
    pad(d.getHours()) +
    pad(d.getMinutes()) +
    pad(d.getSeconds())
  );
}

function sanitizeDescription(description: string) {
  return description.replace(/[^a-zA-Z0-9_\-]/g, "_");
}

async function ensureDir(dir: string) {
  try {
    await Deno.stat(dir);
  } catch {
    await Deno.mkdir(dir, { recursive: true });
  }
}

async function listMigrationFiles(dir: string) {
  const files: string[] = [];
  for await (const entry of Deno.readDir(dir)) {
    if (
      entry.isFile &&
      entry.name.endsWith(".surql") &&
      !entry.name.endsWith(".down.surql")
    ) {
      files.push(entry.name);
    }
  }
  files.sort();
  return files;
}

async function readMigrationFile(dir: string, filename: string) {
  return await Deno.readTextFile(join(dir, filename));
}

async function nextMigrationPrefix(dir: string): Promise<string> {
  return await listMigrationFiles(dir).then((files) => {
    const nums = files
      .map((f) => parseInt(f.slice(0, 3)))
      .filter((n) => !isNaN(n));
    const next = nums.length ? Math.max(...nums) + 1 : 1;
    return String(next).padStart(3, "0");
  });
}

async function createMigrationFiles(
  target: "global" | "tenants",
  desc: string,
) {
  const now = nowTimestamp();
  const safeDesc = sanitizeDescription(desc);
  const dir = join(config.MIGRATIONS_DIR, target);
  await ensureDir(dir);
  const prefix = await nextMigrationPrefix(dir);
  const base = `${prefix}_${now}_${safeDesc}`;
  const fpath = join(dir, `${base}.surql`);
  const downFpath = join(dir, `${base}.down.surql`);
  const template = `-- Migration: ${desc}

BEGIN TRANSACTION;

-- Your migration code here

COMMIT TRANSACTION;
`;
  await Deno.writeTextFile(fpath, template);
  await Deno.writeTextFile(downFpath, template);
  console.log(`Created ${target} up migration file: ${fpath}`);
  console.log(`Created ${target} down migration file: ${downFpath}`);
}

async function rollbackMigrations(
  target: "global" | "tenants",
  version: string,
) {
  const dir = join(config.MIGRATIONS_DIR, target);
  const files = (await listMigrationFiles(dir))
    .filter((f) => f.match(/^\d{3}_/))
    .sort()
    .reverse();
  const toRollback = files.filter((f) => f.slice(0, 3) > version);
  await connect(
    db,
    config.SURREALDB_GLOBAL_NAMESPACE,
    config.SURREALDB_GLOBAL_DATABASE,
  );

  for (const file of toRollback) {
    const downFile = file.replace(/\.surql$/, ".down.surql");
    try {
      const sql = await readMigrationFile(dir, downFile);
      console.log(`Rolling back: ${downFile}`);
      await db.query(sql);
      await connect(
        db,
        target === "global" ? config.SURREALDB_GLOBAL_NAMESPACE : file,
        config.SURREALDB_TENANT_DATABASE,
      );
      await db.delete(new RecordId(config.MIGRATION_TABLE, file));
    } catch (e) {
      const msg = e instanceof Error ? e.message : String(e);
      console.error(`Failed to rollback ${downFile}: ${msg}`);
      break;
    }
  }
}

async function rollbackTenantMigrations(namespace: string, version: string) {
  const dir = join(config.MIGRATIONS_DIR, "tenants");
  const files = (await listMigrationFiles(dir))
    .filter((f) => f.match(/^\d{3}_/))
    .sort()
    .reverse();
  const toRollback = files.filter((f) => f.slice(0, 3) > version);
  await connect(db, namespace, config.SURREALDB_TENANT_DATABASE);
  for (const file of toRollback) {
    const downFile = file.replace(/\.surql$/, ".down.surql");
    try {
      const sql = await readMigrationFile(dir, downFile);
      console.log(`[${namespace}] Rolling back: ${downFile}`);
      await connect(db, namespace, config.SURREALDB_TENANT_DATABASE);
      await db.query(sql);
      await db.delete(new RecordId(config.MIGRATION_TABLE, file));
    } catch (e) {
      const msg = e instanceof Error ? e.message : String(e);
      console.error(`[${namespace}] Failed to rollback ${downFile}: ${msg}`);
      break;
    }
  }
}

async function getAppliedMigrations(namespace: string): Promise<string[]> {
  await connect(db, namespace, config.SURREALDB_TENANT_DATABASE);
  try {
    const rows = await db.select<{ filename: string }>(config.MIGRATION_TABLE);
    return Array.isArray(rows) ? rows.map((r) => r.filename) : [];
  } catch {
    return [];
  }
}

async function markMigrationApplied(namespace: string, filename: string) {
  await connect(db, namespace, config.SURREALDB_TENANT_DATABASE);
  await db.create(new RecordId(config.MIGRATION_TABLE, filename), {
    filename,
    applied_at: new Date().toISOString(),
  });
}

export async function applyMigrationsToNamespace(
  dir: string,
  namespace: string,
) {
  const files = await listMigrationFiles(dir);
  const applied = new Set(await getAppliedMigrations(namespace));
  let appliedCount = 0;
  for (const file of files) {
    if (applied.has(file)) {
      console.log(`[${namespace}] Already applied: ${file}`);
      continue;
    }
    const sql = await readMigrationFile(dir, file);
    try {
      await connect(db, namespace, config.SURREALDB_TENANT_DATABASE);
      await db.query(sql);
      await markMigrationApplied(namespace, file);
      appliedCount++;
      console.log(`[${namespace}] Applied: ${file}`);
    } catch (e) {
      const msg = e instanceof Error ? e.message : String(e);
      console.error(`[${namespace}] Failed: ${file}: ${msg}`);
      break;
    }
  }
  if (appliedCount) {
    console.log(`[${namespace}] Applied ${appliedCount} migration(s).`);
  }
}

async function getTenants(): Promise<string[]> {
  await connect(
    db,
    config.SURREALDB_GLOBAL_NAMESPACE,
    config.SURREALDB_GLOBAL_DATABASE,
  );
  const tenants = await db.select<{ namespace: string }>("tenant");
  return Array.isArray(tenants) ? tenants.map((t) => t.namespace) : [];
}

function printHelp() {
  console.log(`
Usage:
  migrate create (global|tenants) <description>
  migrate apply (global|tenants)
  migrate apply tenant <namespace>
  migrate rollback (global|tenants) <version>
  migrate rollback tenant <namespace> <version>
  migrate status <namespace>
  migrate --help

Commands:
  create    Create new migration files (up and down)
  apply     Apply migrations to global or tenant namespaces
  rollback  Rollback migrations to a specific version
  status    Show migration status for a namespace

Options:
  -h, --help  Show this help message
`);
}

async function main() {
  const args = parseArgs(Deno.args, {
    alias: {
      help: "h",
    },
    boolean: ["help"],
    stopEarly: true,
  });

  if (args.help) {
    printHelp();
    Deno.exit(0);
  }

  const [cmd, ...positionals] = args._;

  if (!cmd) {
    printHelp();
    Deno.exit(0);
  }

  switch (cmd) {
    case "create": {
      const [target, ...descArr] = positionals;
      if (!target || !descArr.length) {
        console.log("\nMissing arguments for create.\n");
        printHelp();
        Deno.exit(1);
      }
      await createMigrationFiles(
        String(target) as "global" | "tenants",
        descArr.map(String).join("_"),
      );
      break;
    }
    case "apply": {
      const [scope, ns] = positionals;
      if (scope === "global") {
        await applyMigrationsToNamespace(
          join(config.MIGRATIONS_DIR, "global"),
          config.SURREALDB_GLOBAL_NAMESPACE,
        );
      } else if (scope === "tenants") {
        const tenants = await getTenants();
        for (const tenant of tenants) {
          await applyMigrationsToNamespace(
            join(config.MIGRATIONS_DIR, "tenants"),
            tenant,
          );
        }
      } else if (scope === "tenant" && ns) {
        await applyMigrationsToNamespace(
          join(config.MIGRATIONS_DIR, "tenants"),
          String(ns),
        );
      } else {
        console.log("\nInvalid arguments for apply.\n");
        printHelp();
        Deno.exit(1);
      }
      break;
    }
    case "rollback": {
      if (positionals[0] === "tenant" && positionals[1] && positionals[2]) {
        await rollbackTenantMigrations(
          String(positionals[1]),
          String(positionals[2]),
        );
      } else {
        const [target, version] = positionals;
        if (!target || !version) {
          console.log("\nMissing arguments for rollback.\n");
          printHelp();
          Deno.exit(1);
        }
        await rollbackMigrations(
          String(target) as "global" | "tenants",
          String(version),
        );
      }
      break;
    }
    case "status": {
      const [ns] = positionals;
      if (!ns) {
        console.log("\nMissing namespace argument for status.\n");
        printHelp();
        Deno.exit(1);
      }
      const files = await listMigrationFiles(
        join(config.MIGRATIONS_DIR, "tenants"),
      );
      const applied = new Set(await getAppliedMigrations(String(ns)));
      for (const file of files) {
        const status = applied.has(file) ? "[applied]" : "[pending]";
        console.log(`${file} ${status}`);
      }
      break;
    }
    default:
      console.log(`Unknown command: ${cmd}`);
      printHelp();
      Deno.exit(1);
  }
  await db.close();
  Deno.exit(0);
}

if (import.meta.main) {
  await main();
}
