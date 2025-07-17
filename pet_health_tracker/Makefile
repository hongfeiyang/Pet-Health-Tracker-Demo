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
	@echo "Pet Health Tracker API Generation Commands:"
	@echo "  api-generate   : Fetches the API spec and generates the Dart client package"
	@echo "  clean          : Removes the temporary API spec file"
	@echo "  api-deps       : Install dependencies for the generated package"

# Fetches the latest API spec and generates the client package
api-generate: clean
	@echo "--> Fetching latest API specification from ${OPENAPI_SPEC_URL}..."
	@curl -fL -o ${OPENAPI_SPEC_LOCAL} ${OPENAPI_SPEC_URL} || (echo "Error: Failed to download API spec. Is the backend running at ${OPENAPI_SPEC_URL}?" && exit 1)
	
	@echo "--> Generating API client via Docker..."
	@docker run --rm -v "${PWD}:/local" ${OPENAPI_GENERATOR_IMAGE} generate -c /local/openapi-generator-config.yaml
	
	@echo "--> Installing dependencies in generated package..."
	@cd packages/pet_health_api_client && flutter pub get
	
	@echo "--> API client generated successfully in packages/pet_health_api_client"
	@make clean

# Install dependencies for the generated package  
api-deps:
	@echo "--> Installing dependencies for API client package..."
	@cd packages/pet_health_api_client && flutter pub get

# Removes temporary files
clean:
	@echo "--> Cleaning up temporary files..."
	@rm -f ${OPENAPI_SPEC_LOCAL}