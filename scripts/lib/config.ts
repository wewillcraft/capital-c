import { load } from "@std/dotenv";

await load({ export: true });

export interface Config {
  SURREALDB_PROTOCOL: string;
  SURREALDB_HOST: string;
  SURREALDB_PORT: string;
  SURREALDB_URL: string;
  SURREALDB_ROOT_USERNAME: string;
  SURREALDB_ROOT_PASSWORD: string;
  SURREALDB_GLOBAL_NAMESPACE: string;
  SURREALDB_TENANT_DATABASE: string;
  SURREALDB_GLOBAL_DATABASE: string;
  MIGRATION_TABLE: string;
  MIGRATIONS_DIR: string;
}

const config: Config = {
  SURREALDB_PROTOCOL: Deno.env.get("SURREALDB_PROTOCOL") ?? "http",
  SURREALDB_HOST: Deno.env.get("SURREALDB_HOST") ?? "localhost",
  SURREALDB_PORT: Deno.env.get("SURREALDB_PORT") ?? "8000",
  SURREALDB_URL: `${Deno.env.get("SURREALDB_PROTOCOL") ?? "http"}://${
    Deno.env.get("SURREALDB_HOST") ?? "localhost"
  }:${Deno.env.get("SURREALDB_PORT") ?? "8000"}`,
  SURREALDB_ROOT_USERNAME: Deno.env.get("SURREALDB_ROOT_USERNAME") ?? "root",
  SURREALDB_ROOT_PASSWORD: Deno.env.get("SURREALDB_ROOT_PASSWORD") ?? "root",
  SURREALDB_GLOBAL_NAMESPACE: Deno.env.get("SURREALDB_GLOBAL_NAMESPACE") ??
    "global",
  SURREALDB_TENANT_DATABASE: Deno.env.get("SURREALDB_TENANT_DATABASE") ??
    "prod",
  SURREALDB_GLOBAL_DATABASE: Deno.env.get("SURREALDB_GLOBAL_DATABASE") ??
    "prod",
  MIGRATION_TABLE: "_migrations",
  MIGRATIONS_DIR: "migrations",
};

export default config;
