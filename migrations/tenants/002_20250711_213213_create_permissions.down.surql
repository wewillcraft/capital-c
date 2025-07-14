-- Migration: create permissions

BEGIN TRANSACTION;

--------------------------------------------------------------------------------

REMOVE TABLE IF EXISTS realm;
REMOVE TABLE IF EXISTS definition;
REMOVE TABLE IF EXISTS role;
REMOVE TABLE IF EXISTS role_for;
REMOVE TABLE IF EXISTS has_role;
REMOVE TABLE IF EXISTS can_create;
REMOVE TABLE IF EXISTS can_read;
REMOVE TABLE IF EXISTS can_update;
REMOVE TABLE IF EXISTS can_delete;

--------------------------------------------------------------------------------

COMMIT TRANSACTION;
