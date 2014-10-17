PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;

-----------------------------------------------------------------------------------------------

CREATE TABLE "projects" (
	[id] integer PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE, 
	[name] text NOT NULL UNIQUE,
	branch text NOT NULL,
	cspec text /*NOT NULL*/);

CREATE TABLE "project_versions" (
	[id] integer PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE,
	project_id integer NOT NULL,
	version text NOT NULL,
	cspec text /*NOT NULL*/,
	UNIQUE(project_id, version));

-----------------------------------------------------------------------------------------------

CREATE TABLE views (
	id integer PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE,  
	name text NOT NULL UNIQUE, 
	user text NOT NULL, 
	cspec text NOT NULL);

-----------------------------------------------------------------------------------------------

CREATE TABLE activities (
	id integer PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE,  
	name text NOT NULL UNIQUE, 
	view text UNIQUE NOT NULL, 
	branch text UNIQUE NOT NULL, 
	project_id integer NOT NULL,
	user text NOT NULL, 
	cspec text NOT NULL,
	icheck integer);

-----------------------------------------------------------------------------------------------

COMMIT;
