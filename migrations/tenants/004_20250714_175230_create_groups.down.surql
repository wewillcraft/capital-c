-- Migration: create groups

BEGIN TRANSACTION;

--------------------------------------------------------------------------------

REMOVE TABLE IF EXISTS group;
REMOVE TABLE IF EXISTS in_realm;
REMOVE TABLE IF EXISTS member_of;

--------------------------------------------------------------------------------

COMMIT TRANSACTION;
