-- Create custom types
CREATE TYPE log_type AS ENUM ('weight', 'temperature', 'vet_visit', 'vaccination', 'symptom');
CREATE TYPE prescription_type AS ENUM ('user_added', 'ai_extracted', 'vet_prescribed');

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Users table
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Pets table
CREATE TABLE pets (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    breed VARCHAR(100),
    age INTEGER,
    weight NUMERIC(5, 2),
    medical_history TEXT,
    profile_image_url VARCHAR(255),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Health logs table
CREATE TABLE health_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    pet_id UUID REFERENCES pets(id) ON DELETE CASCADE,
    log_type log_type NOT NULL,
    value VARCHAR(255),
    notes TEXT,
    image_urls TEXT[],
    ai_analysis JSONB,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Veterinarians table
CREATE TABLE veterinarians (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    clinic_name VARCHAR(255),
    license_number VARCHAR(100),
    phone VARCHAR(20),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Medications table
CREATE TABLE medications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    pet_id UUID REFERENCES pets(id) ON DELETE CASCADE,
    prescribed_by_vet_id UUID REFERENCES veterinarians(id) ON DELETE SET NULL,
    name VARCHAR(255) NOT NULL,
    dosage VARCHAR(100),
    frequency VARCHAR(100),
    instructions TEXT,
    start_date DATE,
    end_date DATE,
    image_url VARCHAR(255),
    prescription_type prescription_type NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Vet prescriptions table
CREATE TABLE vet_prescriptions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    vet_id UUID REFERENCES veterinarians(id) ON DELETE CASCADE,
    pet_id UUID REFERENCES pets(id) ON DELETE CASCADE,
    medication_id UUID REFERENCES medications(id) ON DELETE CASCADE,
    notes TEXT,
    prescribed_at TIMESTAMPTZ DEFAULT NOW()
);