from pymongo import MongoClient
from bson.objectid import ObjectId
from . import schemas

import os

mongo_host = os.getenv("MONGO_HOST", "localhost")

client = MongoClient(f'mongodb://${mongo_host}:27017/')
duck_collection = client['ducks']['ducks_collection']

def duck_helper(duck):
    return schemas.Duck(id = str(duck["_id"]),name = duck["name"], color = duck["color"], age = duck["age"])

def get_all_ducks():
    ducks = []
    for duck in duck_collection.find({}):
        ducks.append(duck_helper(duck))
    return ducks

# Add a new duck into to the database
def create_duck(duck: schemas.DuckBase):
    print(duck.dict())
    duck.color = duck.color.upper()
    duck = duck_collection.insert_one(duck.dict())
    new_duck = duck_collection.find_one({"_id": duck.inserted_id})
    return duck_helper(new_duck)


# Retrieve a duck with a matching ID
def get_duck(id: str):
    duck = duck_collection.find_one({"_id": ObjectId(id)})
    if duck:
        return duck_helper(duck)


# Update a duck with a matching ID
def update_duck(id: str, duck: schemas.UpdateDuck):
    if duck.color:
        duck.color = duck.color.upper()
    if duck_collection.find_one({"_id": ObjectId(id)}):
        updated_duck = duck_collection.update_one(
            {"_id": ObjectId(id)}, {"$set": duck.dict()},
            upsert=False
        )
        return duck_helper(duck_collection.find_one({"_id": ObjectId(id)}))
    else:
        return None


# Delete a duck from the database
def delete_duck(id: str):
    duck = duck_collection.find_one({"_id": ObjectId(id)})
    if duck:
        duck_collection.delete_one({"_id": ObjectId(id)})