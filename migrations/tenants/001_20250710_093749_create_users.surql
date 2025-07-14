-- Migration: create users

BEGIN TRANSACTION;

--------------------------------------------------------------------------------

DEFINE TABLE user SCHEMAFULL
  PERMISSIONS
    FOR select, update WHERE id = $auth.id,
    FOR create, delete NONE;

DEFINE FIELD email ON user TYPE string
  ASSERT
    $value != NONE
    AND string::is::email($value);
DEFINE FIELD password ON user TYPE string;
DEFINE FIELD enabled ON user TYPE bool DEFAULT true;
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
    IF !$auth.enabled {
      THROW 'This user is not enabled';
    };

    RETURN $auth;
  };

DEFINE INDEX user_email_index ON user COLUMNS email UNIQUE;

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

DEFINE TABLE is_person TYPE RELATION FROM user TO person ENFORCED;

--------------------------------------------------------------------------------

COMMIT TRANSACTION;
