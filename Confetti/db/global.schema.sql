PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;

-----------------------------------------------------------------------------------------------

CREATE TABLE "projects" (
	[id] integer PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE, 
	[name] text NOT NULL UNIQUE,
	branch text NOT NULL,
	root_vob text,
	cspec text /*NOT NULL*/);

CREATE TABLE "project_versions" (
	[id] PRIMARY KEY NOT NULL UNIQUE,
	project_id integer NOT NULL,
	version text NOT NULL,
	cspec text NOT NULL,
	UNIQUE(project_id, version));

-----------------------------------------------------------------------------------------------
/*
CREATE TABLE activities (
	id integer PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE,  
	name text NOT NULL UNIQUE, 
	view text UNIQUE NOT NULL, 
	branch text UNIQUE NOT NULL, 
	root text,
	project text NOT NULL,
	user text NOT NULL, 
	last_mark integer);
*/
-----------------------------------------------------------------------------------------------

COMMIT;
