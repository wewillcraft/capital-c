-- Migration: add sample fixtures

BEGIN TRANSACTION;

--------------------------------------------------------------------------------

CREATE user:admin SET email = "admin@example.com", password = "password";
CREATE user:leader SET email = "leader@example.com", password = "password";
CREATE user:guest SET email = "guest@example.com", password = "password";

CREATE realm:main SET title = "Main";
CREATE realm:manila SET title = "Manila";
CREATE realm:brisbane SET title = "Brisbane";
CREATE realm:seoul SET title = "Seoul";

CREATE definition:group SET title = "Group";

CREATE role:admin SET title = "Main Admin";
CREATE role:leader SET title = "Main User";
CREATE role:guest SET title = "Main Guest";

RELATE user:admin->has_role->role:admin;
RELATE user:leader->has_role->role:leader;
RELATE user:guest->has_role->role:guest;

RELATE role:admin->role_for->realm:main;
RELATE role:leader->role_for->realm:main;
RELATE role:guest->role_for->realm:main;

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
