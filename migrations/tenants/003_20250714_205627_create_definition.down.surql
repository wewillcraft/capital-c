-- Migration: create definition

BEGIN TRANSACTION;

REMOVE TABLE IF EXISTS definition;

COMMIT TRANSACTION;
