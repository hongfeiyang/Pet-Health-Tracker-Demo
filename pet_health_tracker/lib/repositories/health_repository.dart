import 'package:pet_health_api_client/pet_health_api_client.dart';
import 'package:dio/dio.dart';
import 'package:built_collection/built_collection.dart';

class HealthRepository {
  final HealthApi _healthApi;

  HealthRepository({required HealthApi healthApi}) 
      : _healthApi = healthApi;

  Future<List<HealthLogResponse>> getHealthLogs(String petId) async {
    try {
      final response = await _healthApi.getHealthLogsHealthLogPetIdGet(petId: petId);
      
      if (response.data != null) {
        return response.data!.logs.toList();
      } else {
        throw Exception('No health logs data received');
      }
    } on DioException catch (e) {
      throw Exception('Failed to fetch health logs: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch health logs: ${e.toString()}');
    }
  }

  Future<HealthLogResponse> createHealthLog({
    required String petId,
    required LogType logType,
    String? value,
    String? notes,
    List<String>? imageUrls,
  }) async {
    try {
      final healthLogCreate = HealthLogCreate((b) => b
        ..petId = petId
        ..logType = logType
        ..value = value
        ..notes = notes
        ..imageUrls = imageUrls != null ? ListBuilder(imageUrls) : null);
      
      final response = await _healthApi.createHealthLogHealthLogPost(
        healthLogCreate: healthLogCreate
      );
      
      if (response.data != null) {
        return response.data!;
      } else {
        throw Exception('Health log creation failed: No data received');
      }
    } on DioException catch (e) {
      throw Exception('Failed to create health log: ${e.message}');
    } catch (e) {
      throw Exception('Failed to create health log: ${e.toString()}');
    }
  }
}