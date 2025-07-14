-- Migration: create permission

BEGIN TRANSACTION;

REMOVE TABLE IF EXISTS permission;

COMMIT TRANSACTION;
