#import db
import ujson

from flask import Flask, request, Response, g, jsonify
from flask.ext.restful import Resource, Api, abort
from werkzeug.exceptions import NotFound,  UnsupportedMediaType

app = Flask(__name__)
app.debug = True
api = Api(app)

class Volunteers(Resource):
    def get(self):
        volunteers = [{
            "volunteer_id": "12345678-1234-5678-1234-567812345678",
            "nickname":"Mikko",
            "status": "ready",
            "created_at": "2014-11-11T08:40:51.620Z",
            "last_position": {"longitude": 65, "latitude": 24.5}
        }]
        return volunteers

    def post(self):
        data = request.get_json()
        if not data:
            raise UnsupportedMediaType()

        try:
            uuid = data['volunteer_id']
        except:
            abort (400)

        #uuid = "12345678-1234-5678-1234-567812345678"
        url = api.url_for(Volunteer, volunteerid=uuid)

        return Response(status=201, headers={'Location':url})

class Volunteer(Resource):
    def get(self, volunteerid):
        volunteer = {
            "volunteer_id": volunteerid,
            "nickname":"Mikko",
            "status": "ready",
            "created_at": "2014-11-11T08:40:51.620Z",
            "last_position": {"longitude": 65, "latitude": 24.5}
            }
        return volunteer

class VolunteerStatus(Resource):
    def post(self, volunteerid):
        data = request.get_json()
        if not data:
            raise UnsupportedMediaType()

        try:
            status = data['status']
        except:
            abort (400)

        uuid = "12345678-1234-5678-1234-567812345678"
        url = api.url_for(Volunteer, volunteerid=uuid)

        return Response(status=201, headers={'Location':url})

class VolunteerLocation(Resource):
    def post(self, volunteerid):
        data = request.get_json()
        if not data:
            raise UnsupportedMediaType()

        try:
            location = {"longitude": data['longitude'], "latitude": data['latitude']}
        except:
            abort (400)

        #uuid = "12345678-1234-5678-1234-567812345678"
        url = api.url_for(Volunteer, volunteerid=volunteerid)

        return Response(status=201, headers={'Location':url})


class Citizens(Resource):
    def get(self):
        citizens = [{
            "citizen_id": "12345678-1234-5678-1234-567812345678",
            "address": "Yliopistokatu 16",
            "created_at": "2014-11-11T08:40:51.620Z"
        }]
        return citizens
    
    def post(self):
        data = request.get_json()
        if not data:
            raise UnsupportedMediaType()

        try:
            uuid = data['citizen_id']
            address = data['address']
        except:
            abort (400)

        #uuid = "12345678-1234-5678-1234-567812345678"
        url = api.url_for(Citizen, citizenid=uuid)

        return Response(status=201, headers={'Location':url})

class Citizen(Resource):
    def get(self, citizenid):
        citizen = {
            "citizen_id": citizenid,
            "address":"Yliopistokatu 16",
            "created_at": "2014-11-11T08:40:51.620Z"
            }
        return citizen

class HelpRequests(Resource):
    def get(self):
        volunteerid = request.args.get('volunteerid', '-1')
        helpRequests = [{
            "request_id": "12345678-1234-5678-1234-567812345678",
            "volunteerid": volunteerid,
            "citizenid": "12345678-4321-8765-1234-567812345678",
            "request": "some items to buy please!",
            "answer": "Sure!",
            "status": "in progress"
        }]
        return helpRequests

    def post(self):
        data = request.get_json()
        if not data:
            raise UnsupportedMediaType()

        try:
            volunteer_id = data['volunteer_id']
            citizen_id = data['citizen_id']
            request = data['request']
        except:
            abort (400)

        uuid = "87654321-1234-5678-1234-567812345678"
        url = api.url_for(HelpRequest, requestid=uuid)

        return Response(status=201, headers={'Location':url})

class HelpRequest(Resource):
    def get(self, requestid):
        volunteerid = request.args.get('uid', '-1')
        helpRequest = {
            "request_id": "12345678-1234-5678-1234-567812345678",
            "volunteerid": volunteerid,
            "citizenid": "12345678-4321-8765-1234-567812345678",
            "request": "some items to buy please!",
            "answer": "Sure!",
            "status": "in progress"
        }
        return helpRequest

    def post(self, requestid):
        data = request.get_json()
        if not data:
            raise UnsupportedMediaType()

        try:
            volunteer_id = data['volunteer_id']
            answer = data['answer']
        except:
            abort (400)

        url = api.url_for(HelpRequest, requestid=requestid)

        return Response(status=201, headers={'Location':url})

api.add_resource(Citizens,'/citizens/',endpoint='citizens')

api.add_resource(Citizen,'/citizens/<citizenid>',
                 endpoint='citizen')

api.add_resource(Volunteers,'/volunteers',
                 endpoint='volunteers')
api.add_resource(Volunteer,'/volunteers/<volunteerid>',
                 endpoint='volunteer')
api.add_resource(VolunteerStatus,'/volunteers/<volunteerid>/status',
                 endpoint='status')
api.add_resource(VolunteerLocation,'/volunteers/<volunteerid>/location',
                 endpoint='location')

api.add_resource(HelpRequests,'/requests/',
                 endpoint='requests')
api.add_resource(HelpRequest,'/requests/<requestid>',
                 endpoint='request')

if __name__ == "__main__":
    app.run()