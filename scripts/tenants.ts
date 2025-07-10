import { join } from "@std/path";
import { RecordId, Surreal } from "surrealdb";

import config from "./lib/config.ts";
import { Tenant } from "./lib/models.ts";

import { applyMigrationsToNamespace } from "./migrate.ts";

const db = new Surreal();

function sanitizeName(name: string) {
  return name.toLowerCase().replace(/[^a-z0-9]/g, "_");
}

function randomSuffix(len = 4) {
  return Math.random().toString(36).slice(-len);
}

async function connect(namespace: string, database: string) {
  await db.connect(config.SURREALDB_URL, {
    namespace,
    database,
    auth: {
      username: config.SURREALDB_ROOT_USERNAME,
      password: config.SURREALDB_ROOT_PASSWORD,
    },
  });
}

async function createTenant(name: string, displayName: string, email: string) {
  const sanitized = sanitizeName(name);
  const suffix = randomSuffix();
  const namespace = `tenant_${sanitized}_${suffix}`;
  await connect(
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

  // Find user by email
  const users = await db.query<RecordId[]>(
    `SELECT VALUE id FROM ONLY user WHERE email = $email LIMIT 1`,
    { email },
  );
  if (users.length === 0 || users.length > 1) {
    console.error(`User with email '${email}' not found in global namespace.`);
    return;
  }
  const userId = users[0];

  // Find tenant by namespace
  const tenants = await db.query<RecordId[]>(
    `SELECT VALUE id FROM ONLY tenant WHERE namespace = $namespace LIMIT 1`,
    { namespace },
  );
  if (tenants.length === 0 || tenants.length > 1) {
    console.error(
      `Tenant with namespace '${namespace}' not found in tenant table.`,
    );
    return;
  }
  const tenantId = tenants[0];
  // Create graph links
  await db.query(
    `RELATE $userId -> own:ulid() -> $tenantId CONTENT { created_at: time::now() }`,
    {
      userId: userId,
      tenantId: tenantId,
    },
  );
  await db.query(
    `RELATE $userId -> part_of:ulid() -> $tenantId CONTENT { created_at: time::now() }`,
    {
      userId: userId,
      tenantId: tenantId,
    },
  );
  console.log(
    `Created graph links from user (${userId}) to tenant (${tenantId})`,
  );

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

async function main() {
  const [cmd, ...args] = Deno.args;
  if (cmd === "help" || !cmd) {
    console.log(`
Usage:
  tenants.ts help
  tenants.ts create <name> <display_name> <user_email>
  tenants.ts delete <display_name>
`);
    Deno.exit(0);
  }
  if (cmd === "create") {
    if (args.length < 3) {
      console.log(`
Usage:
  tenants.ts create <name> <display_name> <user_email>
`);
      Deno.exit(1);
    }
    const [name, displayName, email] = args;
    await createTenant(name, displayName, email);
    await db.close();
    return;
  }
  if (cmd === "delete") {
    if (args.length < 1) {
      console.log(`
Usage:
  tenants.ts delete <display_name>
`);
      Deno.exit(1);
    }
    const [displayName] = args;
    await deleteTenantsByDisplayName(displayName);
    await db.close();
    return;
  }
  console.log(`Unknown command: ${cmd}
See: tenants.ts help`);
  Deno.exit(1);
}

if (import.meta.main) {
  await main();
}
