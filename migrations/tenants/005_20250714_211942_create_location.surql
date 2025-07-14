-- Migration: create location

BEGIN TRANSACTION;

DEFINE TABLE location SCHEMALESS;

DEFINE FIELD updated_at ON location TYPE datetime VALUE time::now();
DEFINE FIELD created_at ON location TYPE datetime VALUE time::now() READONLY;

COMMIT TRANSACTION;
