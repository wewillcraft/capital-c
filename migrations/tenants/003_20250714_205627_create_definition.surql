-- Migration: create definition

BEGIN TRANSACTION;

DEFINE TABLE definition SCHEMALESS;

DEFINE FIELD updated_at ON definition TYPE datetime VALUE time::now();
DEFINE FIELD created_at ON definition TYPE datetime VALUE time::now() READONLY;

COMMIT TRANSACTION;
