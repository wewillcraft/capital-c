-- Migration: create permissions

BEGIN TRANSACTION;

--------------------------------------------------------------------------------

REMOVE FUNCTION IF EXISTS fn::has_permission;

REMOVE TABLE IF EXISTS realm;
REMOVE TABLE IF EXISTS definition;
REMOVE TABLE IF EXISTS role;
REMOVE TABLE IF EXISTS role_for;
REMOVE TABLE IF EXISTS has_permission;

--------------------------------------------------------------------------------

COMMIT TRANSACTION;
