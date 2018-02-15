# todo-list
A simple RESTful application written during a Haskell workshop

## Setup
If you haven't already, [install stack](https://haskell-lang.org/get-started)

## Running
The following command starts the application on port 3000:
```sh
stack build && stack exec todo-list
```

## Application
We'll manage tasks (in-memory) that have a title, a description and current status (todo and done).

REST API:
* GET    /task - return all tasks
* GET    /task/:id - return a task
* POST   /task - create a new task and return it
* PUT    /task/:id - update a task and return it
* DELETE /task/:id - remove a task and return it

The returned tasks are in the following JSON format:

```json
{
  "tid":0,
  "title":"Haskell Workshop",
  "description":"Run a Haskell Workshop",
  "status":"todo"
}
```

The same format (omitting *tid*) is used for `POST` and `PUT` methods, but the field *status* is optional when `POST`ing and all fields are optional when `PUT`ting.


--------------------------

Currently only the POST method is implemented (partially).
It can be tested with:
```sh
curl localhost:3000/task -d @[workshop.json](./workshop.json)
```

Possible extensions:
* place the tasks in different todo lists
* use a database
* add users
