# Pet Health Tracker - FastAPI Backend

A comprehensive FastAPI backend for the AI-Powered Pet Health Tracker application, featuring user authentication, pet management, health logging, AI image analysis, and veterinarian portal functionality.

## 🏗️ Architecture

This backend implements a modular architecture with the following components:

- **FastAPI Application**: Modern, high-performance web framework
- **SQLAlchemy ORM**: Database abstraction layer with SQLite for development
- **JWT Authentication**: Secure token-based authentication for users and veterinarians  
- **Pydantic Schemas**: Request/response validation and serialization
- **Google Gemini AI**: Image analysis for health assessment and medication extraction
- **Modular Design**: Clean separation of concerns with services and routers

## 📁 Project Structure

```
app/
├── core/
│   ├── config.py          # Application configuration
│   ├── database.py        # Database connection and session management
│   └── security.py        # Authentication and authorization
├── models/
│   └── database.py        # SQLAlchemy database models
├── schemas/
│   ├── auth.py           # Authentication request/response schemas
│   ├── pets.py           # Pet-related schemas
│   ├── health.py         # Health logging schemas
│   ├── ai.py             # AI analysis schemas
│   └── vet.py            # Veterinarian portal schemas
├── routers/
│   ├── auth.py           # Authentication endpoints
│   ├── pets.py           # Pet CRUD operations
│   ├── health.py         # Health logging endpoints
│   ├── ai.py             # AI analysis endpoints
│   └── vet.py            # Veterinarian portal endpoints
├── services/
│   └── ai_service.py     # Google Gemini AI integration
└── main.py               # FastAPI application entry point
```

## 🚀 Quick Start

### Prerequisites

- Python 3.9+
- Virtual environment (recommended)

### Installation

1. **Clone and navigate to the project:**
   ```bash
   cd /Users/hongfeiyang/dev/med-tracker
   ```

2. **Create and activate virtual environment:**
   ```bash
   python3 -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. **Install dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

4. **Configure environment variables:**
   ```bash
   cp .env.example .env  # Edit .env with your configuration
   ```

5. **Start the development server:**
   ```bash
   uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
   ```

6. **Access the API:**
   - API: http://localhost:8000
   - Interactive Docs: http://localhost:8000/docs
   - OpenAPI Schema: http://localhost:8000/openapi.json

## 🗄️ Database

The application uses SQLite for development with the following tables:

- **users**: User account information
- **pets**: Pet profiles and basic information
- **health_logs**: Health tracking entries with AI analysis
- **veterinarians**: Veterinarian account information
- **medications**: Medication records and prescriptions
- **vet_prescriptions**: Prescription records linking vets, pets, and medications

The database is automatically created on first startup.

## 🔐 Authentication

The API uses JWT (JSON Web Tokens) for authentication with two user types:

### User Authentication
- `POST /auth/register` - Register new user
- `POST /auth/login` - User login
- `POST /auth/refresh` - Refresh JWT token

### Veterinarian Authentication  
- `POST /auth/vet/register` - Register new veterinarian
- `POST /auth/vet/login` - Veterinarian login

Include the JWT token in requests:
```
Authorization: Bearer <your-jwt-token>
```

## 📋 API Endpoints

### Pet Management (`/pets`)
- `GET /pets/` - List user's pets
- `POST /pets/` - Create new pet
- `GET /pets/{id}` - Get pet details
- `PUT /pets/{id}` - Update pet information
- `DELETE /pets/{id}` - Delete pet

### Health Logging (`/health`)
- `POST /health/log` - Create health log entry
- `GET /health/log/{pet_id}` - Get pet's health history
- `POST /health/photos` - Upload health-related photos

### AI Analysis (`/ai`)
- `POST /ai/analyze-health` - Analyze pet health from image
- `POST /ai/analyze-medication` - Extract medication info from image

### Veterinarian Portal (`/vet`)
- `GET /vet/search-users` - Search for app users by email
- `POST /vet/prescriptions` - Create prescription for pet
- `GET /vet/prescriptions` - View vet's prescription history

## 🤖 AI Integration

The application integrates with Google Gemini AI for:

### Health Analysis
- Analyzes uploaded pet photos for health concerns
- Provides recommendations and severity assessment
- Returns structured analysis with confidence scores

### Medication Analysis
- Extracts medication information from prescription images
- Identifies dosage, frequency, and instructions
- Supports medication management workflow

### Configuration
Set your Gemini API key in `.env`:
```env
GEMINI_API_KEY=your-gemini-api-key-here
```

## 🔧 Configuration

Key environment variables in `.env`:

```env
# Database
DATABASE_URL=sqlite:///./pet_health_tracker.db

# Security
SECRET_KEY=your-secret-key-here
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30

# AI Service
GEMINI_API_KEY=your-gemini-api-key
GOOGLE_CLOUD_PROJECT=your-project-id
```

## 🧪 Testing

Run the test suite:
```bash
python test_api.py
```

This will test:
- Authentication endpoints
- Pet management
- Protected routes
- Error handling

## 🚀 Deployment

### Development
```bash
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

### Production
```bash
uvicorn app.main:app --host 0.0.0.0 --port 8000 --workers 4
```

### Docker (Optional)
```bash
# Build image
docker build -t pet-tracker-api .

# Run container
docker run -p 8000:8000 pet-tracker-api
```

### Environment-Specific Configuration

For production deployment:
1. Use PostgreSQL instead of SQLite
2. Set secure `SECRET_KEY`
3. Configure proper CORS origins
4. Enable HTTPS
5. Set up proper logging
6. Configure rate limiting

## 📚 API Documentation

Interactive API documentation is available at:
- **Swagger UI**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc

## 🛠️ Development

### Adding New Endpoints

1. Create request/response schemas in appropriate `schemas/` file
2. Implement business logic in `services/` (if needed)
3. Add route handlers in appropriate `routers/` file
4. Include router in `main.py`

### Database Migrations

For production use, set up Alembic for database migrations:
```bash
alembic init alembic
alembic revision --autogenerate -m "Initial migration"
alembic upgrade head
```

## 🤝 Integration Points

This backend is designed to work with:
- **Flutter Mobile App**: Cross-platform mobile client
- **Infrastructure**: Google Cloud Platform deployment
- **AI/ML Services**: Google Vertex AI integration

## 📦 Dependencies

Key dependencies:
- `fastapi`: Web framework
- `uvicorn`: ASGI server
- `sqlalchemy`: ORM
- `pydantic`: Data validation
- `python-jose`: JWT handling
- `passlib`: Password hashing
- `google-generativeai`: AI integration

## 🐛 Troubleshooting

Common issues:

1. **Import errors**: Ensure virtual environment is activated
2. **Database errors**: Check SQLite file permissions
3. **AI errors**: Verify Gemini API key configuration
4. **Authentication errors**: Check JWT secret key configuration

## 📝 MVP Status

✅ **Completed Features:**
- User registration and authentication
- Pet profile management (CRUD)
- Health logging with AI analysis stubs
- Veterinarian portal with prescription management
- AI service integration (Gemini API)
- Comprehensive API documentation

🔄 **Ready for Integration:**
- Frontend mobile application
- Cloud deployment infrastructure
- Enhanced AI/ML capabilities

This backend provides a solid foundation for the Pet Health Tracker MVP and is ready for frontend integration and cloud deployment.