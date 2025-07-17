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

DEFINE TABLE has_parent_realm TYPE RELATION FROM realm TO realm ENFORCED;

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
  LET $realm_ids = realm:main.{..+shortest=$realm_record+inclusive}<-has_parent_realm<-realm;
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
