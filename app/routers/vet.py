from fastapi import APIRouter, Depends, HTTPException, status, Query
from sqlalchemy.orm import Session
from typing import List, Optional
from app.core.database import get_db
from app.core.security import get_current_vet
from app.models.database import Veterinarian, User, Pet, Medication, VetPrescription, PrescriptionType
from app.schemas.vet import UserSearchResponse, PrescriptionCreate, PrescriptionResponse, PrescriptionListResponse

router = APIRouter(prefix="/vet", tags=["veterinarian"])

@router.get("/search-users", response_model=List[UserSearchResponse])
def search_users(
    email: Optional[str] = Query(None),
    current_vet: Veterinarian = Depends(get_current_vet),
    db: Session = Depends(get_db)
):
    if not email:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Email parameter is required"
        )
    
    # Search for users by email (partial match)
    users = db.query(User).filter(User.email.ilike(f"%{email}%")).limit(10).all()
    
    # Include pets for each user
    result = []
    for user in users:
        user_data = {
            "id": user.id,
            "email": user.email,
            "created_at": str(user.created_at),
            "pets": [
                {
                    "id": pet.id,
                    "name": pet.name,
                    "breed": pet.breed,
                    "age": pet.age
                } for pet in user.pets
            ]
        }
        result.append(user_data)
    
    return result

@router.post("/prescriptions", response_model=PrescriptionResponse)
def create_prescription(
    prescription: PrescriptionCreate,
    current_vet: Veterinarian = Depends(get_current_vet),
    db: Session = Depends(get_db)
):
    # Verify pet exists
    pet = db.query(Pet).filter(Pet.id == prescription.pet_id).first()
    if not pet:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Pet not found"
        )
    
    # Create medication
    medication = Medication(
        pet_id=prescription.pet_id,
        prescribed_by_vet_id=current_vet.id,
        name=prescription.medication.name,
        dosage=prescription.medication.dosage,
        frequency=prescription.medication.frequency,
        instructions=prescription.medication.instructions,
        start_date=prescription.medication.start_date,
        end_date=prescription.medication.end_date,
        prescription_type=PrescriptionType.vet_prescribed
    )
    db.add(medication)
    db.commit()
    db.refresh(medication)
    
    # Create prescription record
    vet_prescription = VetPrescription(
        vet_id=current_vet.id,
        pet_id=prescription.pet_id,
        medication_id=medication.id,
        notes=prescription.notes
    )
    db.add(vet_prescription)
    db.commit()
    db.refresh(vet_prescription)
    
    # Return prescription with related data
    return {
        "id": vet_prescription.id,
        "vet_id": vet_prescription.vet_id,
        "pet_id": vet_prescription.pet_id,
        "medication_id": vet_prescription.medication_id,
        "notes": vet_prescription.notes,
        "prescribed_at": str(vet_prescription.prescribed_at),
        "medication": {
            "id": medication.id,
            "name": medication.name,
            "dosage": medication.dosage,
            "frequency": medication.frequency,
            "instructions": medication.instructions
        },
        "pet": {
            "id": pet.id,
            "name": pet.name,
            "breed": pet.breed
        }
    }

@router.get("/prescriptions", response_model=PrescriptionListResponse)
def get_prescriptions(
    current_vet: Veterinarian = Depends(get_current_vet),
    db: Session = Depends(get_db)
):
    prescriptions = db.query(VetPrescription).filter(
        VetPrescription.vet_id == current_vet.id
    ).order_by(VetPrescription.prescribed_at.desc()).all()
    
    result = []
    for prescription in prescriptions:
        medication = db.query(Medication).filter(Medication.id == prescription.medication_id).first()
        pet = db.query(Pet).filter(Pet.id == prescription.pet_id).first()
        
        prescription_data = {
            "id": prescription.id,
            "vet_id": prescription.vet_id,
            "pet_id": prescription.pet_id,
            "medication_id": prescription.medication_id,
            "notes": prescription.notes,
            "prescribed_at": str(prescription.prescribed_at),
            "medication": {
                "id": medication.id,
                "name": medication.name,
                "dosage": medication.dosage,
                "frequency": medication.frequency,
                "instructions": medication.instructions
            } if medication else None,
            "pet": {
                "id": pet.id,
                "name": pet.name,
                "breed": pet.breed
            } if pet else None
        }
        result.append(prescription_data)
    
    return {"prescriptions": result}