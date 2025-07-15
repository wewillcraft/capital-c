-- Migration: create permissions

BEGIN TRANSACTION;

--------------------------------------------------------------------------------

REMOVE FUNCTION IF EXISTS fn::has_permission;

REMOVE TABLE IF EXISTS realm;
REMOVE TABLE IF EXISTS definition;
REMOVE TABLE IF EXISTS role;

--------------------------------------------------------------------------------

COMMIT TRANSACTION;
