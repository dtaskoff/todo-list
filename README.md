# todo-list
A simple RESTful application written during a Haskell workshop

## Setup
If you haven't already, [install stack](https://haskell-lang.org/get-started)

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
  "done":false
}
```

The same format is used for `POST` and `PUT` methods, but the field *done* is optional when `POST`ing and all fields are optional when `PUT`ting.

Possible extensions:
* place the tasks in different todo lists
* use a database
* add users
