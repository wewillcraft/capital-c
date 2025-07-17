-- Migration: create events

BEGIN TRANSACTION;

--------------------------------------------------------------------------------

DEFINE TABLE location SCHEMALESS;

DEFINE FIELD title ON location TYPE string;
DEFINE FIELD description ON location TYPE option<string>;
DEFINE FIELD updated_at ON location TYPE datetime VALUE time::now();
DEFINE FIELD created_at ON location TYPE datetime VALUE time::now() READONLY;

--------------------------------------------------------------------------------

DEFINE TABLE event SCHEMALESS;

DEFINE FIELD title ON event TYPE string;
DEFINE FIELD description ON event TYPE option<string>;
DEFINE FIELD updated_at ON event TYPE datetime VALUE time::now();
DEFINE FIELD created_at ON event TYPE datetime VALUE time::now() READONLY;

--------------------------------------------------------------------------------

DEFINE TABLE event_instance SCHEMALESS;

DEFINE FIELD start_at ON event_instance TYPE datetime;
DEFINE FIELD end_at ON event_instance TYPE datetime;
DEFINE FIELD updated_at ON event_instance TYPE datetime VALUE time::now();
DEFINE FIELD created_at ON event_instance TYPE datetime VALUE time::now() READONLY;

--------------------------------------------------------------------------------

DEFINE TABLE instance_of TYPE RELATION FROM event_instance TO event ENFORCED;

--------------------------------------------------------------------------------

DEFINE TABLE located_at TYPE RELATION FROM event_instance TO location ENFORCED;

--------------------------------------------------------------------------------

COMMIT TRANSACTION;
