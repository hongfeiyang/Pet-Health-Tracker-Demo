# Pet Health Tracker - Full-Stack Application

A comprehensive AI-Powered Pet Health Tracker application with FastAPI backend and Flutter frontend, featuring automated API client generation, user authentication, pet management, health logging, AI image analysis, and veterinarian portal functionality.

## 🏗️ Architecture

This full-stack application implements a modern architecture with the following components:

### Backend (FastAPI)
- **FastAPI Application**: Modern, high-performance web framework
- **SQLAlchemy ORM**: Database abstraction layer with SQLite for development
- **JWT Authentication**: Secure token-based authentication for users and veterinarians  
- **Pydantic Schemas**: Request/response validation and serialization
- **Google Gemini AI**: Image analysis for health assessment and medication extraction
- **OpenAPI Specification**: Auto-generated API documentation and schema

### Frontend (Flutter)
- **Flutter Framework**: Cross-platform mobile application
- **BLoC State Management**: Reactive state management with flutter_bloc
- **Generated API Client**: Automatically generated Dart client from OpenAPI spec
- **Type-Safe Integration**: Strongly typed API communication

## 📁 Project Structure

```
/Users/hongfeiyang/dev/med-tracker/
├── app/                           # FastAPI Backend
│   ├── core/
│   │   ├── config.py              # Application configuration
│   │   ├── database.py            # Database connection and session management
│   │   └── security.py            # Authentication and authorization
│   ├── models/
│   │   └── database.py            # SQLAlchemy database models
│   ├── schemas/
│   │   ├── auth.py               # Authentication request/response schemas
│   │   ├── pets.py               # Pet-related schemas
│   │   ├── health.py             # Health logging schemas
│   │   ├── ai.py                 # AI analysis schemas
│   │   └── vet.py                # Veterinarian portal schemas
│   ├── routers/
│   │   ├── auth.py               # Authentication endpoints
│   │   ├── pets.py               # Pet CRUD operations
│   │   ├── health.py             # Health logging endpoints
│   │   ├── ai.py                 # AI analysis endpoints
│   │   └── vet.py                # Veterinarian portal endpoints
│   ├── services/
│   │   └── ai_service.py         # Google Gemini AI integration
│   └── main.py                   # FastAPI application entry point
├── pet_health_tracker/           # Flutter Frontend
│   ├── Makefile                  # API client generation commands
│   ├── openapi-generator-config.yaml  # OpenAPI generator configuration
│   ├── packages/
│   │   └── pet_health_api_client/     # Generated API client package
│   ├── lib/
│   │   ├── blocs/                # BLoC state management
│   │   ├── models/               # Data models
│   │   ├── repositories/         # Data layer using generated client
│   │   ├── screens/              # UI screens
│   │   └── main.dart             # Flutter app entry point
│   └── pubspec.yaml              # Flutter dependencies
├── requirements.txt              # Python dependencies
└── .env.example                  # Environment configuration template
```

## 🚀 Quick Start

### Prerequisites

- **Python 3.9+** for backend
- **Flutter 3.0+** for frontend  
- **Docker** for API client generation
- **Virtual environment** (recommended)

### Backend Setup

1. **Navigate to project root:**
   ```bash
   cd /Users/hongfeiyang/dev/med-tracker
   ```

