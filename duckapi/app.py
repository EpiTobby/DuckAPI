from fastapi import Depends, FastAPI, HTTPException
from sqlalchemy.orm import Session

from . import __version__, service, models, schemas
from .database import SessionLocal, engine


description = """
DuckAPI
"""
tags_metadata = [
    {
        "name": "Ducks",
        "description": "Manage duck.",
    },
]

models.Base.metadata.create_all(bind=engine)

app = FastAPI(
    title="service Python Tony Leo API",
    description=description,
    version=__version__,
    openapi_tags=tags_metadata,
)

# Dependency
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


@app.get("/ducks", tags=["Ducks"])
async def get_all_ducks(db: Session = Depends(get_db)):
    db_ducks = service.get_all_ducks(db)
    return db_ducks


@app.get("/ducks/{id}", tags=["Ducks"], response_model=schemas.Duck)
async def get_duck(id: int, db: Session = Depends(get_db)):
    db_duck = service.get_duck(db, duck_id=id)
    if db_duck is None:
        raise HTTPException(status_code=404, detail="Duck not found")
    return db_duck


@app.post("/ducks", tags=["Ducks"], response_model=schemas.Duck, status_code=201)
async def create_duck(duck: schemas.DuckBase, db: Session = Depends(get_db)):
    db_duck = service.create_duck(db, duck=duck)
    if db_duck is None:
        raise HTTPException(status_code=400, detail="Duck not created")
    return db_duck


@app.put("/ducks/{id}", tags=["Ducks"], response_model=schemas.Duck)
async def update_duck(id: int, duck: schemas.DuckBase, db: Session = Depends(get_db)):
    db_duck = service.update_duck(db, duck_id=id, duck=duck)
    if db_duck is None:
        raise HTTPException(status_code=404, detail="Duck not found")
    return db_duck


@app.delete("/ducks/{id}", tags=["Ducks"], status_code=204)
async def delete_duck(id: int, db: Session = Depends(get_db)) -> None:
    db_duck = service.get_duck(db, duck_id=id)
    if db_duck is None:
        raise HTTPException(status_code=404, detail="Duck not found")
    service.delete_duck(db, duck_id=id)
    return None
