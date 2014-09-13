PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;

-----------------------------------------------------------------------------------------------

INSERT INTO "projects" (id, name, branch, cspec) VALUES(1, 'ucgw-7.7', 'ucgw-7.7_int', '');
INSERT INTO "projects" (id, name, branch, cspec) VALUES(2, 'mcu-8.0',  'mcu-8.0_int',  '');
INSERT INTO "projects" (id, name, branch, cspec) VALUES(3, 'mcu-8.3',  'mcu-8.3_int',  '');

-----------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------

INSERT INTO "activities" (name, view, branch, project_id, user, cspec, icheck) VALUES('rafie_prod-1', 'rafie_prod-1', 'rafie_prod-1_br', 2, 'rafie', '', 0);
INSERT INTO "activities" (name, view, branch, project_id, user, cspec, icheck) VALUES('myact1',       'myact1',       'myact1_br',       3, '',      '', 0);

-----------------------------------------------------------------------------------------------

COMMIT;
	
