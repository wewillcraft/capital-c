-- Migration: create utils

BEGIN TRANSACTION;

--------------------------------------------------------------------------------

REMOVE FUNCTION IF EXISTS fn::has_references;

--------------------------------------------------------------------------------

COMMIT TRANSACTION;
