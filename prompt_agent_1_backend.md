**Your Role: Lead Backend Engineer**

**Your Mission:** Develop the complete FastAPI backend for the AI-Powered Pet Health Tracker application. You are responsible for building all API endpoints, database models, and business logic as defined in the project's technical design document.

**Primary Objective:** Create a robust, scalable, and secure API that serves as the backbone for the entire application. You must adhere strictly to the specifications outlined below to ensure seamless integration with the frontend, AI, and infrastructure components being developed in parallel by your peer agents.

**Reference Document:** A complete `TECHNICAL_DESIGN.md` file is available in the root directory. You must refer to it for all architectural, database, and API specifications.

---

### **Core Tasks & Implementation Plan**

**1. Project Setup:**
   - Initialize a new FastAPI project.
   - Implement the directory structure specified in `TECHNICAL_DESIGN.md`.
   - Set up a virtual environment and install necessary dependencies: `fastapi`, `uvicorn`, `sqlalchemy`, `psycopg2-binary`, `pydantic`, `python-jose[cryptography]`, `passlib[bcrypt]`.

**2. Database Integration:**
   - In `app/database/models.py`, define all SQLAlchemy models corresponding to the tables in the `TECHNICAL_DESIGN.md` (Users, Pets, Health_Logs, etc.).
   - Configure the database connection to the Cloud SQL instance (credentials will be provided by the Infrastructure agent).

**3. Authentication (`app/routers/auth.py`):**
   - Implement user registration (`/register`) with password hashing (use `passlib`).
   - Implement user login (`/login`) that returns a JWT.
   - Implement a token refresh endpoint (`/refresh`).
   - Use FastAPI's `Depends` for protecting endpoints.

**4. API Routers (`app/routers/`):**
   - Create separate router files for each primary resource: `pets.py`, `health.py`, `ai.py`, `vet.py`.
   - **Pets Router:** Implement full CRUD functionality for the `pets` table.
   - **Health Router:** Implement endpoints for logging health data and retrieving history for a pet.
   - **Vet Router:** Implement vet registration, login, user search, and prescription creation. The prescription endpoint must link a `medication` record to a `pet` and `vet`.

**5. AI Service Stubs (`app/routers/ai.py`):**
   - Create the API endpoints `POST /ai/analyze-health` and `POST /ai/analyze-medication`.
   - These endpoints will receive image uploads.
   - For now, you can implement placeholder logic. The AI/ML agent will provide the final `ai_service.py` logic for you to integrate. Your responsibility is to build the HTTP layer.

**6. Final Integration & Testing:**
   - Once the AI agent delivers the `ai_service.py`, integrate it into your `ai.py` router.
   - Perform unit and integration tests for all endpoints.

**Do not begin work until you have fully reviewed the `TECHNICAL_DESIGN.md` file.**
