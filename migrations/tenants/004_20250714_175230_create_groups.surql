-- Migration: create groups

BEGIN TRANSACTION;

--------------------------------------------------------------------------------

DEFINE TABLE group SCHEMALESS;

DEFINE FIELD title ON group TYPE string;
DEFINE FIELD description ON group TYPE option<string>;
DEFINE FIELD _definition ON group TYPE string;
DEFINE FIELD updated_at ON group TYPE datetime VALUE time::now();
DEFINE FIELD created_at ON group TYPE datetime VALUE time::now() READONLY;

--------------------------------------------------------------------------------

DEFINE TABLE member_of TYPE RELATION FROM person TO group ENFORCED;

--------------------------------------------------------------------------------

DEFINE TABLE has_realm TYPE RELATION FROM group TO realm ENFORCED;

--------------------------------------------------------------------------------

COMMIT TRANSACTION;
