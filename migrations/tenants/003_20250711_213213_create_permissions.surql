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

CREATE realm:main SET title = "Main", description = "The Main Realm";

DEFINE EVENT prevent_deletion_of_main_realm ON TABLE realm WHEN $value.id = realm:main THEN {
  THROW "Main realm cannot be deleted";
};

--------------------------------------------------------------------------------

DEFINE TABLE child_realm_of TYPE RELATION FROM realm TO realm ENFORCED;

--------------------------------------------------------------------------------

DEFINE TABLE definition SCHEMALESS;

DEFINE FIELD id ON definition TYPE string ASSERT {
  IF string::matches(record::id($value), "[^a-zA-Z0-9]") {
    THROW "ID must only contain alphanumeric characters";
  };
  RETURN true;
};
DEFINE FIELD _parent ON definition TYPE option<string>;
DEFINE FIELD _internal ON definition TYPE bool DEFAULT false;
DEFINE FIELD title ON definition TYPE string;
DEFINE FIELD description ON definition TYPE option<string>;
DEFINE FIELD versions ON definition TYPE array<object> DEFAULT [];
DEFINE FIELD show_in_ui ON definition TYPE bool DEFAULT true;
DEFINE FIELD updated_at ON definition TYPE datetime VALUE time::now();
DEFINE FIELD created_at ON definition TYPE datetime VALUE time::now() READONLY;

CREATE definition:definition SET title = "Definition", _internal = true;
CREATE definition:group SET title = "Group", _internal = true;

DEFINE EVENT prevent_deletion_of_internal_definitions ON TABLE definition
WHEN $event = "DELETE"
  AND $value._internal = true THEN
{
  THROW "Internal definitions cannot be deleted";
};

DEFINE EVENT parent_definition_must_be_internal ON TABLE definition
WHEN $event = "CREATE" THEN {
  IF $value._parent = NONE AND $value._internal = false THEN {
    THROW "Regular definitions must have an internal parent definition";
  } END;

  LET $parent_definition = type::thing("definition", $value._parent);
  IF not(record::exists($parent_definition)) THEN {
    THROW "Parent definition does not exist";
  } END;

  LET $is_internal = SELECT VALUE _internal FROM ONLY $parent_definition;
  IF not($is_internal) THEN {
    THROW "Parent definition must be internal";
  } END;
};

DEFINE EVENT prevent_deletion_of_definitions_in_use ON TABLE definition
WHEN $event = "DELETE" THEN {
  LET $relevant_tables = ["group"];
  FOR $table_name IN $relevant_tables {
    LET $records = SELECT VALUE count() FROM ONLY type::table($table_name) WHERE _definition = record::id($value.id);
    IF $records > 0 THEN {
      THROW "Definition is still in use";
    } END;
  };
};

--------------------------------------------------------------------------------

DEFINE TABLE role SCHEMALESS;

DEFINE FIELD title ON role TYPE string;
DEFINE FIELD description ON role TYPE option<string>;
DEFINE FIELD updated_at ON role TYPE datetime VALUE time::now();
DEFINE FIELD created_at ON role TYPE datetime VALUE time::now() READONLY;

--------------------------------------------------------------------------------

DEFINE TABLE role_for TYPE RELATION FROM role TO realm ENFORCED;
DEFINE FIELD created_at ON role_for TYPE datetime VALUE time::now() READONLY;

--------------------------------------------------------------------------------

DEFINE TABLE has_role TYPE RELATION FROM user TO role ENFORCED;
DEFINE FIELD created_at ON has_role TYPE datetime VALUE time::now() READONLY;

--------------------------------------------------------------------------------

DEFINE TABLE has_permission TYPE RELATION FROM role TO definition ENFORCED;
DEFINE FIELD action ON has_permission TYPE "create" | "read" | "update" | "delete";
DEFINE FIELD created_at ON has_permission TYPE datetime VALUE time::now() READONLY;

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

  -- Get the realms from the root realm to the target realm
  -- and check if the user has a permission from the higher realms first.
  LET $realm_ids = realm:main.{..+shortest=$realm_record+inclusive}<-child_realm_of<-realm;
  FOR $realm_id IN $realm_ids {
    LET $has_permission = SELECT VALUE array::len(
      ->has_role->role[
        WHERE ->role_for->realm[WHERE id = $realm_id]
        AND ->has_permission[WHERE action = $action AND out = $definition_record]
      ]
    ) > 0 FROM ONLY $user_record;
    IF $has_permission {
      RETURN true;
    };
  };
  RETURN false;
};

COMMIT TRANSACTION;
