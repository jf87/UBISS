import ujson
import db
from flask import Flask, request, Response, g, jsonify
from flask.ext.restful import Resource, Api, abort
from werkzeug.exceptions import NotFound,  UnsupportedMediaType

DEFAULT_DB_PATH = 'db/citizens.db'
MIME_TYPE = "application/json"

app = Flask(__name__)
app.debug = True
app.config.update({'DATABASE':db.CitizenDatabase(DEFAULT_DB_PATH)})
api = Api(app)

def create_error_response(status_code, title, message, resource_type=None):
    response = jsonify(title=title, message=message, resource_type=resource_type)
    response.status_code = status_code
    return response

@app.errorhandler(404)
def resource_not_found(error):
    return create_error_response(404, "Resource not found", "This resource url does not exit")

@app.errorhandler(500)
def unknown_error(error):
    return create_error_response(500, "Error", "The system has failed. Please, contact the administrator")

@app.before_request
def set_database():
    '''Stores an instance of the database API before each request in the flas.g
    variable accessible only from the application context'''
    g.db = app.config['DATABASE']

## Added for CORS
@app.after_request
def after_request(response):
  response.headers.add('Access-Control-Allow-Origin', '*')
  response.headers.add('Access-Control-Allow-Headers', 'Content-Type,Authorization')
  response.headers.add('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE')
  return response

class Volunteers(Resource):
    def get(self):
        volunteers = g.db.get_volunteers()
        return Response (ujson.dumps(volunteers), 200, mimetype=MIME_TYPE)

    def post(self):
        data = request.get_json()
        if not data:
            raise UnsupportedMediaType()

        try:
            uuid = data['volunteer_id']
            nickname = data['nickname']
            #Create the new message and build the response code'
            newid = g.db.create_volunteer(uuid, nickname)
            if not newid:
                abort(500)
        except:
           return create_error_response(400, "Wrong request format",
                                             "Be sure you include volunteer ID and nickname",
                                             "Volunteers")
        url = api.url_for(Volunteer, volunteerid=uuid)

        return Response(status=201, headers={'Location':url})

class Volunteer(Resource):
    def get(self, volunteerid):
        volunteer_db = g.db.get_volunteer(volunteerid)
        if not volunteer_db:
            return create_error_response(404, "Unknown volunteer",
                                         "There is no volunteer with id %s" % volunteerid,
                                         "Volunteer")
        
        return Response (ujson.dumps(volunteer_db), 200, mimetype=MIME_TYPE)


class VolunteerStatus(Resource):
    def post(self, volunteerid):
        data = request.get_json()
        if not data:
            raise UnsupportedMediaType()

        try:
            status = data['status']
            vid = g.db.modify_volunteer_status(volunteerid, status)
            if not vid:
                abort(500)
        except:
            return create_error_response(400, "Wrong request format",
                                             "Be sure you include volunteer ID and status",
                                             "Volunteer")
        url = api.url_for(Volunteer, volunteerid=volunteerid)

        return Response(status=201, headers={'Location':url})

class VolunteerLocation(Resource):
    def post(self, volunteerid):
        data = request.get_json()
        if not data:
            raise UnsupportedMediaType()

        try:
            vid = g.db.modify_volunteer_location(volunteerid, data['longitude'], data['latitude'])
            if not vid:
                abort(500)
        except:
            return create_error_response(400, "Wrong request format",
                                             "Be sure you include volunteer ID, longitude and latitude",
                                             "Volunteer")
        url = api.url_for(Volunteer, volunteerid=volunteerid)

        return Response(status=201, headers={'Location':url})

class VolunteerScore(Resource):
    def post(self, volunteerid):
        data = request.get_json()
        if not data:
            raise UnsupportedMediaType()

        try:
            vid = g.db.modify_volunteer_location(volunteerid, data['score'])
            if not vid:
                abort(500)
        except:
            return create_error_response(400, "Wrong request format",
                                             "Be sure you include volunteer ID and the new Score",
                                             "Volunteer")
        url = api.url_for(Volunteer, volunteerid=volunteerid)

        return Response(status=201, headers={'Location':url})



