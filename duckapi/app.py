import datetime
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware

from . import __version__, schemas, database
import os

mongo_host = os.getenv("MONGO_HOST", "localhost")

description = """
DuckAPI
"""
tags_metadata = [
    {
        "name": "Ducks",
        "description": "Manage duck.",
    },
]

app = FastAPI(
    title="Duck API",
    description=description,
    version=__version__,
    openapi_tags=tags_metadata,
)

frontend_origin = os.getenv("FRONTEND_URL", "http://localhost:3000")

origins = [
    frontend_origin,
    "http://localhost",
    "http://localhost:8080",
    "http://localhost:3000",
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

start_time = datetime.datetime.now()

@app.get("/")
def uptime():
    current_time = datetime.datetime.now()
    uptime = current_time - start_time
    return {"uptime": str(uptime)}

@app.get("/db")
def get_db():
    return {"db": mongo_host}

@app.get("/ducks", tags=["Ducks"])
async def get_all_ducks():
    return database.get_all_ducks()


@app.get("/ducks/{id}", tags=["Ducks"], response_model=schemas.Duck)
async def get_duck():
    db_duck = await database.get_duck(id)
    if db_duck is None:
        raise HTTPException(status_code=404, detail="Duck not found")
    return db_duck


@app.post("/ducks", tags=["Ducks"], response_model=schemas.Duck, status_code=201)
async def create_duck(duck: schemas.DuckBase):
    db_duck = database.create_duck(duck)
    if db_duck is None:
        raise HTTPException(status_code=400, detail="Duck not created")
    return db_duck


@app.patch("/ducks/{id}", tags=["Ducks"], response_model=schemas.Duck)
async def update_duck(id: str, duck: schemas.UpdateDuck):
    db_duck = database.update_duck(id, duck)
    if db_duck is None:
        raise HTTPException(status_code=404, detail="Duck not found")
    return db_duck


@app.delete("/ducks/{id}", tags=["Ducks"], status_code=204)
async def delete_duck(id: str) -> None:
    db_duck = database.get_duck(id)
    if db_duck is None:
        raise HTTPException(status_code=404, detail="Duck not found")
    database.delete_duck(id=id)
    return None
