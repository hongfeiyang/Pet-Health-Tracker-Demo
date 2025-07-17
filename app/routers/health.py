from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List
from app.core.database import get_db
from app.core.security import get_current_user
from app.models.database import User, Pet, HealthLog
from app.schemas.health import HealthLogCreate, HealthLogResponse, HealthLogListResponse, PhotoUpload

router = APIRouter(prefix="/health", tags=["health"])

@router.post("/log", response_model=HealthLogResponse)
def create_health_log(
    log: HealthLogCreate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    # Verify pet belongs to user
    pet = db.query(Pet).filter(
        Pet.id == log.pet_id,
        Pet.user_id == current_user.id
    ).first()
    
    if not pet:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Pet not found"
        )
    
    db_log = HealthLog(
        pet_id=log.pet_id,
        log_type=log.log_type,
        value=log.value,
        notes=log.notes,
        image_urls=log.image_urls
    )
    db.add(db_log)
    db.commit()
    db.refresh(db_log)
    return db_log

@router.get("/log/{pet_id}", response_model=HealthLogListResponse)
def get_health_logs(
    pet_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    # Verify pet belongs to user
    pet = db.query(Pet).filter(
        Pet.id == pet_id,
        Pet.user_id == current_user.id
    ).first()
    
    if not pet:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Pet not found"
        )
    
    logs = db.query(HealthLog).filter(HealthLog.pet_id == pet_id).order_by(HealthLog.created_at.desc()).all()
    return {"logs": logs}

@router.post("/photos")
def upload_photos(
    photo: PhotoUpload,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    # For MVP, we'll just return a placeholder URL
    # In production, this would upload to cloud storage
    return {
        "message": "Photo uploaded successfully",
        "image_url": f"https://storage.example.com/photos/{current_user.id}/photo.jpg"
    }