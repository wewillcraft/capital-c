-- Migration: create groups

BEGIN TRANSACTION;

--------------------------------------------------------------------------------

REMOVE TABLE IF EXISTS group;
REMOVE TABLE IF EXISTS in_realm;
REMOVE TABLE IF EXISTS member_of;
REMOVE EVENT IF EXISTS group_definition_must_exist ON TABLE group;

--------------------------------------------------------------------------------

COMMIT TRANSACTION;
