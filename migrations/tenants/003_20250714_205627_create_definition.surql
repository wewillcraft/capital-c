-- Migration: create definition

BEGIN TRANSACTION;

DEFINE TABLE definition SCHEMALESS;

DEFINE FIELD created_at ON definition TYPE datetime DEFAULT time::now();

COMMIT TRANSACTION;
