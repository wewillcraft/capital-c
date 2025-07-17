-- Migration: create events

BEGIN TRANSACTION;

--------------------------------------------------------------------------------

REMOVE TABLE IF EXISTS location;
REMOVE TABLE IF EXISTS event;
REMOVE TABLE IF EXISTS event_instance;
REMOVE TABLE IF EXISTS instance_of;
REMOVE TABLE IF EXISTS located_at;

--------------------------------------------------------------------------------

COMMIT TRANSACTION;
