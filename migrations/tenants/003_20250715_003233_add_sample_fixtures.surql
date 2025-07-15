-- Migration: add sample fixtures

BEGIN TRANSACTION;

--------------------------------------------------------------------------------

CREATE realm:main SET title = "Main";
CREATE realm:manila SET title = "Manila";
CREATE realm:brisbane SET title = "Brisbane";
CREATE realm:seoul SET title = "Seoul";

CREATE role:admin SET title = "Main Admin", realm = realm:main;
CREATE role:leader SET title = "Main User", realm = realm:main;
CREATE role:guest SET title = "Main Guest", realm = realm:main;

CREATE person:admin_profile SET first_name = "Admin", last_name = "User";
CREATE person:leader_profile SET first_name = "Leader", last_name = "User";
CREATE person:guest_profile SET first_name = "Guest", last_name = "User";

CREATE user:admin SET
  email = "admin@example.com",
  password = crypto::argon2::generate("password"),
  profile = person:admin_profile,
  roles = [role:admin];

CREATE user:leader SET
  email = "leader@example.com",
  password = crypto::argon2::generate("password"),
  profile = person:leader_profile,
  roles = [role:leader];

CREATE user:guest SET
  email = "guest@example.com",
  password = crypto::argon2::generate("password"),
  profile = person:guest_profile,
  roles = [role:guest];

CREATE definition:group SET title = "Group";

RELATE role:admin->has_permission->definition:group SET action = "create";
RELATE role:admin->has_permission->definition:group SET action = "read";
RELATE role:admin->has_permission->definition:group SET action = "update";
RELATE role:admin->has_permission->definition:group SET action = "delete";

RELATE role:leader->has_permission->definition:group SET action = "read";
RELATE role:leader->has_permission->definition:group SET action = "update";
RELATE role:leader->has_permission->definition:group SET action = "delete";

RELATE role:guest->has_permission->definition:group SET action = "read";

--------------------------------------------------------------------------------

COMMIT TRANSACTION;
