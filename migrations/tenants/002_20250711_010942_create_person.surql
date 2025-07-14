-- Migration: create user profile

BEGIN TRANSACTION;

DEFINE TABLE person SCHEMALESS;

DEFINE FIELD created_at ON person TYPE datetime DEFAULT time::now();

COMMIT TRANSACTION;
