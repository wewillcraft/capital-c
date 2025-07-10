import { Surreal } from "surrealdb";

import config from "./lib/config.ts";

const db = new Surreal();

async function prompt(label: string): Promise<string> {
  await Deno.stdout.write(new TextEncoder().encode(label));
  const buf = new Uint8Array(1024);
  const n = <number> await Deno.stdin.read(buf);
  const input = new TextDecoder().decode(buf.subarray(0, n)).trim();
  return input;
}

async function createAdminUser() {
  const name = await prompt("Name: ");
  const email = await prompt("Email: ");
  const password = await prompt("Password: ");
  await db.connect(config.SURREALDB_URL, {
    namespace: config.SURREALDB_GLOBAL_NAMESPACE,
    database: config.SURREALDB_GLOBAL_DATABASE,
  });
  try {
    const res = await db.signup({
      namespace: config.SURREALDB_GLOBAL_NAMESPACE,
      database: config.SURREALDB_GLOBAL_DATABASE,
      access: "user",
      variables: {
        name,
        email,
        password,
      },
    });
    console.log("Admin user created:", res);
  } catch (e) {
    console.error("Failed to create admin user:", e);
  } finally {
    await db.close();
  }
}

async function main() {
  const [cmd] = Deno.args;
  if (cmd === "create") {
    await createAdminUser();
  } else {
    console.log("Usage: deno task users create");
  }
}

if (import.meta.main) {
  await main();
}
