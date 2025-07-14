-- Migration: create tenant

BEGIN TRANSACTION;

DEFINE TABLE tenant SCHEMAFULL;
DEFINE FIELD namespace ON tenant TYPE string;
DEFINE FIELD name ON tenant TYPE string;
DEFINE FIELD created_at ON tenant TYPE datetime DEFAULT time::now();
DEFINE FIELD enabled ON tenant TYPE bool DEFAULT true;

COMMIT TRANSACTION;
