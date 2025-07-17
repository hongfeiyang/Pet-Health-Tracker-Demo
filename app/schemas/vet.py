from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime
from app.models.database import PrescriptionType

class UserSearchResponse(BaseModel):
    id: str
    email: str
    created_at: str
    pets: List[dict]  # Simplified pet info
    
    class Config:
        from_attributes = True

class MedicationCreate(BaseModel):
    name: str
    dosage: Optional[str] = None
    frequency: Optional[str] = None
    instructions: Optional[str] = None
    start_date: Optional[datetime] = None
    end_date: Optional[datetime] = None

class PrescriptionCreate(BaseModel):
    pet_id: str
    medication: MedicationCreate
    notes: Optional[str] = None

class PrescriptionResponse(BaseModel):
    id: str
    vet_id: str
    pet_id: str
    medication_id: str
    notes: Optional[str]
    prescribed_at: str
    medication: dict  # Medication details
    pet: dict  # Pet details
    
    class Config:
        from_attributes = True

class PrescriptionListResponse(BaseModel):
    prescriptions: List[PrescriptionResponse]