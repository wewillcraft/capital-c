import { join } from "@std/path";
import { RecordId, Surreal } from "surrealdb";
import { parseArgs } from "@std/cli/parse-args";

import config from "./lib/config.ts";
import { connect } from "./lib/db.ts";

import { Tenant } from "../models.ts";

import { applyMigrationsToNamespace } from "./migrate.ts";

const db = new Surreal();

function sanitizeName(name: string) {
  return name.toLowerCase().replace(/[^a-z0-9]/g, "_");
}

function randomSuffix(len = 4) {
  return Math.random().toString(36).slice(-len);
}

async function createTenant(name: string, displayName: string) {
  const sanitized = sanitizeName(name);
  const suffix = randomSuffix();
  const namespace = `tenant_${sanitized}_${suffix}`;
  await connect(
    db,
    config.SURREALDB_GLOBAL_NAMESPACE,
    config.SURREALDB_GLOBAL_DATABASE,
  );
  await db.query(`DEFINE NAMESPACE ${namespace};`);
  await db.create("tenant", {
    namespace,
    name: displayName,
    created_at: new Date(),
    status: "active",
    applied_migrations: [],
  });
  console.log(
    `Tenant '${displayName}' (${namespace}) created.`,
  );

  // Find tenant by namespace
  const [tenantId] = await db.query<RecordId[]>(
    `SELECT VALUE id FROM ONLY tenant WHERE namespace = $namespace LIMIT 1`,
    { namespace },
  );
  if (!tenantId) {
    console.error(
      `Tenant with namespace '${namespace}' not found in tenant table.`,
    );
    return;
  }

  await applyMigrationsToNamespace(
    join(config.MIGRATIONS_DIR, "tenants"),
    namespace,
  );
  console.log(
    `Tenant '${displayName}' (${namespace}) migrations applied.`,
  );
}

async function deleteTenantsByDisplayName(displayName: string) {
  await connect(
    db,
    config.SURREALDB_GLOBAL_NAMESPACE,
    config.SURREALDB_GLOBAL_DATABASE,
  );
  // Find all tenants with the given display name
  const [tenants] = await db.query<Tenant[]>(
    `SELECT * FROM tenant WHERE name = $displayName;`,
    { displayName },
  );
  if (
    !Array.isArray(tenants) || tenants.length === 0
  ) {
    console.log(`No tenants found with display name '${displayName}'.`);
    return;
  }
  for (const tenant of tenants) {
    const ns = tenant.namespace;
    const id = tenant.id;
    // Remove the namespace
    await db.query(`REMOVE NAMESPACE IF EXISTS ${ns};`);
    // Remove the tenant record
    await db.delete(id);
    console.log(`Deleted tenant record ${id} and namespace ${ns}`);
  }
}

function printHelp() {
  console.log(`
Usage:
  tenants create <name> <display_name> <user_email>
  tenants delete <display_name>
  tenants --help

Commands:
  create   Create a new tenant and link to user
  delete   Delete all tenants with a given display name

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

  if (cmd === "create") {
    if (positionals.length < 2) {
      console.log("\nMissing arguments for create.\n");
      printHelp();
      Deno.exit(1);
    }
    const [name, displayName] = positionals;
    await createTenant(String(name), String(displayName));
    await db.close();
    return;
  }

  if (cmd === "delete") {
    if (positionals.length < 1) {
      console.log("\nMissing arguments for delete.\n");
      printHelp();
      Deno.exit(1);
    }
    const [displayName] = positionals;
    await deleteTenantsByDisplayName(String(displayName));
    await db.close();
    return;
  }

  console.log(`Unknown command: ${cmd}`);
  printHelp();
  await db.close();
  Deno.exit(1);
}

if (import.meta.main) {
  await main();
}
