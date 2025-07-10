-- Migration: setup tenant

BEGIN TRANSACTION;

DEFINE TABLE tenant SCHEMAFULL;
DEFINE FIELD namespace ON tenant TYPE string;
DEFINE FIELD name ON tenant TYPE string;
DEFINE FIELD created_at ON tenant TYPE datetime;
DEFINE FIELD status ON tenant TYPE string;
DEFINE FIELD applied_migrations ON tenant TYPE array;

COMMIT TRANSACTION;
