-- Migration: create permissions

BEGIN TRANSACTION;

--------------------------------------------------------------------------------

DEFINE TABLE realm SCHEMALESS;

DEFINE FIELD id ON realm TYPE string ASSERT {
  IF string::matches(record::id($value), "[^a-zA-Z0-9]") {
    THROW "ID must only contain alphanumeric characters";
  };
  RETURN true;
};
DEFINE FIELD title ON realm TYPE string;
DEFINE FIELD description ON realm TYPE option<string>;
DEFINE FIELD updated_at ON realm TYPE datetime VALUE time::now();
DEFINE FIELD created_at ON realm TYPE datetime VALUE time::now() READONLY;

--------------------------------------------------------------------------------

DEFINE TABLE definition SCHEMALESS;

DEFINE FIELD id ON definition TYPE string ASSERT {
  IF string::matches(record::id($value), "[^a-zA-Z0-9]") {
    THROW "ID must only contain alphanumeric characters";
  };
  RETURN true;
};
DEFINE FIELD title ON definition TYPE string;
DEFINE FIELD description ON definition TYPE option<string>;
DEFINE FIELD updated_at ON definition TYPE datetime VALUE time::now();
DEFINE FIELD created_at ON definition TYPE datetime VALUE time::now() READONLY;

--------------------------------------------------------------------------------

DEFINE TABLE role SCHEMALESS;

DEFINE FIELD title ON role TYPE string;
DEFINE FIELD description ON role TYPE option<string>;
DEFINE FIELD realm ON role TYPE record<realm>;
DEFINE FIELD can_create ON role TYPE option<set<record<definition>>>;
DEFINE FIELD can_read ON role TYPE option<set<record<definition>>>;
DEFINE FIELD can_update ON role TYPE option<set<record<definition>>>;
DEFINE FIELD can_delete ON role TYPE option<set<record<definition>>>;
DEFINE FIELD updated_at ON role TYPE datetime VALUE time::now();
DEFINE FIELD created_at ON role TYPE datetime VALUE time::now() READONLY;

--------------------------------------------------------------------------------

DEFINE FUNCTION fn::has_permission(
    $user_id: string,
    $realm_id: string,
    $action: "create" | "read" | "update" | "delete",
    $definition_id: string
  ) -> bool {
  LET $user_record = type::thing("user", $user_id);
  LET $realm_record = type::thing("realm", $realm_id);
  LET $definition_record = type::thing("definition", $definition_id);

  LET $is_enabled = SELECT VALUE is_enabled FROM ONLY $user_record;
  IF $is_enabled != true {
    RETURN false;
  };

  LET $is_superuser = SELECT VALUE is_superuser FROM ONLY $user_record;
  IF $is_superuser = true {
    RETURN true;
  };

  RETURN SELECT VALUE array::len(
    roles[
      WHERE realm = $realm_record
      AND (
        ($action = "create" AND $definition_record IN can_create) OR
        ($action = "read" AND $definition_record IN can_read) OR
        ($action = "update" AND $definition_record IN can_update) OR
        ($action = "delete" AND $definition_record IN can_delete)
      )
    ]
  ) > 0 FROM ONLY $user_record;
};

COMMIT TRANSACTION;