2. **Create and activate virtual environment:**
   ```bash
   python3 -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. **Install Python dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

4. **Configure environment variables:**
   ```bash
   cp .env.example .env  # Edit .env with your configuration
   ```

5. **Start the FastAPI server:**
   ```bash
   uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
   ```

6. **Verify backend is running:**
   - API: http://localhost:8000
   - Interactive Docs: http://localhost:8000/docs
   - OpenAPI Schema: http://localhost:8000/openapi.json

### Frontend Setup

1. **Navigate to Flutter project:**
   ```bash
   cd pet_health_tracker
   ```

2. **Install Flutter dependencies:**
   ```bash
   flutter pub get
   ```

3. **Generate API client** (with backend running):
   ```bash
   make api-generate
   ```

4. **Run the Flutter app:**
   ```bash
   flutter run
   ```

### 🔄 API Client Generation Workflow

The project includes an automated pipeline for generating type-safe Dart API clients from the backend's OpenAPI specification:

1. **Start backend server** (if not already running)
2. **Navigate to Flutter project:** `cd pet_health_tracker`
3. **Generate client:** `make api-generate`
4. **Client automatically integrates** with your Flutter app

**Available Make commands:**
```bash
make help           # Show available commands
make api-generate   # Generate API client from running backend
make clean          # Remove temporary files
```

## 🔧 Automated API Client Generation

This project features a professional-grade automated API client generation pipeline that ensures type-safe communication between the Flutter frontend and FastAPI backend.

### 🏗️ Pipeline Architecture

The system uses the official OpenAPI Generator with Docker to create a standalone Dart package:

```
Backend (FastAPI) → OpenAPI Spec → Docker Generator → Dart Package → Flutter App
```

### ✨ Key Features

- **✅ Fully Automated**: Single `make api-generate` command handles everything
- **✅ Type-Safe**: Generated Dart models with null safety and serialization
- **✅ Standalone Package**: Clean separation in `packages/pet_health_api_client/`
- **✅ Authentication Ready**: Built-in JWT Bearer token support
- **✅ Auto-Dependency Management**: Automatically installs generated package dependencies
- **✅ Git-Friendly**: Generated files properly excluded from version control

### 🛠️ Generated Components

The pipeline automatically creates:

- **6 API Clients**: Authentication, Pets, Health, AI, Veterinarian, Default
- **27+ Data Models**: Complete request/response types with serialization
- **Authentication Handlers**: Bearer token, API key, OAuth support
- **Type-Safe Endpoints**: Strongly typed method signatures
- **Error Handling**: Structured API exception handling

### 📂 Package Structure

```
pet_health_tracker/packages/pet_health_api_client/
├── lib/
│   ├── api/                    # Generated API clients
│   │   ├── authentication_api.dart
│   │   ├── pets_api.dart
│   │   ├── health_api.dart
│   │   └── ...
│   ├── model/                  # Generated data models
│   │   ├── pet_response.dart
│   │   ├── user_create.dart
│   │   └── ...
│   ├── auth/                   # Authentication handlers
│   └── pet_health_api_client.dart  # Main export
└── pubspec.yaml               # Package dependencies
```

### 🔄 Development Workflow

1. **Make backend changes** and ensure server is running
2. **Regenerate client:** `cd pet_health_tracker && make api-generate`
3. **Updated types** automatically available in your Flutter app
4. **Type errors** caught at compile time, not runtime

### 🎯 Integration Example

```dart
// Before: Manual HTTP calls
final response = await http.post(
  Uri.parse('$baseUrl/pets/'),
  headers: {'Authorization': 'Bearer $token'},
  body: jsonEncode({'name': 'Fluffy'}),
);

// After: Generated type-safe client
final petsApi = PetsApi();
final pet = await petsApi.createPetPetsPost(
  PetCreate(name: 'Fluffy', breed: 'Golden Retriever'),
);
```

This pipeline ensures your Flutter app stays perfectly synchronized with your backend API changes, eliminating integration bugs and improving developer productivity.

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

✅ **Backend (FastAPI) - Completed:**
- User registration and authentication
- Pet profile management (CRUD)
- Health logging with AI analysis
- Veterinarian portal with prescription management
- AI service integration (Gemini API)
- Comprehensive API documentation
- OpenAPI 3.1 specification generation

✅ **Frontend (Flutter) - Completed:**
- Flutter project structure with BLoC state management
- Automated API client generation pipeline
- Type-safe repository pattern implementation
- Generated Dart models and API clients
- Professional development workflow

✅ **Integration Pipeline - Completed:**
- Automated OpenAPI client generation with Docker
- Standalone package architecture
- Make-based development workflow
- Git integration with proper exclusions
- Dependency management automation

🔄 **Ready for Enhancement:**
- Cloud deployment infrastructure (GCP)
- Enhanced AI/ML capabilities (Vertex AI)
- Production database setup (PostgreSQL)
- Mobile app UI/UX implementation
- Authentication token management

This full-stack application provides a robust foundation for the Pet Health Tracker MVP with professional-grade automated API integration, ensuring type-safe communication between frontend and backend components.