-- Migration: create users

BEGIN TRANSACTION;

--------------------------------------------------------------------------------

DEFINE TABLE person SCHEMALESS;

DEFINE FIELD last_name ON person TYPE option<string>;
DEFINE FIELD first_name ON person TYPE option<string>;
DEFINE FIELD middle_name ON person TYPE option<string>;
DEFINE FIELD suffix ON person TYPE option<string>;
DEFINE FIELD gender ON person TYPE option<"male" | "female">;
DEFINE FIELD birth_date ON person TYPE option<datetime>;
DEFINE FIELD deceased_date ON person TYPE option<datetime>;
DEFINE FIELD updated_at ON person TYPE datetime VALUE time::now();
DEFINE FIELD created_at ON person TYPE datetime VALUE time::now() READONLY;

--------------------------------------------------------------------------------

DEFINE TABLE user SCHEMALESS
  PERMISSIONS
    FOR select, update WHERE id = $auth.id,
    FOR create, delete NONE;

DEFINE FIELD email ON user TYPE string
  ASSERT
    $value != NONE
    AND string::is::email($value);
DEFINE FIELD password ON user TYPE string;
DEFINE FIELD is_enabled ON user TYPE bool DEFAULT true;
DEFINE FIELD is_superuser ON user TYPE option<bool> DEFAULT false;
DEFINE FIELD profile ON user TYPE option<record<person>>;
DEFINE FIELD roles ON user TYPE option<array<record<role>>>;
DEFINE FIELD updated_at ON user TYPE datetime VALUE time::now();
DEFINE FIELD created_at ON user TYPE datetime VALUE time::now() READONLY;

DEFINE ACCESS user ON DATABASE TYPE RECORD
  SIGNUP (
    CREATE user CONTENT {
      email: $email,
      password: crypto::argon2::generate($password)
    }
  )
  SIGNIN (
    SELECT * FROM user WHERE email = $email
    AND crypto::argon2::compare(password, $password)
  )
  AUTHENTICATE {
    IF !$auth.is_enabled {
      THROW 'This user is not enabled';
    };

    RETURN $auth;
  };

DEFINE INDEX user_email_index ON user COLUMNS email UNIQUE;

--------------------------------------------------------------------------------

COMMIT TRANSACTION;
