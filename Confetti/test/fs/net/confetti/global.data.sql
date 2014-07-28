PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;

-----------------------------------------------------------------------------------------------

INSERT INTO "projects" (name, branch, cspec) VALUES('ucgw-7.7', 'ucgw_7.7_int_br', '');
INSERT INTO "projects" (name, branch, cspec) VALUES('mcu-8.0',  'mcu_8.0_int_br',  '');
INSERT INTO "projects" (name, branch, cspec) VALUES('mcu-8.3',  'mcu_8.3_int_br',  '');

-----------------------------------------------------------------------------------------------

COMMIT;
