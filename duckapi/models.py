from sqlalchemy import Column, Date, Integer, String

from .database import Base


class Duck(Base):
    __tablename__ = "Duck"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, index=True)
    age = Column(Integer, index=True)
    color = Column(String, index=True)
