from sqlalchemy.orm import Session

from . import models, schemas


def get_all_ducks(db: Session):
    return db.query(models.Duck).all()


def get_duck(db: Session, duck_id: int):
    return db.query(models.Duck).filter(models.Duck.id == duck_id).first()


def create_duck(db: Session, duck: schemas.DuckBase):
    db_duck = models.Duck(**duck.dict())
    db.add(db_duck)
    db.commit()
    db.refresh(db_duck)
    return db_duck


def delete_duck(db: Session, duck_id: int):
    db.query(models.Duck).filter(models.Duck.id == duck_id).delete()
    db.commit()


def update_duck(db: Session, duck_id: int, duck: schemas.DuckBase):
    db_duck = db.query(models.Duck).filter(models.Duck.id == duck_id).first()
    if db_duck is None:
        return None
    db_duck.name = duck.name
    db_duck.age = duck.age
    db_duck.color = duck.color
    db.commit()
    return db_duck
