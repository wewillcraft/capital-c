#!/usr/bin/env -S deno run -A --watch=static/,routes/

import dev from "$fresh/dev.ts";
import config from "./fresh.config.ts";

import { load } from "jsr:@std/dotenv@0.225.5";

await load({ export: true });

await dev(import.meta.url, "./main.ts", config);
