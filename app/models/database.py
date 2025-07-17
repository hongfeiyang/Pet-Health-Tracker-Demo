from sqlalchemy import Column, String, Integer, Numeric, Text, DateTime, ForeignKey, Enum, JSON, ARRAY
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.sql import func
import uuid
import enum

Base = declarative_base()

class LogType(enum.Enum):
    weight = "weight"
    temperature = "temperature"
    vet_visit = "vet_visit"
    vaccination = "vaccination"
    symptom = "symptom"

class PrescriptionType(enum.Enum):
    user_added = "user_added"
    ai_extracted = "ai_extracted"
    vet_prescribed = "vet_prescribed"

class User(Base):
    __tablename__ = "users"
    
    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    email = Column(String(255), unique=True, nullable=False)
    password_hash = Column(String(255), nullable=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())
    
    pets = relationship("Pet", back_populates="owner", cascade="all, delete-orphan")

class Pet(Base):
    __tablename__ = "pets"
    
    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    user_id = Column(String, ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    name = Column(String(100), nullable=False)
    breed = Column(String(100))
    age = Column(Integer)
    weight = Column(Numeric(5, 2))
    medical_history = Column(Text)
    profile_image_url = Column(String(255))
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    
    owner = relationship("User", back_populates="pets")
    health_logs = relationship("HealthLog", back_populates="pet", cascade="all, delete-orphan")
    medications = relationship("Medication", back_populates="pet", cascade="all, delete-orphan")

class HealthLog(Base):
    __tablename__ = "health_logs"
    
    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    pet_id = Column(String, ForeignKey("pets.id", ondelete="CASCADE"), nullable=False)
    log_type = Column(Enum(LogType), nullable=False)
    value = Column(String(255))
    notes = Column(Text)
    image_urls = Column(JSON)  # Store as JSON array for SQLite
    ai_analysis = Column(JSON)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    
    pet = relationship("Pet", back_populates="health_logs")

class Veterinarian(Base):
    __tablename__ = "veterinarians"
    
    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    email = Column(String(255), unique=True, nullable=False)
    password_hash = Column(String(255), nullable=False)
    name = Column(String(255))
    clinic_name = Column(String(255))
    license_number = Column(String(100))
    phone = Column(String(20))
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    
    medications = relationship("Medication", back_populates="prescribed_by_vet")
    prescriptions = relationship("VetPrescription", back_populates="vet", cascade="all, delete-orphan")

class Medication(Base):
    __tablename__ = "medications"
    
    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    pet_id = Column(String, ForeignKey("pets.id", ondelete="CASCADE"), nullable=False)
    prescribed_by_vet_id = Column(String, ForeignKey("veterinarians.id", ondelete="SET NULL"))
    name = Column(String(255), nullable=False)
    dosage = Column(String(100))
    frequency = Column(String(100))
    instructions = Column(Text)
    start_date = Column(DateTime)
    end_date = Column(DateTime)
    image_url = Column(String(255))
    prescription_type = Column(Enum(PrescriptionType), nullable=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    
    pet = relationship("Pet", back_populates="medications")
    prescribed_by_vet = relationship("Veterinarian", back_populates="medications")
    prescriptions = relationship("VetPrescription", back_populates="medication", cascade="all, delete-orphan")

class VetPrescription(Base):
    __tablename__ = "vet_prescriptions"
    
    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    vet_id = Column(String, ForeignKey("veterinarians.id", ondelete="CASCADE"), nullable=False)
    pet_id = Column(String, ForeignKey("pets.id", ondelete="CASCADE"), nullable=False)
    medication_id = Column(String, ForeignKey("medications.id", ondelete="CASCADE"), nullable=False)
    notes = Column(Text)
    prescribed_at = Column(DateTime(timezone=True), server_default=func.now())
    
    vet = relationship("Veterinarian", back_populates="prescriptions")
    pet = relationship("Pet")
    medication = relationship("Medication", back_populates="prescriptions")