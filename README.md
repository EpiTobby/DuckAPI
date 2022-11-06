## DuckAPI

# Prerequisites
* Python3
* Poetry

# Dependencies
Run `poetry install` to install dependencies.

# Usage
To launch the server, run : `poetry run uvicorn duckapi.app:app --reload --port=8080`

To run test, run: `poetry run pytest`

# Documentation
Documentation can be found at `${HOST}/docs`

eg. When run in local at port `8080`, the documentation is at `http://localhost:8080/docs`