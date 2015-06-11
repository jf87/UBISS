## End-points

### /volunteers
+ GET
    Returns a list of available volunteers and their locations

    - Response
    ```
    [{
        "volunteer_id": volunteerid,
        "nickname":"Mikko",
        "status": "ready",
        "created_at": "2014-11-11T08:40:51.620Z",
        "last_position": {"longitude": 65.030366, "latitude": 25.414801},
        "score": 1
    }]
    ```

+ POST
    Creates a new volunteer
    - Request:
    ```
    {
        'volunteer_id': '12345678-1234-5678-1234-567812345678',
        'nickname': 'Mikko'
    }
    ```
   
    - Response:
    ```
    Status: 201
    Location: /volunteers/12345678-1234-5678-1234-567812345678
    ```


### /volunteers/(volunteer_id)
+ GET
    Returns volunteer's data

    - Response
    ```
    {
        "volunteer_id": volunteerid,
        "nickname":"Mikko",
        "status": "ready",
        "created_at": "2014-11-11T08:40:51.620Z",
        "last_position": {"longitude": 65.030366, "latitude": 25.414801}
    }
    ```

### /volunteers/(volunteer_id)/status

+ POST
    Updates the status of the volunteer
    - Request:
    ```
    {'status': 'ready'}
    ```
   
    - Response:
    ```
    Status: 201
    Location: /volunteers/12345678-1234-5678-1234-567812345678
    ```

### /volunteers/(volunteer_id)/location

+ POST
    Updates the location of the volunteer
    - Request:
    `{"longitude": 65.030366, "latitude": 25.414801}`
   
    - Response:
    ```
    Status: 201
    Location: /volunteers/12345678-1234-5678-1234-567812345678
    ```


### /volunteers/(volunteer_id)/score

+ POST
    Sets the score to the given amount
    - Request:
    `{"score": 3}`

    - Response:
    ```
    Status: 201
    Location: /volunteers/12345678-1234-5678-1234-567812345678
    ```

### /citizens
+ GET
    Returns a list of available citizens and their addresses

    - Response
    ```
    [{
        "citizen_id": "12345678-1234-5678-1234-567812345678",
        "address": "Yliopistokatu 16",
        "created_at": "2014-11-11T08:40:51.620Z"
    }]
    ```
+ POST
    Creates a new citizen

    - Request:
    ```
    {
        "citizen_id": "12345678-1234-5678-1234-567812345678",
        "address": "Yliopistokatu 16"
    }
    ```

    - Response:
    ```
    Status: 201
    Location: /volunteers/12345678-1234-5678-1234-567812345678
    ```


### /citizens/(citizen_id)
+ GET
    Returns a citizen data and their addresses

    -Response:
    ```
    {
        "citizen_id": "12345678-1234-5678-1234-567812345678",
        "address": "Yliopistokatu 16",
        "created_at": "2014-11-11T08:40:51.620Z"
    }
    ```

### /requests
+ GET
    Returns a list of available requests for the given volunteer.

    - Parameters:
    `volunteer_id`: ID of the volunteer targeted by the request

    -Response:
    ```
     [{
        "request_id": "12345678-1234-5678-1234-567812345678",
        "volunteerid": volunteerid,
        "citizenid": "12345678-4321-8765-1234-567812345678",
        "request": "some items to buy please!",
        "answer": "Sure!",
        "status": "in progress"
    }]
    ```

### /requests/(request_id)
+ GET
    Returns request's details.

    -Response:
    ```
    {
        "request_id": "12345678-1234-5678-1234-567812345678",
        "volunteerid": volunteerid,
        "citizenid": "12345678-4321-8765-1234-567812345678",
        "request": "some items to buy please!",
        "answer": "Sure!",
        "status": "in progress"
    }
    ```

## Sample JSON objects

### Volunteers
[ (volunteer1), (volunteer2) ... ]

### Volunteer
{
    "volunteer_id": volunteerid,
    "nickname":"Mikko",
    "status": "ready",
    "created_at": "2014-11-11T08:40:51.620Z",
    "last_position": {"longitude": 65, "latitude": 25.414801},
    "score": 1
}

### Citizens
[ (citizen1), (citizen2) ... ]

### Citizen
{
    "citizen_id": citizenid,
    "address":"Yliopistokatu 16",
    "created_at": "2014-11-11T08:40:51.620Z"
}

### Help Requests
[ (request1), (request2) ...]

### Help Request
{
    "request_id": "12345678-1234-5678-1234-567812345678",
    "volunteerid": volunteerid,
    "citizenid": "12345678-4321-8765-1234-567812345678",
    "request": "some items to buy please!",
    "answer": "Sure!",
    "status": "in progress"
}

