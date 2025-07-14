-- Migration: create realm

BEGIN TRANSACTION;

DEFINE TABLE realm SCHEMALESS;

DEFINE FIELD updated_at ON realm TYPE datetime VALUE time::now();
DEFINE FIELD created_at ON realm TYPE datetime VALUE time::now() READONLY;

COMMIT TRANSACTION;
