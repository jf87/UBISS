PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS volunteers(
  volunteer_id TEXT PRIMARY KEY,
  nickname TEXT,
  status TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL);

CREATE TABLE IF NOT EXISTS volunteers_postions(
  volunteer_id TEXT,
  longitude REAL,
  latitude REAL,
  ptimestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL);

CREATE TABLE IF NOT EXISTS citizens(
  citizen_id TEXT PRIMARY KEY,
  name TEXT,
  address TEXT);

CREATE TABLE IF NOT EXISTS requests(
  request_id INTEGER PRIMARY KEY AUTOINCREMENT,
  volunteer_id TEXT,
  citizen_id TEXT,
  request TEXT,
  answer TEXT,
  status INTEGER, /* 0: Pending, 1: In Progress, 2: Closed*/
  rtimestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  answered_at TIMESTAMP);

COMMIT;
PRAGMA foreign_keys=ON;