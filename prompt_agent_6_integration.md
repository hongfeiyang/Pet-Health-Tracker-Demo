**Role:** Flutter Application Architect & Refactoring Specialist

**Mission:**
Your primary directive is to intelligently refactor our Flutter application's data layer. You will **first analyze the existing codebase to identify implemented features** and then surgically replace the legacy data access logic for those features with our new, auto-generated `pet_health_api_client` package. This two-phase approach—discover then refactor—will ensure your work is targeted, efficient, and elevates our codebase to a new standard of type safety and maintainability.

---

### **Core Architectural Principles**

*   **Repository as a Facade:** The Repository layer is the only component permitted to have knowledge of the data source. It must act as a clean facade, completely abstracting the `pet_health_api_client` away from the rest of the application (especially the BLoCs).
*   **Dependency Injection:** The generated API client (e.g., `PetApi`) must be provided to repositories via their constructors. This is non-negotiable and critical for testability. Repositories **must not** instantiate their own dependencies.
*   **Model Purity:** The application's domain models (used by the BLoCs and UI) **must** be the models from the `pet_health_api_client` package. Do not create redundant, manual models.

---

### **Implementation Blueprint**

**Phase 1: Discovery & Analysis (Read-Only)**

1.  **Analyze Directory Structure:** Examine the contents of `lib/screens/`, `lib/blocs/`, and `lib/repositories/`.
2.  **Identify Implemented Features:** Based on your analysis, identify the core features that have already been implemented. From an initial review, these appear to be **Authentication**, **Pet Management**, and **Health Logging**.
3.  **Confirm & Plan:** Before writing any code, state which repository files you will be refactoring based on the features you've identified (e.g., `auth_repository.dart`, `pet_repository.dart`, etc.). This confirms your understanding before you begin modifications.

**Phase 2: Targeted Refactoring & Integration**

1.  **Provide API Clients via DI:**
    *   In your main dependency injection setup (e.g., `main.dart`), modify the providers for the repositories you identified in Phase 1.
    *   Instantiate the required generated API clients (e.g., `AuthApi()`, `PetApi()`) and provide them to the corresponding repository constructors.

    **Example DI Configuration:**
    ```dart
    // In your main.dart or dependency injection setup file
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AuthRepository(authApi: AuthApi()),
        ),
        RepositoryProvider(
          create: (context) => PetRepository(petApi: PetApi()),
        ),
        // ... other identified repositories
      ],
      child: // ... your app
    )
    ```

2.  **Refactor Identified Repositories:**
    *   Go through each repository file identified in Phase 1 and replace the manual `http` logic with calls to the injected, generated API client.

    **Example: Refactoring `AuthRepository`**
    ```dart
    // lib/repositories/auth_repository.dart (NEW VERSION)
    import 'package:pet_health_api_client/pet_health_api_client.dart';

    class AuthRepository {
      final AuthApi _authApi;
      AuthRepository({required AuthApi authApi}) : _authApi = authApi;

      Future<User> login(String email, String password) async {
        try {
          // The generated client handles request body creation.
          final request = LoginRequest(email: email, password: password);
          final response = await _authApi.login(loginRequest: request);
          // The repository's job is to extract the data and handle errors.
          if (response.data != null) {
            return response.data!;
          }
          throw Exception('Login failed: No user data received');
        } on DioError catch (e) {
          // Translate low-level errors into domain-specific exceptions.
          throw Exception('Login failed: ${e.message}');
        }
      }
    }
    ```

**Phase 3: Codebase Sanitization**

1.  **Eliminate Redundancy:**
    *   Once the targeted repositories are refactored, delete any manual model files in `lib/models/` that are now duplicated by the generated models.
    *   Update all `import` statements in the BLoCs and UI files to use the models from the `pet_health_api_client` package.
2.  **Remove Dead Code:**
    *   Remove the `http` package from the main `pubspec.yaml`.
    *   Run `flutter pub get` to finalize the removal.

---

### **Acceptance Criteria (Definition of Done)**

*   **Targeted Refactoring:** Only the repositories and BLoCs related to the pre-existing features (Auth, Pets, Health) have been modified.
*   **Zero Manual API Calls:** The `http` package is completely removed from the main application.
*   **Clean Abstraction:** No BLoC or UI file contains any `import` from `pet_health_api_client`. They only interact with repositories.
*   **Dependency Injected:** All refactored repositories receive their API client dependencies via their constructor.
*   **Full Functionality:** The application compiles and all *previously existing* features are fully functional with the new data layer.