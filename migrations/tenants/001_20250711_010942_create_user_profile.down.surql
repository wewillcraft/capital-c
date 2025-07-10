-- Migration: create user profile

BEGIN TRANSACTION;

REMOVE TABLE IF EXISTS user_profile;

COMMIT TRANSACTION;
