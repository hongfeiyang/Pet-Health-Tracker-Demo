# Pet Health Tracker

A Flutter mobile application for tracking pet health using AI-powered analysis.

## Features Implemented

### ✅ Core Features (MVP)
- **User Authentication**: Login and registration screens with form validation
- **Pet Management**: Add, view, edit, and delete pet profiles
- **Health Logging**: Track weight, temperature, vet visits, vaccinations, and symptoms
- **BLoC State Management**: Complete implementation following the technical design
- **Material Design UI**: Clean, functional interface using Flutter's Material library

### 🏗️ Architecture
- **BLoC Pattern**: Proper separation of business logic from UI
- **Repository Pattern**: Abstraction layer between API and BLoCs
- **API Service**: HTTP client ready for backend integration
- **Models**: Complete data models matching the database schema

## Project Structure

```
lib/
├── api/                    # API service and models
│   ├── api_service.dart    # HTTP client for backend calls
│   └── api_models.dart     # Request/response models
├── blocs/                  # BLoC state management
│   ├── auth/              # Authentication BLoC
│   ├── pets/              # Pet management BLoC
│   └── health/            # Health logging BLoC
├── models/                 # Domain models
│   ├── user.dart
│   ├── pet.dart
│   └── health_log.dart
├── repositories/           # Data abstraction layer
│   ├── auth_repository.dart
│   ├── pet_repository.dart
│   └── health_repository.dart
├── screens/               # UI screens
│   ├── auth/             # Login and register screens
│   ├── pets/             # Pet management screens
│   └── health/           # Health logging screens
└── main.dart             # App entry point with providers
```

## Backend Integration

The app is configured to connect to a FastAPI backend at `http://localhost:8000`. The API service includes:

- Authentication endpoints (`/auth/login`, `/auth/register`)
- Pet management endpoints (`/pets/`)
- Health logging endpoints (`/health/log`)

Currently using mock responses since backend is in development.

## Future Enhancements

### 🔄 TODO (Marked for Later Implementation)
- **JWT Authentication**: Full integration with backend auth system
- **Image Upload**: Pet photos and health log images
- **AI Analysis**: Integration with Google Vertex AI for health insights
- **Push Notifications**: Firebase Cloud Messaging for reminders
- **Camera Integration**: Photo capture for health analysis

## Getting Started

### Prerequisites
- Flutter SDK
- Dart SDK
- Android Studio / Xcode for device testing

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```

### Testing

```bash
flutter test
flutter analyze
```

## Technical Notes

- **State Management**: Uses flutter_bloc package for reactive state management
- **HTTP Requests**: Uses http package for API communication
- **Form Validation**: Built-in validation for all user inputs
- **Error Handling**: Proper error states and user feedback
- **Navigation**: MaterialApp routing with programmatic navigation

## Dependencies

- `flutter_bloc`: State management
- `equatable`: Value equality for state objects
- `http`: HTTP client for API calls
- `image_picker`: Image selection (ready for future use)
- `firebase_auth`: Authentication (configured for future JWT integration)
- `uuid`: Unique identifier generation

## Development Status

✅ **MVP Core Features Complete**
- All authentication flows working
- Pet CRUD operations implemented
- Health logging system functional
- BLoC architecture properly implemented
- Material Design UI completed

🔄 **Backend Integration Ready**
- API service configured for FastAPI backend
- Repository pattern allows easy switching from mock to real data
- Error handling for network requests implemented
