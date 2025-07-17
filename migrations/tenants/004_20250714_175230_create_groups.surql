-- Migration: create groups

BEGIN TRANSACTION;

--------------------------------------------------------------------------------

DEFINE TABLE group SCHEMALESS;

DEFINE FIELD _definition ON group TYPE string;
DEFINE FIELD title ON group TYPE string;
DEFINE FIELD description ON group TYPE option<string>;
DEFINE FIELD updated_at ON group TYPE datetime VALUE time::now();
DEFINE FIELD created_at ON group TYPE datetime VALUE time::now() READONLY;

DEFINE EVENT group_definition_must_exist ON TABLE group WHEN $event = "CREATE" THEN {
  LET $definition = type::thing("definition", $value._definition);
  IF not(record::exists($definition)) THEN {
    THROW "Group definition does not exist";
  } END;
};

--------------------------------------------------------------------------------

DEFINE TABLE member_of TYPE RELATION FROM person TO group ENFORCED;

--------------------------------------------------------------------------------

DEFINE TABLE in_realm TYPE RELATION FROM group TO realm ENFORCED;

--------------------------------------------------------------------------------

COMMIT TRANSACTION;
