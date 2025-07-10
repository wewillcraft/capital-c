-- Down migration: setup_user

BEGIN TRANSACTION;

REMOVE INDEX user_email_index ON user;
REMOVE ACCESS user ON DATABASE;
REMOVE TABLE user;

COMMIT TRANSACTION;