**Role:** DevOps & Frontend Tooling Architect

**Mission:**
Your primary objective is to engineer a professional, automated, and decoupled API integration pipeline for our Flutter application. You will create a standalone Dart package for our API client, automatically generated from the backend's OpenAPI specification. This entire process will be orchestrated via a `Makefile` and the official `openapi-generator-cli` Docker image, ensuring a lean, reproducible workflow that is completely independent of Node.js.

---

### **Core Architectural Principles**

*   **Decoupling:** The generated API client code **must** reside in its own package (`packages/pet_health_api_client`). It will be treated as a versionable, third-party dependency by the main application, ensuring a clean separation of concerns.
*   **Automation:** The entire generation process **must** be encapsulated within a single `make api-generate` command. This command will handle fetching the spec, running the generator, and cleaning up artifacts.
*   **Reproducibility:** By using the official Docker image for the generator, we ensure that any developer can regenerate the client with zero local setup beyond having Docker installed.

---

### **Implementation Blueprint**

**Phase 1: Establish the API Package Foundation**

1.  **Create Package Scaffolding:**
    *   In the project root, create a `packages/` directory.
    *   Inside `packages/`, create a new Dart package: `flutter create --template=package pet_health_api_client`.
2.  **Add Package Dependencies:**
    *   Edit `packages/pet_health_api_client/pubspec.yaml` to include the `dio` library, which is required by the generated code.

**Phase 2: Engineer the `Makefile` Pipeline**

1.  **Create `openapi-generator-config.yaml`:**
    *   In the project root, create this configuration file. It defines the generator's behavior. Note the paths are relative to the Docker container's context (`/local`).
    ```yaml
    generatorName: dart-dio
    inputSpec: /local/openapi.json
    outputDir: /local/packages/pet_health_api_client
    additionalProperties:
      pubName: pet_health_api_client
      pubVersion: 1.0.0
      nullSafe: true
      useEnumExtension: true
    ```

2.  **Construct the `Makefile`:**
    *   In the project root, create a `Makefile`. This is the central orchestrator for your pipeline. It should be robust and self-documenting.
    ```makefile
    # Makefile for API Client Generation

    # Use bash for all recipes
    SHELL:=/bin/bash

    # Define the OpenAPI spec URL
    OPENAPI_SPEC_URL := http://127.0.0.1:8000/openapi.json
    OPENAPI_SPEC_LOCAL := openapi.json

    # Define the Docker image to use
    OPENAPI_GENERATOR_IMAGE := openapitools/openapi-generator-cli:latest

    .PHONY: help api-generate clean

    help:
    	@echo "Commands:"
    	@echo "  api-generate   : Fetches the API spec and generates the Dart client package."
    	@echo "  clean          : Removes the temporary API spec file."

    # Fetches the latest API spec and generates the client package.
    api-generate: clean
    	@echo "--> Fetching latest API specification from ${OPENAPI_SPEC_URL}..."
    	@curl -fL -o ${OPENAPI_SPEC_LOCAL} ${OPENAPI_SPEC_URL} || (echo "Error: Failed to download API spec. Is the backend running?" && exit 1)

    	@echo "--> Generating API client via Docker..."
    	@docker run --rm -v "${PWD}:/local" ${OPENAPI_GENERATOR_IMAGE} generate -c /local/openapi-generator-config.yaml

    	@echo "--> API client generated successfully in packages/pet_health_api_client"
    	@make clean

    # Removes temporary files
    clean:
    	@echo "--> Cleaning up temporary files..."
    	@rm -f ${OPENAPI_SPEC_LOCAL}
    ```

**Phase 3: Integrate the Client into the Main App**

1.  **Add Local Dependency:**
    *   In the main Flutter app's `pubspec.yaml`, add a `path` dependency to the newly created local package.
    ```yaml
    dependencies:
      # ... other dependencies
      pet_health_api_client:
        path: ../packages/pet_health_api_client
    ```
    *   Run `flutter pub get` in the main app directory.

2.  **Refactor Repositories:**
    *   Modify the app's repository classes to `import 'package:pet_health_api_client/pet_health_api_client.dart';` and use the generated client.

3.  **Update `.gitignore`:**
    *   Ensure the generated code and temporary spec file are ignored in the root `.gitignore`.
    ```
    # Generated API client package contents
    /packages/pet_health_api_client/lib/
    # Temporary OpenAPI spec file
    openapi.json
    ```

---

### **Acceptance Criteria (Definition of Done)**

*   Running `make api-generate` from the project root successfully generates the complete Dart client in `packages/pet_health_api_client/`.
*   The main Flutter application successfully imports the `pet_health_api_client` package and can instantiate the generated API client in its repositories.
*   The process is entirely self-contained, requiring only `docker` and `curl` to be installed on the host machine.
*   The root `.gitignore` is correctly configured to exclude generated files.
