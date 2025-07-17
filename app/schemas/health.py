from pydantic import BaseModel, field_serializer
from typing import Optional, List, Any
from datetime import datetime
from app.models.database import LogType

class HealthLogCreate(BaseModel):
    pet_id: str
    log_type: LogType
    value: Optional[str] = None
    notes: Optional[str] = None
    image_urls: Optional[List[str]] = []

class HealthLogResponse(BaseModel):
    id: str
    pet_id: str
    log_type: LogType
    value: Optional[str]
    notes: Optional[str]
    image_urls: Optional[List[str]]
    ai_analysis: Optional[dict]
    created_at: datetime
    
    @field_serializer('created_at')
    def serialize_created_at(self, created_at: datetime, _info):
        return created_at.isoformat()
    
    class Config:
        from_attributes = True

class HealthLogListResponse(BaseModel):
    logs: List[HealthLogResponse]

class PhotoUpload(BaseModel):
    image_data: str  # Base64 encoded image