from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List
from app.core.database import get_db
from app.core.security import get_current_user
from app.models.database import User, Pet
from app.schemas.pets import PetCreate, PetUpdate, PetResponse, PetListResponse

router = APIRouter(prefix="/pets", tags=["pets"])

@router.get("/", response_model=PetListResponse)
def list_pets(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    pets = db.query(Pet).filter(Pet.user_id == current_user.id).all()
    return {"pets": pets}

@router.post("/", response_model=PetResponse)
def create_pet(
    pet: PetCreate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    db_pet = Pet(
        user_id=current_user.id,
        name=pet.name,
        breed=pet.breed,
        age=pet.age,
        weight=pet.weight,
        medical_history=pet.medical_history,
        profile_image_url=pet.profile_image_url
    )
    db.add(db_pet)
    db.commit()
    db.refresh(db_pet)
    return db_pet

@router.get("/{pet_id}", response_model=PetResponse)
def get_pet(
    pet_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    pet = db.query(Pet).filter(
        Pet.id == pet_id,
        Pet.user_id == current_user.id
    ).first()
    
    if not pet:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Pet not found"
        )
    
    return pet

@router.put("/{pet_id}", response_model=PetResponse)
def update_pet(
    pet_id: str,
    pet_update: PetUpdate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    pet = db.query(Pet).filter(
        Pet.id == pet_id,
        Pet.user_id == current_user.id
    ).first()
    
    if not pet:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Pet not found"
        )
    
    # Update fields
    update_data = pet_update.dict(exclude_unset=True)
    for field, value in update_data.items():
        setattr(pet, field, value)
    
    db.commit()
    db.refresh(pet)
    return pet

@router.delete("/{pet_id}")
def delete_pet(
    pet_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    pet = db.query(Pet).filter(
        Pet.id == pet_id,
        Pet.user_id == current_user.id
    ).first()
    
    if not pet:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Pet not found"
        )
    
    db.delete(pet)
    db.commit()
    return {"message": "Pet deleted successfully"}