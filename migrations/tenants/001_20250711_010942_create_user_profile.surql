-- Migration: create user profile

BEGIN TRANSACTION;

DEFINE TABLE user_profile SCHEMALESS;

COMMIT TRANSACTION;
