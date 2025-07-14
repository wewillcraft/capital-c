-- Migration: create location

BEGIN TRANSACTION;

DEFINE TABLE location SCHEMALESS;

DEFINE FIELD created_at ON TABLE location TYPE datetime DEFAULT time::now();

COMMIT TRANSACTION;
