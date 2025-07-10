import { Surreal } from "surrealdb";

import config from "./config.ts";

export async function connect(
  db: Surreal,
  namespace: string,
  database: string,
) {
  await db.connect(config.SURREALDB_URL, {
    namespace,
    database,
    auth: {
      username: config.SURREALDB_ROOT_USERNAME,
      password: config.SURREALDB_ROOT_PASSWORD,
    },
  });
}
