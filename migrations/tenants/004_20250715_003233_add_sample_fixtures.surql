-- Migration: add sample fixtures

BEGIN TRANSACTION;

--------------------------------------------------------------------------------

CREATE user:admin SET email = "admin@example.com", password = crypto::argon2::generate("password");
CREATE user:leader SET email = "leader@example.com", password = crypto::argon2::generate("password");
CREATE user:guest SET email = "guest@example.com", password = crypto::argon2::generate("password");

CREATE realm:manila SET title = "Manila";
CREATE realm:brisbane SET title = "Brisbane";
CREATE realm:seoul SET title = "Seoul";
CREATE realm:manilacampus SET title = "Manila Campus";
CREATE realm:brisbanecampus SET title = "Brisbane Campus";
CREATE realm:seoulcampus SET title = "Seoul Campus";

RELATE realm:manila->child_realm_of->realm:main;
RELATE realm:brisbane->child_realm_of->realm:main;
RELATE realm:seoul->child_realm_of->realm:main;
RELATE realm:manilacampus->child_realm_of->realm:manila;
RELATE realm:brisbanecampus->child_realm_of->realm:brisbane;
RELATE realm:seoulcampus->child_realm_of->realm:seoul;

CREATE definition:group SET title = "Group";

CREATE role:main_admin SET title = "Main Admin";
CREATE role:main_leader SET title = "Main User";
CREATE role:main_guest SET title = "Main Guest";
CREATE role:seoulcampus_admin SET title = "Seoul Campus Admin";

RELATE role:main_admin->role_for->realm:main;
RELATE role:main_leader->role_for->realm:main;
RELATE role:main_guest->role_for->realm:main;
RELATE role:seoulcampus_admin->role_for->realm:seoulcampus;

RELATE user:admin->has_role->role:main_admin;
RELATE user:leader->has_role->role:main_leader;
RELATE user:guest->has_role->role:main_guest;
RELATE user:leader->has_role->role:seoulcampus_admin;

RELATE role:main_admin->has_permission->definition:group SET action = "create";
RELATE role:main_admin->has_permission->definition:group SET action = "read";
RELATE role:main_admin->has_permission->definition:group SET action = "update";
RELATE role:main_admin->has_permission->definition:group SET action = "delete";

RELATE role:main_leader->has_permission->definition:group SET action = "read";
RELATE role:main_leader->has_permission->definition:group SET action = "update";

RELATE role:main_guest->has_permission->definition:group SET action = "read";
RELATE role:seoulcampus_admin->has_permission->definition:group SET action = "create";

--------------------------------------------------------------------------------

COMMIT TRANSACTION;
