PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;

-----------------------------------------------------------------------------------------------

INSERT INTO "projects" (id, name, branch) VALUES(1, 'ucgw-7.7', 'ucgw-7.7_int');
INSERT INTO "projects" (id, name, branch) VALUES(2, 'mcu-8.0',  'mcu-8.0_int');
INSERT INTO "projects" (id, name, branch) VALUES(3, 'mcu-8.3',  'mcu-8.3_int');

-----------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------

INSERT INTO "activities" (name, view, branch, project_id, user, cspec, icheck) VALUES('user_prod-1', 'user_prod-1', 'user_prod-1', 2, 'user', '', 0);
INSERT INTO "activities" (name, view, branch, project_id, user, cspec, icheck) VALUES('myact1',       'myact1',     'myact1',      3, '',     '', 0);

-----------------------------------------------------------------------------------------------

COMMIT;
	
