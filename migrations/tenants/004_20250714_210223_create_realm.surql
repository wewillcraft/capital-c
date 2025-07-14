-- Migration: create realm

BEGIN TRANSACTION;

DEFINE TABLE realm SCHEMALESS;

DEFINE FIELD created_at ON TABLE realm TYPE datetime DEFAULT time::now();

COMMIT TRANSACTION;
