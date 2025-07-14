-- Migration: create location

BEGIN TRANSACTION;

--------------------------------------------------------------------------------

DEFINE TABLE location SCHEMALESS;

DEFINE FIELD title ON location TYPE string;
DEFINE FIELD description ON location TYPE option<string>;
DEFINE FIELD updated_at ON location TYPE datetime VALUE time::now();
DEFINE FIELD created_at ON location TYPE datetime VALUE time::now() READONLY;

--------------------------------------------------------------------------------

DEFINE TABLE permission SCHEMAFULL;

DEFINE FIELD action ON permission TYPE "create" | "read" | "update" | "delete" READONLY;
DEFINE FIELD updated_at ON permission TYPE datetime VALUE time::now();
DEFINE FIELD created_at ON permission TYPE datetime VALUE time::now() READONLY;

DEFINE INDEX permission_action_definition_key_index ON permission FIELDS action, definition_key UNIQUE;

--------------------------------------------------------------------------------

DEFINE EVENT definition_created ON TABLE definition
  WHEN $before == NONE
  THEN {
    CREATE type::thing("permission", string::concat("create ", $after.key))
      SET action = "create", definition_key = $after.key;
    CREATE type::thing("permission", string::concat("read ", $after.key))
      SET action = "read", definition_key = $after.key;
    CREATE type::thing("permission", string::concat("update ", $after.key))
      SET action = "update", definition_key = $after.key;
    CREATE type::thing("permission", string::concat("delete ", $after.key))
      SET action = "delete", definition_key = $after.key;
  };

--------------------------------------------------------------------------------

COMMIT TRANSACTION;
