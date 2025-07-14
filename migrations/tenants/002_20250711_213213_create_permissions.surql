-- Migration: create permissions

BEGIN TRANSACTION;

--------------------------------------------------------------------------------

DEFINE TABLE realm SCHEMALESS;

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
DEFINE FIELD updated_at ON role TYPE datetime VALUE time::now();
DEFINE FIELD created_at ON role TYPE datetime VALUE time::now() READONLY;

--------------------------------------------------------------------------------

DEFINE TABLE role_for TYPE RELATION FROM role TO realm ENFORCED;
DEFINE TABLE has_role TYPE RELATION FROM user TO role ENFORCED;
DEFINE TABLE can_create TYPE RELATION FROM role TO definition ENFORCED;
DEFINE TABLE can_read TYPE RELATION FROM role TO definition ENFORCED;
DEFINE TABLE can_update TYPE RELATION FROM role TO definition ENFORCED;
DEFINE TABLE can_delete TYPE RELATION FROM role TO definition ENFORCED;

--------------------------------------------------------------------------------

COMMIT TRANSACTION;
