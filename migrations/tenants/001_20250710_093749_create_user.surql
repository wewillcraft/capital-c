-- Migration: create user

BEGIN TRANSACTION;

DEFINE TABLE user SCHEMAFULL
  PERMISSIONS
    FOR select, update WHERE id = $auth.id,
    FOR create, delete NONE;
DEFINE FIELD email ON user TYPE string
  ASSERT
    $value != NONE
    AND string::is::email($value);
DEFINE FIELD password ON user TYPE string;
DEFINE FIELD created_at ON user TYPE datetime DEFAULT time::now();
DEFINE FIELD enabled ON user TYPE bool DEFAULT true;

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

COMMIT TRANSACTION;