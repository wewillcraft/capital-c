-- Migration: create permission

BEGIN TRANSACTION;

DEFINE TABLE permission SCHEMALESS;

DEFINE FIELD updated_at ON permission TYPE datetime VALUE time::now();
DEFINE FIELD created_at ON permission TYPE datetime VALUE time::now() READONLY;

COMMIT TRANSACTION;
