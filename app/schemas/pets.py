from pydantic import BaseModel, field_serializer
from typing import Optional, List
from decimal import Decimal
from datetime import datetime

class PetCreate(BaseModel):
    name: str
    breed: Optional[str] = None
    age: Optional[int] = None
    weight: Optional[Decimal] = None
    medical_history: Optional[str] = None
    profile_image_url: Optional[str] = None

class PetUpdate(BaseModel):
    name: Optional[str] = None
    breed: Optional[str] = None
    age: Optional[int] = None
    weight: Optional[Decimal] = None
    medical_history: Optional[str] = None
    profile_image_url: Optional[str] = None

class PetResponse(BaseModel):
    id: str
    user_id: str
    name: str
    breed: Optional[str]
    age: Optional[int]
    weight: Optional[Decimal]
    medical_history: Optional[str]
    profile_image_url: Optional[str]
    created_at: datetime
    
    @field_serializer('created_at')
    def serialize_created_at(self, created_at: datetime, _info):
        return created_at.isoformat()
    
    class Config:
        from_attributes = True

class PetListResponse(BaseModel):
    pets: List[PetResponse]