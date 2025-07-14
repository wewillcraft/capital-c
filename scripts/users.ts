import { Surreal } from "surrealdb";
import { parseArgs } from "@std/cli/parse-args";

import config from "./lib/config.ts";
import { connect } from "./lib/db.ts";

const db = new Surreal();

async function prompt(label: string): Promise<string> {
  await Deno.stdout.write(new TextEncoder().encode(label));
  const buf = new Uint8Array(1024);
  const n = <number> await Deno.stdin.read(buf);
  const input = new TextDecoder().decode(buf.subarray(0, n)).trim();
  return input;
}

async function createTenantUser() {
  const tenantNamespace = await prompt("Tenant Namespace: ");
  const email = await prompt("Email: ");
  const password = await prompt("Password: ");
  await connect(
    db,
    config.SURREALDB_GLOBAL_NAMESPACE,
    config.SURREALDB_GLOBAL_DATABASE,
  );
  try {
    const res = await db.signup({
      namespace: tenantNamespace,
      database: config.SURREALDB_TENANT_DATABASE,
      access: "user",
      variables: {
        email,
        password,
      },
    });
    console.log("Tenant user for namespace", tenantNamespace, "created:", res);
  } catch (e) {
    console.error(
      "Failed to create tenant user for namespace",
      tenantNamespace,
      ":",
      e,
    );
  } finally {
    await db.close();
  }
}

function printHelp() {
  console.log(`
Usage:
  users create
  users --help

Commands:
  create   Create a new tenant user (interactive)

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

  const [cmd] = args._;

  if (!cmd) {
    printHelp();
    Deno.exit(0);
  }

  if (cmd === "create") {
    await createTenantUser();
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
