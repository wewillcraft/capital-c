-- Migration: create events

BEGIN TRANSACTION;

--------------------------------------------------------------------------------

REMOVE TABLE IF EXISTS location;
REMOVE TABLE IF EXISTS event;
REMOVE TABLE IF EXISTS event_instance;
REMOVE TABLE IF EXISTS instance_of;
REMOVE TABLE IF EXISTS located_at;
REMOVE TABLE IF EXISTS attended;
REMOVE TABLE IF EXISTS ticket;
REMOVE TABLE IF EXISTS ticket_for;
DEFINE TABLE OVERWRITE has_realm TYPE RELATION FROM group TO realm ENFORCED;

--------------------------------------------------------------------------------

COMMIT TRANSACTION;
