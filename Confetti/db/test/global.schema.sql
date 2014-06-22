PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;

-----------------------------------------------------------------------------------------------

CREATE TABLE "projects" (
	[name] text PRIMARY KEY NOT NULL UNIQUE,
	int_branch text NOT NULL,
	admin_vob text,
	cspec text NOT NULL);

-----------------------------------------------------------------------------------------------

CREATE TABLE activities (
	name text PRIMARY KEY NOT NULL UNIQUE, 
	view text UNIQUE NOT NULL, 
	branch text UNIQUE NOT NULL, 
	project text NOT NULL,
	user text NOT NULL, 
	last_mark integer);

-----------------------------------------------------------------------------------------------

COMMIT;
