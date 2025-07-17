from pydantic import BaseModel
from typing import Optional, List, Any

class HealthAnalysisRequest(BaseModel):
    pet_id: str
    image_data: str  # Base64 encoded image
    additional_notes: Optional[str] = None

class MedicationAnalysisRequest(BaseModel):
    image_data: str  # Base64 encoded image

class HealthAnalysisResponse(BaseModel):
    pet_id: str
    analysis: dict
    confidence_score: float
    recommendations: List[str]
    concerns: List[str]

class MedicationAnalysisResponse(BaseModel):
    medication_name: Optional[str]
    dosage: Optional[str]
    frequency: Optional[str]
    instructions: Optional[str]
    confidence_score: float
    extracted_text: str