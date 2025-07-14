-- Migration: create user profile

BEGIN TRANSACTION;

REMOVE TABLE IF EXISTS person;

COMMIT TRANSACTION;