class Citizens(Resource):
    def get(self):
        citizens = g.db.get_citizens()
        return Response (ujson.dumps(citizens), 200, mimetype=MIME_TYPE)
    
    def post(self):
        data = request.get_json()
        if not data:
            raise UnsupportedMediaType()

        try:
            uuid = data['citizen_id']
            nickname = data['name']
            address = data['address']
            newid = g.db.create_citizen(uuid, nickname, address)
            if not newid:
                abort(500)
        except:
            return create_error_response(400, "Wrong request format",
                                             "Be sure you include citizen ID, name and Address",
                                             "Citizens")
        url = api.url_for(Citizen, citizenid=uuid)

        return Response(status=201, headers={'Location':url})

class Citizen(Resource):
    def get(self, citizenid):
        citizen = g.db.get_citizen(citizenid)
        if not citizen:
            return create_error_response(404, "Unknown citizen",
                                         "There is no citizen with id %s" % citizenid,
                                         "Citizen")
        
        return Response (ujson.dumps(citizen), 200, mimetype=MIME_TYPE)


class HelpRequests(Resource):
    def get(self):
        volunteerid = request.args.get('volunteer_id', '-1')
        if volunteerid is None:
            return create_error_response(404, "Can't get requests",
                                         "There is no volunteerid parameter",
                                         "HelpRequest")

        requests = g.db.get_help_requests(volunteerid)
        return Response (ujson.dumps(requests), 200, mimetype=MIME_TYPE)

    def post(self):
        data = request.get_json()
        if not data:
            raise UnsupportedMediaType()

        try:
            volunteer_id = data['volunteer_id']
            citizen_id = data['citizen_id']
            helpRequest = data['request']
            newid = g.db.create_help_request(volunteer_id, citizen_id, helpRequest)
            if not newid:
                abort(500)
        except:
            return create_error_response(400, "Wrong request format",
                                             "Be sure you include volunteer_id, citizen ID and request",
                                             "HelpRequests")

        url = api.url_for(HelpRequest, requestid=newid)
        return Response(status=201, headers={'Location':url})


class HelpRequest(Resource):
    def get(self, requestid):
        helpRequest = g.db.get_help_request(requestid)
        if not helpRequest:
            return create_error_response(404, "Unknown request",
                                         "There is no request with id %s" % requestid,
                                         "HelpRequest")
        
        return Response (ujson.dumps(helpRequest), 200, mimetype=MIME_TYPE)

    def post(self, requestid):
        data = request.get_json()
        if not data:
            raise UnsupportedMediaType()

        try:
            answer = data['answer']
            vid = g.db.modify_help_request(requestid, answer)
            if not vid:
                abort(500)
        except:
            #This is launched if either title or body does not exist or if 
            # the template.data array does not exist.
            return create_error_response(400, "Wrong request format",
                                             "Be sure you include volunteer ID and answer",
                                             "HelpRequest")

        url = api.url_for(HelpRequest, requestid=requestid)

        return Response(status=201, headers={'Location':url})

api.add_resource(Volunteers,'/volunteers/',
                 endpoint='volunteers')
api.add_resource(Volunteer,'/volunteers/<volunteerid>',
                 endpoint='volunteer')
api.add_resource(VolunteerStatus,'/volunteers/<volunteerid>/status',
                 endpoint='status')
api.add_resource(VolunteerLocation,'/volunteers/<volunteerid>/location',
                 endpoint='location')
api.add_resource(VolunteerScore,'/volunteers/<volunteerid>/score',
                 endpoint='score')

api.add_resource(Citizens,'/citizens/',
                 endpoint='citizens')

api.add_resource(Citizen,'/citizens/<citizenid>',
                 endpoint='citizen')

api.add_resource(HelpRequests,'/requests/',
                 endpoint='requests')

api.add_resource(HelpRequest,'/requests/<requestid>',
                 endpoint='request')

if __name__ == "__main__":
    app.run(host='0.0.0.0')
