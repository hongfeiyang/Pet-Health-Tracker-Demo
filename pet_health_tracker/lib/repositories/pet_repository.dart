import '../api/api_service.dart';
import '../api/api_models.dart';
import '../models/pet.dart';

class PetRepository {
  final ApiService _apiService;

  PetRepository({ApiService? apiService}) 
      : _apiService = apiService ?? ApiService();

  Future<List<Pet>> getPets() async {
    try {
      final response = await _apiService.getPets();
      return response.map(_mapResponseToModel).toList();
    } catch (e) {
      throw Exception('Failed to fetch pets: ${e.toString()}');
    }
  }

  Future<Pet> createPet({
    required String name,
    String? breed,
    int? age,
    double? weight,
    String? medicalHistory,
  }) async {
    try {
      final request = CreatePetRequest(
        name: name,
        breed: breed,
        age: age,
        weight: weight,
        medicalHistory: medicalHistory,
      );
      final response = await _apiService.createPet(request);
      return _mapResponseToModel(response);
    } catch (e) {
      throw Exception('Failed to create pet: ${e.toString()}');
    }
  }

  Future<Pet> getPet(String petId) async {
    try {
      final response = await _apiService.getPet(petId);
      return _mapResponseToModel(response);
    } catch (e) {
      throw Exception('Failed to fetch pet: ${e.toString()}');
    }
  }

  Future<Pet> updatePet({
    required String petId,
    required String name,
    String? breed,
    int? age,
    double? weight,
    String? medicalHistory,
  }) async {
    try {
      final request = CreatePetRequest(
        name: name,
        breed: breed,
        age: age,
        weight: weight,
        medicalHistory: medicalHistory,
      );
      final response = await _apiService.updatePet(petId, request);
      return _mapResponseToModel(response);
    } catch (e) {
      throw Exception('Failed to update pet: ${e.toString()}');
    }
  }

  Future<void> deletePet(String petId) async {
    try {
      await _apiService.deletePet(petId);
    } catch (e) {
      throw Exception('Failed to delete pet: ${e.toString()}');
    }
  }

  Pet _mapResponseToModel(PetResponse response) {
    return Pet(
      id: response.id,
      userId: response.userId,
      name: response.name,
      breed: response.breed,
      age: response.age,
      weight: response.weight,
      medicalHistory: response.medicalHistory,
      profileImageUrl: response.profileImageUrl,
      createdAt: response.createdAt,
    );
  }
}