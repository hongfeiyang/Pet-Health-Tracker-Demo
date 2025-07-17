from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.core.database import get_db
from app.core.security import get_current_user
from app.models.database import User, Pet
from app.schemas.ai import HealthAnalysisRequest, MedicationAnalysisRequest, HealthAnalysisResponse, MedicationAnalysisResponse
from app.services.ai_service import analyze_health_image, analyze_medication_image

router = APIRouter(prefix="/ai", tags=["ai"])

@router.post("/analyze-health", response_model=HealthAnalysisResponse)
def analyze_health(
    request: HealthAnalysisRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    # Verify pet belongs to user
    pet = db.query(Pet).filter(
        Pet.id == request.pet_id,
        Pet.user_id == current_user.id
    ).first()
    
    if not pet:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Pet not found"
        )
    
    # Prepare pet context for AI analysis
    pet_context = {
        "name": pet.name,
        "breed": pet.breed,
        "age": pet.age,
        "weight": float(pet.weight) if pet.weight else None,
        "medical_history": pet.medical_history
    }
    
    # Analyze image using AI service
    analysis = analyze_health_image(request.image_data, pet_context)
    
    return {
        "pet_id": request.pet_id,
        "analysis": analysis,
        "confidence_score": analysis.get("confidence_score", 0.0),
        "recommendations": analysis.get("recommendations", []),
        "concerns": analysis.get("concerns", [])
    }

@router.post("/analyze-medication", response_model=MedicationAnalysisResponse)
def analyze_medication(
    request: MedicationAnalysisRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    # Analyze medication image using AI service
    analysis = analyze_medication_image(request.image_data)
    
    return {
        "medication_name": analysis.get("medication_name"),
        "dosage": analysis.get("dosage"),
        "frequency": analysis.get("frequency"),
        "instructions": analysis.get("instructions"),
        "confidence_score": analysis.get("confidence_score", 0.0),
        "extracted_text": analysis.get("extracted_text", "")
    }