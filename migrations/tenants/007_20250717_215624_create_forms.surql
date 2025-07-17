-- Migration: create forms

BEGIN TRANSACTION;

--------------------------------------------------------------------------------

DEFINE TABLE form SCHEMALESS;

DEFINE FIELD title ON form TYPE string;
DEFINE FIELD description ON form TYPE option<string>;
DEFINE FIELD updated_at ON form TYPE datetime VALUE time::now();
DEFINE FIELD created_at ON form TYPE datetime VALUE time::now() READONLY;


--------------------------------------------------------------------------------

DEFINE TABLE form_response SCHEMALESS;

DEFINE FIELD updated_at ON form_response TYPE datetime VALUE time::now();
DEFINE FIELD created_at ON form_response TYPE datetime VALUE time::now() READONLY;

--------------------------------------------------------------------------------

DEFINE TABLE response_for TYPE RELATION FROM form_response TO form ENFORCED;

--------------------------------------------------------------------------------

DEFINE TABLE submitted TYPE RELATION FROM person TO form_response ENFORCED;

--------------------------------------------------------------------------------

DEFINE TABLE OVERWRITE has_realm TYPE RELATION FROM form|form_response|event|group|ticket TO realm ENFORCED;

--------------------------------------------------------------------------------

COMMIT TRANSACTION;
