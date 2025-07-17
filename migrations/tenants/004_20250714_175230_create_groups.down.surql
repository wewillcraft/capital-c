-- Migration: create groups

BEGIN TRANSACTION;

--------------------------------------------------------------------------------

REMOVE TABLE IF EXISTS group;
REMOVE TABLE IF EXISTS has_realm;
REMOVE TABLE IF EXISTS member_of;

--------------------------------------------------------------------------------

COMMIT TRANSACTION;
