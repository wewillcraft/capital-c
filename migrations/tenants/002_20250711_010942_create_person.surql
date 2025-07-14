-- Migration: create user profile

BEGIN TRANSACTION;

DEFINE TABLE person SCHEMALESS;

DEFINE FIELD last_name ON person TYPE option<string>;
DEFINE FIELD first_name ON person TYPE option<string>;
DEFINE FIELD middle_name ON person TYPE option<string>;
DEFINE FIELD suffix ON person TYPE option<string>;
DEFINE FIELD gender ON person TYPE option<string>;
DEFINE FIELD birth_date ON person TYPE option<datetime>;

DEFINE FIELD updated_at ON person TYPE datetime VALUE time::now();
DEFINE FIELD created_at ON person TYPE datetime VALUE time::now() READONLY;

COMMIT TRANSACTION;
