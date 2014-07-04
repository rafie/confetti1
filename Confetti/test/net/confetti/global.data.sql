PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;

-----------------------------------------------------------------------------------------------

INSERT INTO "projects" (name, branch, root_vob) VALUES('main',     'main',            '');
INSERT INTO "projects" (name, branch, root_vob) VALUES('ucgw-7.7', 'ucgw_7.7_int_br', '');
INSERT INTO "projects" (name, branch, root_vob) VALUES('ucgw-8.0', 'ucgw_8.0_int_br', '');
INSERT INTO "projects" (name, branch, root_vob) VALUES('mcu-7.7',  'mcu_7.7_int_br',  '');
INSERT INTO "projects" (name, branch, root_vob) VALUES('mcu-8.0',  'mcu_8.0_int_br',  '');
INSERT INTO "projects" (name, branch, root_vob) VALUES('test',     'test_int_br',     '.test');

-----------------------------------------------------------------------------------------------
/*
INSERT INTO "activities" VALUES('rafie_prod-1','rafie_prod-1','rafie_prod-1_br','','mcu-8.0','rafie',1);
INSERT INTO "activities" VALUES('myact1','myact1','myact1_br','','main','',0);
*/
-----------------------------------------------------------------------------------------------

COMMIT;
