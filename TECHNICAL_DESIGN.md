# Technical Design Document: AI-Powered Pet Health Tracker

## 1. Introduction & Project Overview

This document outlines the technical design and implementation plan for the AI-Powered Pet Health Tracker mobile application. The project's goal is to build a cross-platform mobile app (iOS & Android) that allows pet owners to monitor their pet's health using AI-powered image analysis, log health metrics, and connect with veterinarians.

The project will be developed by a team of four specialized AI agents working in parallel, with this document serving as the single source of truth for all components.

**Target Timeline:** MVP completion in 3 hours.

## 2. System Architecture

The system follows a standard client-server architecture:

-   **Frontend**: A Flutter-based mobile application for iOS and Android.
-   **Backend**: A FastAPI (Python) application serving a RESTful API.
-   **Database**: A PostgreSQL database for data persistence.
-   **AI/ML Services**: Google Vertex AI (Gemini Pro) for image analysis.
-   **Cloud Platform**: All backend services will be hosted on Google Cloud Platform (GCP).
-   **Authentication**: Firebase Authentication will be used for user management.
-   **File Storage**: Google Cloud Storage (GCS) for storing user-uploaded images.
-   **Notifications**: Firebase Cloud Messaging (FCM) for push notifications.

## 3. Technology Stack

| Component | Technology |
| :--- | :--- |
| **Frontend** | Flutter |
| **Backend** | FastAPI (Python) |
| **Database** | PostgreSQL (via Cloud SQL) |
| **AI/ML** | Google Vertex AI Gemini 2.5 Pro |
| **Cloud Platform** | Google Cloud Platform (GCP) |
| **Authentication** | Firebase Authentication |
| **File Storage** | Google Cloud Storage |
| **Push Notifications** | Firebase Cloud Messaging (FCM) |

## 4. Database Schema

The database will be hosted on a Cloud SQL PostgreSQL instance.

### **`users` Table**
```sql
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
```

### **`pets` Table**
```sql
CREATE TABLE pets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    breed VARCHAR(100),
    age INTEGER,
    weight NUMERIC(5, 2),
    medical_history TEXT,
    profile_image_url VARCHAR(255),
    created_at TIMESTAMPTZ DEFAULT NOW()
);
```

### **`health_logs` Table**
```sql
CREATE TYPE log_type AS ENUM ('weight', 'temperature', 'vet_visit', 'vaccination', 'symptom');

CREATE TABLE health_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    pet_id UUID REFERENCES pets(id) ON DELETE CASCADE,
    log_type log_type NOT NULL,
    value VARCHAR(255),
    notes TEXT,
    image_urls TEXT[],
    ai_analysis JSONB,
    created_at TIMESTAMPTZ DEFAULT NOW()
);
```

### **`veterinarians` Table**
```sql
CREATE TABLE veterinarians (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    clinic_name VARCHAR(255),
    license_number VARCHAR(100),
    phone VARCHAR(20),
    created_at TIMESTAMPTZ DEFAULT NOW()
);
```

### **`medications` Table**
```sql
CREATE TYPE prescription_type AS ENUM ('user_added', 'ai_extracted', 'vet_prescribed');

CREATE TABLE medications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
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
```

### **`vet_prescriptions` Table**
```sql
CREATE TABLE vet_prescriptions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    vet_id UUID REFERENCES veterinarians(id) ON DELETE CASCADE,
    pet_id UUID REFERENCES pets(id) ON DELETE CASCADE,
    medication_id UUID REFERENCES medications(id) ON DELETE CASCADE,
    notes TEXT,
    prescribed_at TIMESTAMPTZ DEFAULT NOW()
);
```

## 5. API Specification

The backend will expose the following RESTful endpoints.

### **Authentication (`/auth`)**
-   `POST /register`: Register a new user.
-   `POST /login`: Log in a user.
-   `POST /refresh`: Refresh authentication token.

### **Pet Management (`/pets`)**
-   `GET /`: List all pets for the authenticated user.
-   `POST /`: Create a new pet profile.
-   `GET /{id}`: Get details for a specific pet.
-   `PUT /{id}`: Update a pet's details.
-   `DELETE /{id}`: Delete a pet.

### **AI Analysis (`/ai`)**
-   `POST /analyze-health`: Upload a photo of a pet for health analysis.
-   `POST /analyze-medication`: Upload a photo of medication for information extraction.

### **Health Records (`/health`)**
-   `POST /log`: Add a new manual health log entry.
-   `GET /log/{pet_id}`: Get the health history for a specific pet.
-   `POST /photos`: Upload photos associated with a health log.

### **Notifications (`/notifications`)**
-   `POST /schedule`: Schedule a new notification.
-   `GET /`: Get all notifications for the authenticated user.

### **Veterinarian Portal (`/vet`)**
-   `POST /register`: Register a new veterinarian.
-   `POST /login`: Authenticate a veterinarian.
-   `GET /search-users`: Search for app users by email or phone.
-   `POST /prescriptions`: Add a new prescription for a user's pet.
-   `GET /prescriptions`: View prescription history for the authenticated vet.

## 6. Codebase Structure

### **Flutter Frontend (`lib/`)**

**State Management:** The Flutter application **must** use the BLoC (Business Logic Component) pattern for state management. This ensures a scalable architecture by separating UI from business logic. All screen-level state will be managed by Blocs, which process events and emit states.

**Directory Structure:**
```
lib/
├── api/
│   ├── api_service.dart
│   └── api_models.dart
├── blocs/
│   ├── auth/
│   │   ├── auth_bloc.dart
│   │   ├── auth_event.dart
│   │   └── auth_state.dart
│   └── pets/
│       ├── pets_bloc.dart
│       ├── pets_event.dart
│       └── pets_state.dart
├── models/
│   ├── pet.dart
│   └── user.dart
├── repositories/
│   ├── auth_repository.dart
│   └── pet_repository.dart
├── screens/
│   ├── auth/
│   ├── pets/
│   ├── health/
│   └── camera/
├── widgets/
└── main.dart
```

### **FastAPI Backend (`app/`)**
```
app/
├── main.py
├── models/
├── routers/
│   ├── auth.py
│   ├── pets.py
│   ├── health.py
│   └── ai.py
├── services/
│   ├── ai_service.py
│   └── notification_service.py
└── database/
    └── models.py
```

## 7. MVP Scope & Known Limitations

-   **MVP Success Criteria**:
    1.  User registration and pet profile creation.
    2.  Successful AI analysis of pet health photos.
    3.  Successful medication information extraction.
    4.  Functional manual health logging.
    5.  Veterinarian login and prescription creation.
    6.  Vet prescriptions trigger user notifications.
    7.  App deployed to iOS and Android.
-   **Limitations for MVP**:
    -   Health issue detection is limited and not a diagnostic tool.
    -   English language only.
    -   Veterinarian portal is web-only.
    -   UI/UX is functional, not polished.

## 8. Security & Deployment

-   **Security**:
    -   Implement API rate limiting.
    -   Set image upload size limits (e.g., 10MB).
    -   Use input validation and sanitization on all endpoints.
    -   Enforce HTTPS.
-   **Deployment**:
    -   **Backend**: FastAPI application deployed to Google Cloud Run.
    -   **Database**: Cloud SQL for PostgreSQL instance.
    -   **Storage**: Google Cloud Storage for image uploads.
    -   **Environments**: Separate staging and production environments.
