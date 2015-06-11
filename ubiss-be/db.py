import sqlite3
from flask import g

DEFAULT_DB_PATH = 'db/citizens.db'
DEFAULT_SCHEMA = "db/schema.sql"
DEFAULT_DATA_DUMP = "db/citizens_data_dump.sql"

def make_dicts(cursor, row):
    return dict((cursor.description[idx][0], value)
                for idx, value in enumerate(row))

class CitizenDatabase(object):
    def __init__(self, db_path):
        '''
        db_path is the address of the path with respect to the calling script.
        If db_path is None, DEFAULT_DB_PATH is used instead.
        '''
        super(CitizenDatabase, self).__init__()
        if db_path is not None:
            self.db_path = db_path
        else:
            self.db_path = DEFAULT_DB_PATH


    def create_tables_from_schema(self, schema=None):
            '''
            Create programmatically the tables from a schema file.
            schema contains the path to the .sql schema file. If it is None,  
            DEFAULT_SCHEMA is used instead. 
            '''
            con = sqlite3.connect(self.db_path)
            if schema is None:
                schema = DEFAULT_SCHEMA
            with open (schema) as f:
                sql = f.read()
                cur = con.cursor()
                cur.executescript(sql)

    def get_volunteers(self):
        keys_on = 'PRAGMA foreign_keys = ON'
        query = 'SELECT * FROM volunteers'
        query_loc = 'SELECT * FROM volunteers_postions \
                     WHERE volunteer_id = ? \
                     ORDER BY ptimestamp DESC \
                     LIMIT 1'

        #Connects to the database.
        con = sqlite3.connect(self.db_path)
        with con:
            #Cursor and row initialization
            con.row_factory = make_dicts
            cur = con.cursor()
            #Provide support for foreign keys
            cur.execute(keys_on)
            #Execute main SQL Statement        
            cur.execute(query)
            #Get results
            rows = cur.fetchall()
            for idx, r in enumerate(rows):
                cur.execute(query_loc, (r['volunteer_id'],))
                r_loc = cur.fetchone()
                if r_loc is not None:
                    rows[idx]['longitude'] = r_loc['longitude']
                    rows[idx]['latitude'] = r_loc['latitude']
                else:
                    rows[idx]['longitude'] = None
                    rows[idx]['latitude'] = None

            return rows

    def get_volunteer(self, volunteerid):
        keys_on = 'PRAGMA foreign_keys = ON'
        query = 'SELECT * FROM volunteers WHERE volunteer_id=?'
        query_loc = 'SELECT * FROM volunteers_postions \
                     WHERE volunteer_id=?\
                     ORDER BY ptimestamp DESC \
                     LIMIT 1'

        #Connects to the database.
        con = sqlite3.connect(self.db_path)
        with con:
            #Cursor and row initialization
            con.row_factory = make_dicts
            cur = con.cursor()
            #Provide support for foreign keys
            cur.execute(keys_on)
            #Execute main SQL Statement        
            pvalue = (volunteerid,)
            cur.execute(query, pvalue)
            #Get results
            row = cur.fetchone()
            
            cur.execute(query_loc, pvalue)
            row_loc = cur.fetchone()
            if row_loc is not None:
                row['longitude'] = row_loc['longitude']
                row['latitude'] = row_loc['latitude']
            else:
                row['longitude'] = None
                row['latitude'] = None
            
            return row

    def create_volunteer(self, volunteer_id, nickname):
        keys_on = 'PRAGMA foreign_keys = ON'
        #SQL Statement for inserting the data
        stmnt = 'INSERT INTO volunteers (volunteer_id, nickname, status)\
                 VALUES(?,?,?)'
        #Connects  to the database. 
        con = sqlite3.connect(self.db_path)
        with con:
            #Cursor and row initialization
            con.row_factory = make_dicts
            cur = con.cursor()
            #Provide support for foreign keys
            cur.execute(keys_on)
            #Generate the values for SQL statement
            pvalue = (volunteer_id, nickname, 'offline')
            #Execute the statement
            cur.execute(stmnt, pvalue)
            #Extract the id of the added message
            lid = cur.lastrowid 
            #Return the id in 
            return lid

    def modify_volunteer_status(self, volunteer_id, status):
        #Create the SQL statment
        keys_on = 'PRAGMA foreign_keys = ON'
        stmnt = 'UPDATE volunteers SET status=? \
                 WHERE volunteer_id = ?'
        #Connects  to the database. 
        con = sqlite3.connect(self.db_path)
        with con:
            #Cursor and row initialization
            con.row_factory = make_dicts
            cur = con.cursor()
            #Provide support for foreign keys
            cur.execute(keys_on)        
            #Execute main SQL Statement
            pvalue = (status, volunteer_id)
            cur.execute(stmnt, pvalue)
            if cur.rowcount < 1:
                return None
            return volunteer_id


    def modify_volunteer_location(self, volunteer_id, lon, lat):
        #Create the SQL statment
        keys_on = 'PRAGMA foreign_keys = ON'
        stmnt = 'INSERT INTO volunteers_postions (volunteer_id, longitude, latitude) \
                 VALUES (?, ?, ?)'
        #Connects  to the database. 
        con = sqlite3.connect(self.db_path)
        with con:
            #Cursor and row initialization
            con.row_factory = make_dicts
            cur = con.cursor()
            #Provide support for foreign keys
            cur.execute(keys_on)        
            #Execute main SQL Statement
            pvalue = (volunteer_id, lon, lat)
            cur.execute(stmnt, pvalue)
            if cur.rowcount < 1:
                return None
            return volunteer_id
