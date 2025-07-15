-- Migration: add sample fixtures

BEGIN TRANSACTION;

--------------------------------------------------------------------------------

DELETE realm:main;
DELETE realm:manila;
DELETE realm:brisbane;
DELETE realm:seoul;
DELETE role:admin;
DELETE role:leader;
DELETE role:guest;
DELETE person:admin_profile;
DELETE person:leader_profile;
DELETE person:guest_profile;
DELETE user:admin;
DELETE user:leader;
DELETE user:guest;
DELETE definition:group;

--------------------------------------------------------------------------------

COMMIT TRANSACTION;
