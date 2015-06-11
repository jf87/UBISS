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

    def query_db(self, query, args=(), one=False):
        keys_on = 'PRAGMA foreign_keys = ON'
        con = sqlite3.connect(self.db_path)
        with con:
            #Cursor and row initialization
            con.row_factory = make_dicts
            cur = con.cursor()
            #Provide support for foreign keys
            cur.execute(keys_on)
            #Execute main SQL Statement        
            cur.execute(query, args)
            rv = cur.fetchall()
            cur.close()
            return (rv[0] if rv else None) if one else rv

    def execute_db(self, stmt, args=()):
        keys_on = 'PRAGMA foreign_keys = ON'
        #Connects  to the database. 
        con = sqlite3.connect(self.db_path)
        with con:
            #Cursor and row initialization
            con.row_factory = make_dicts
            cur = con.cursor()
            #Provide support for foreign keys
            cur.execute(keys_on)
            #Execute the statement
            cur.execute(stmnt, args)
            #Extract the id of the added message
            lid = cur.lastrowid 
            rc = cur.rowcount
            cur.close()
            #Return the id 
            return (lid, rc)


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

        rows = self.query_db(query)
        for idx, r in enumerate(rows):
            r_loc = self.query_db(query_loc, (r['volunteer_id'],), one=True)
            if r_loc:
                rows[idx]['longitude'] = r_loc['longitude']
                rows[idx]['latitude'] = r_loc['latitude']
            else:
                rows[idx]['longitude'] = None
                rows[idx]['latitude'] = None

        return rows

    def get_volunteer(self, volunteerid):
        query = 'SELECT * FROM volunteers WHERE volunteer_id=?'
        query_loc = 'SELECT * FROM volunteers_postions \
                     WHERE volunteer_id=?\
                     ORDER BY ptimestamp DESC \
                     LIMIT 1'

        pvalue = (volunteerid,)
        row = self.query_db(query, pvalue, one=True)
        row_loc = self.query_db(query_loc, pvalue, one=True)
        if row_loc is not None:
            row['longitude'] = row_loc['longitude']
            row['latitude'] = row_loc['latitude']
        else:
            row['longitude'] = None
            row['latitude'] = None
        
        return row

    def create_volunteer(self, volunteer_id, nickname):
        keys_on = 'PRAGMA foreign_keys = ON'
        stmnt = 'INSERT INTO volunteers (volunteer_id, nickname, status)\
                 VALUES(?,?,?)'
        pvalue = (volunteer_id, nickname, 'offline')
        lid,rc = self.execute_db(stmnt, pvalue)
        return lid

    def modify_volunteer_status(self, volunteer_id, status):
        stmnt = 'UPDATE volunteers SET status=? \
                 WHERE volunteer_id = ?'
        pvalue = (status, volunteer_id)
        lid, rc = self.execute_db(stmnt, pvalue)
        if rc < 1:
            return None
        return volunteer_id


    def modify_volunteer_location(self, volunteer_id, lon, lat):
        stmnt = 'INSERT INTO volunteers_postions (volunteer_id, longitude, latitude) \
                 VALUES (?, ?, ?)'

        pvalue = (volunteer_id, lon, lat)
        lid,rc = self.execute_db(stmnt, pvalue)
        if rc < 1:
            return None
        return volunteer_id


    def modify_volunteer_score(self, volunteer_id, score):
        stmnt = 'INSERT INTO volunteers_postions (volunteer_id, score) \
                 VALUES (?, ?)'

        pvalue = (volunteer_id, score)
        lid,rc = self.execute_db(stmnt, pvalue)
        if rc < 1:
            return None
        return volunteer_id


    def create_citizen(self, citizen_id, name, address):
        stmnt = 'INSERT INTO citizens (citizen_id, name, address)\
                 VALUES(?,?,?)'
        pvalue = (citizen_id, name, address)
        lid,rc = self.execute_db(stmnt, pvalue)
        return lid

    def get_citizens(self):
        query = 'SELECT * FROM citizens'
        rows = self.query_db(query)
        return rows

    def get_citizen(self, citizenid):
        query = 'SELECT * FROM citizens WHERE citizen_id=?'
        row = self.query_db(query, (citizenid,))
        return row

    def create_help_request(self, volunteer_id, citizen_id, request):
        stmnt = 'INSERT INTO helpRequests (volunteer_id, citizen_id, request, status)\
                 VALUES(?,?,?,?)'
        lid, rc = self.execute_db(stmnt, (volunteer_id, citizen_id, request, 0))
        return lid
    
    def get_help_requests(self, volunteerid):
        query = 'SELECT * FROM requests WHERE volunteer_id=? \
                 ORDER BY rtimestamp DESC \
                 LIMIT 10'
        rows = self.query_db(query, (volunteerid))
        return rows

    def get_help_request(self, requestid):
        query = 'SELECT * FROM requests WHERE request_id=?'
        rows = self.query_db(query, (requestid, ))
        return rows

    def modify_help_request(self, request_id, answer):
        stmnt = 'UPDATE requests SET answer=? \
                 WHERE request_id = ?'
        pvalue = (answer, request_id)
        lid, rc = self.execute_db(stmnt, pvalue)
        if rc < 1:
            return None
        return request_id

