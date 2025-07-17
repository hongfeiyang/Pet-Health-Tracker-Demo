from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.core.database import get_db
from app.core.security import verify_password, get_password_hash, create_access_token, get_current_user
from app.models.database import User, Veterinarian
from app.schemas.auth import UserCreate, UserLogin, UserResponse, VetCreate, VetLogin, VetResponse, Token

router = APIRouter(prefix="/auth", tags=["authentication"])

@router.post("/register", response_model=UserResponse)
def register_user(user: UserCreate, db: Session = Depends(get_db)):
    # Check if user already exists
    db_user = db.query(User).filter(User.email == user.email).first()
    if db_user:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Email already registered"
        )
    
    # Create new user
    hashed_password = get_password_hash(user.password)
    db_user = User(
        email=user.email,
        password_hash=hashed_password
    )
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    
    return db_user

@router.post("/login", response_model=Token)
def login_user(user: UserLogin, db: Session = Depends(get_db)):
    # Authenticate user
    db_user = db.query(User).filter(User.email == user.email).first()
    if not db_user or not verify_password(user.password, db_user.password_hash):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect email or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    # Create access token
    access_token = create_access_token(
        data={"sub": db_user.id, "type": "user"}
    )
    return {"access_token": access_token, "token_type": "bearer"}

@router.post("/refresh", response_model=Token)
def refresh_token(current_user: User = Depends(get_current_user)):
    access_token = create_access_token(
        data={"sub": current_user.id, "type": "user"}
    )
    return {"access_token": access_token, "token_type": "bearer"}

# Vet authentication endpoints
@router.post("/vet/register", response_model=VetResponse)
def register_vet(vet: VetCreate, db: Session = Depends(get_db)):
    # Check if vet already exists
    db_vet = db.query(Veterinarian).filter(Veterinarian.email == vet.email).first()
    if db_vet:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Email already registered"
        )
    
    # Create new vet
    hashed_password = get_password_hash(vet.password)
    db_vet = Veterinarian(
        email=vet.email,
        password_hash=hashed_password,
        name=vet.name,
        clinic_name=vet.clinic_name,
        license_number=vet.license_number,
        phone=vet.phone
    )
    db.add(db_vet)
    db.commit()
    db.refresh(db_vet)
    
    return db_vet

@router.post("/vet/login", response_model=Token)
def login_vet(vet: VetLogin, db: Session = Depends(get_db)):
    # Authenticate vet
    db_vet = db.query(Veterinarian).filter(Veterinarian.email == vet.email).first()
    if not db_vet or not verify_password(vet.password, db_vet.password_hash):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect email or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    # Create access token
    access_token = create_access_token(
        data={"sub": db_vet.id, "type": "vet"}
    )
    return {"access_token": access_token, "token_type": "bearer"}