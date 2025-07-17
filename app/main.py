from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.core.database import create_tables
from app.routers import auth, pets, health, ai, vet

# Create tables on startup
create_tables()

app = FastAPI(
    title="Pet Health Tracker API",
    description="AI-Powered Pet Health Tracker Backend",
    version="1.0.0"
)

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, specify exact origins
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(auth.router)
app.include_router(pets.router)
app.include_router(health.router)
app.include_router(ai.router)
app.include_router(vet.router)

@app.get("/")
def read_root():
    return {
        "message": "Pet Health Tracker API",
        "version": "1.0.0",
        "docs": "/docs"
    }

@app.get("/health")
def health_check():
    return {"status": "healthy"}