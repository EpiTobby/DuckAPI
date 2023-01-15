from datetime import date as date_type
from typing import Optional

from pydantic import BaseModel, Field


class DuckBase(BaseModel):
    name: str = Field(..., example="Duck Name", description="Name of the Duck")
    age: int = Field(..., example=1, description="Age of the Duck")
    color: str = Field(..., example="Duck Color", description="Color of the Duck")


class Duck(DuckBase):
    id: str

    class Config:
        orm_mode = True

class UpdateDuck(BaseModel):
    name: Optional[str] = Field(..., example="Duck Name", description="Name of the Duck")
    age: Optional[int] = Field(..., example=1, description="Age of the Duck")
    color: Optional[str] = Field(..., example="Duck Color", description="Color of the Duck")