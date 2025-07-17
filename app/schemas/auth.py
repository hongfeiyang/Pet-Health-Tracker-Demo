from pydantic import BaseModel, EmailStr, field_serializer
from typing import Optional
from datetime import datetime

class UserCreate(BaseModel):
    email: EmailStr
    password: str

class UserLogin(BaseModel):
    email: EmailStr
    password: str

class UserResponse(BaseModel):
    id: str
    email: str
    created_at: datetime
    
    @field_serializer('created_at')
    def serialize_created_at(self, created_at: datetime, _info):
        return created_at.isoformat()
    
    class Config:
        from_attributes = True

class VetCreate(BaseModel):
    email: EmailStr
    password: str
    name: str
    clinic_name: Optional[str] = None
    license_number: Optional[str] = None
    phone: Optional[str] = None

class VetLogin(BaseModel):
    email: EmailStr
    password: str

class VetResponse(BaseModel):
    id: str
    email: str
    name: Optional[str]
    clinic_name: Optional[str]
    license_number: Optional[str]
    phone: Optional[str]
    created_at: datetime
    
    @field_serializer('created_at')
    def serialize_created_at(self, created_at: datetime, _info):
        return created_at.isoformat()
    
    class Config:
        from_attributes = True

class Token(BaseModel):
    access_token: str
    token_type: str

class TokenData(BaseModel):
    user_id: Optional[str] = None
    user_type: Optional[str] = "user"