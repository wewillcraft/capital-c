// deno run --allow-read --allow-write --allow-net scripts/migrations.ts <command> [...args]

import { join } from "$std/path/mod.ts";
import * as dotenv from "$std/dotenv/mod.ts";
import { RecordId, Surreal } from "jsr:@surrealdb/surrealdb";

// --- LOAD ENV ---
await dotenv.load({ export: true });

// --- CONFIG ---
const DB_URL = Deno.env.get("SURREALDB_URL") || "http://localhost:8000/rpc";
const DB_USER = Deno.env.get("SURREALDB_ADMIN_USER") || "root";
const DB_PASS = Deno.env.get("SURREALDB_ADMIN_PASS") || "root";
const DB_NS = Deno.env.get("SURREALDB_NAMESPACE") || "test";
const DB_DB = Deno.env.get("SURREALDB_DATABASE") || "test";
const MIGRATIONS_DIR = "migrations";
const MIGRATION_TABLE = "_migration";

type Migration = {
  filename: string;
  applied_at: string;
};

// --- DB CLIENT ---
const db = new Surreal();
await db.connect(DB_URL);

async function surrealConnect() {
  await db.use({ namespace: DB_NS, database: DB_DB });
  await db.signin({ username: DB_USER, password: DB_PASS });
}

// --- UTILS ---
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

async function ensureMigrationsDir() {
  try {
    await Deno.stat(MIGRATIONS_DIR);
  } catch {
    await Deno.mkdir(MIGRATIONS_DIR);
  }
}

function sanitizeDesc(desc: string) {
  return desc.replace(/[^a-zA-Z0-9_\-]/g, "_");
}

async function listMigrationFiles() {
  const files: string[] = [];
  for await (const entry of Deno.readDir(MIGRATIONS_DIR)) {
    if (entry.isFile && entry.name.endsWith(".surql")) {
      files.push(entry.name);
    }
  }
  files.sort();
  return files;
}

async function readMigrationFile(filename: string) {
  return await Deno.readTextFile(join(MIGRATIONS_DIR, filename));
}

async function getAppliedMigrations(): Promise<Migration[]> {
  await surrealConnect();
  const rows = await db.select<Migration>(MIGRATION_TABLE);
  return rows;
}

async function markMigrationApplied(filename: string) {
  await surrealConnect();
  await db.create<Migration>(new RecordId(MIGRATION_TABLE, filename), {
    filename,
    applied_at: new Date().toISOString(),
  });
}

function printTable(rows: { [key: string]: string }[], columns: string[]) {
  if (!rows.length) return;
  const colWidths = columns.map((col) =>
    Math.max(col.length, ...rows.map((row) => (row[col] || "").length))
  );
  const header = columns.map((col, i) => col.padEnd(colWidths[i])).join("  ");
  const sep = columns.map((_, i) => "-".repeat(colWidths[i])).join("  ");
  console.log(header);
  console.log(sep);
  for (const row of rows) {
    console.log(
      columns.map((col, i) => (row[col] || "").padEnd(colWidths[i])).join("  "),
    );
  }
}

// --- COMMANDS ---
async function create(desc: string) {
  await ensureMigrationsDir();
  const ts = nowTimestamp();
  const safeDesc = sanitizeDesc(desc);
  const fname = `${ts}_${safeDesc}.surql`;
  const fpath = join(MIGRATIONS_DIR, fname);
  await Deno.writeTextFile(fpath, `-- Migration: ${desc}\n`);
  console.log(`Created migration: ${fpath}`);
}

async function apply() {
  await ensureMigrationsDir();
  const files = await listMigrationFiles();
  const appliedRows = await getAppliedMigrations();
  const applied = new Set(appliedRows.map((row) => row.filename));
  let appliedCount = 0;
  for (const file of files) {
    if (applied.has(file)) {
      console.log(`Already applied: ${file}`);
      continue;
    }
    const sql = await readMigrationFile(file);
    console.log(`Applying: ${file}`);
    await db.query(sql);
    await markMigrationApplied(file);
    appliedCount++;
  }
  if (appliedCount === 0) {
    console.log("No new migrations to apply.");
  } else {
    console.log(`Applied ${appliedCount} migration(s).`);
  }
}

async function list() {
  await ensureMigrationsDir();
  const files = await listMigrationFiles();
  const appliedRows = await getAppliedMigrations();
  const appliedMap = new Map(
    appliedRows.map((row) => [row.filename, row.applied_at]),
  );
  const table = files.map((file) => ({
    filename: file,
    applied_at: appliedMap.get(file) || "",
  }));
  printTable(table, ["filename", "applied_at"]);
}

function help() {
  console.log(`
Usage:
  migrations.ts create <desc>   Create a new migration file
  migrations.ts apply           Apply all pending migrations
  migrations.ts list            List all migrations and their status
  migrations.ts help            Show this help message

Config via env:
  SURREALDB_URL
  SURREALDB_ADMIN_USER
  SURREALDB_ADMIN_PASS
  SURREALDB_NAMESPACE
  SURREALDB_DATABASE
`);
}

// --- MAIN ---
if (import.meta.main) {
  const [cmd, ...args] = Deno.args;
  switch (cmd) {
    case "create":
      if (!args[0]) {
        console.error("Description required.");
        Deno.exit(1);
      }
      await create(args.join("_"));
      break;
    case "apply":
      await apply();
      break;
    case "list":
      await list();
      break;
    case "help":
    default:
      help();
      break;
  }
}
