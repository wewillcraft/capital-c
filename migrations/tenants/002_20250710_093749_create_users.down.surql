-- Migration: create users

BEGIN TRANSACTION;

--------------------------------------------------------------------------------

REMOVE INDEX IF EXISTS user_email_index ON user;
REMOVE ACCESS IF EXISTS user ON DATABASE;
REMOVE TABLE IF EXISTS user;
REMOVE EVENT IF EXISTS prevent_deletion ON TABLE person;
REMOVE TABLE IF EXISTS person;
REMOVE TABLE IF EXISTS has_profile;

--------------------------------------------------------------------------------

COMMIT TRANSACTION;
