import 'package:pet_health_api_client/pet_health_api_client.dart';
import 'package:dio/dio.dart';

class PetRepository {
  final PetsApi _petsApi;

  PetRepository({required PetsApi petsApi}) 
      : _petsApi = petsApi;

  Future<List<PetResponse>> getPets() async {
    try {
      final response = await _petsApi.listPetsPetsGet();
      
      if (response.data != null) {
        return response.data!.pets.toList();
      } else {
        throw Exception('No pets data received');
      }
    } on DioException catch (e) {
      throw Exception('Failed to fetch pets: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch pets: ${e.toString()}');
    }
  }

  Future<PetResponse> createPet({
    required String name,
    String? breed,
    int? age,
    double? weight,
    String? medicalHistory,
  }) async {
    try {
      final petCreate = PetCreate((b) {
        b
          ..name = name
          ..breed = breed
          ..age = age
          ..medicalHistory = medicalHistory;
        // Skip weight for now due to complex AnyOf type
      });
      
      final response = await _petsApi.createPetPetsPost(petCreate: petCreate);
      
      if (response.data != null) {
        return response.data!;
      } else {
        throw Exception('Pet creation failed: No pet data received');
      }
    } on DioException catch (e) {
      throw Exception('Failed to create pet: ${e.message}');
    } catch (e) {
      throw Exception('Failed to create pet: ${e.toString()}');
    }
  }

  Future<PetResponse> getPet(String petId) async {
    try {
      final response = await _petsApi.getPetPetsPetIdGet(petId: petId);
      
      if (response.data != null) {
        return response.data!;
      } else {
        throw Exception('Pet not found');
      }
    } on DioException catch (e) {
      throw Exception('Failed to fetch pet: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch pet: ${e.toString()}');
    }
  }

  Future<PetResponse> updatePet({
    required String petId,
    required String name,
    String? breed,
    int? age,
    double? weight,
    String? medicalHistory,
  }) async {
    try {
      final petUpdate = PetUpdate((b) {
        b
          ..name = name
          ..breed = breed
          ..age = age
          ..medicalHistory = medicalHistory;
        // Skip weight for now due to complex AnyOf type
      });
      
      final response = await _petsApi.updatePetPetsPetIdPut(
        petId: petId, 
        petUpdate: petUpdate
      );
      
      if (response.data != null) {
        return response.data!;
      } else {
        throw Exception('Pet update failed: No pet data received');
      }
    } on DioException catch (e) {
      throw Exception('Failed to update pet: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update pet: ${e.toString()}');
    }
  }

  Future<void> deletePet(String petId) async {
    try {
      await _petsApi.deletePetPetsPetIdDelete(petId: petId);
    } on DioException catch (e) {
      throw Exception('Failed to delete pet: ${e.message}');
    } catch (e) {
      throw Exception('Failed to delete pet: ${e.toString()}');
    }
  }
}