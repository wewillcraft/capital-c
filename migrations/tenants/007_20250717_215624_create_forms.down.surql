-- Migration: create forms

BEGIN TRANSACTION;

--------------------------------------------------------------------------------

REMOVE TABLE IF EXISTS form;
REMOVE TABLE IF EXISTS form_response;
REMOVE TABLE IF EXISTS submitted;
REMOVE TABLE IF EXISTS response_for;
DEFINE TABLE OVERWRITE has_realm TYPE RELATION FROM event|group|ticket TO realm ENFORCED;

--------------------------------------------------------------------------------

COMMIT TRANSACTION;
