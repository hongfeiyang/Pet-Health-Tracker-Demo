import '../api/api_service.dart';
import '../api/api_models.dart';
import '../models/health_log.dart';

class HealthRepository {
  final ApiService _apiService;

  HealthRepository({ApiService? apiService}) 
      : _apiService = apiService ?? ApiService();

  Future<List<HealthLog>> getHealthLogs(String petId) async {
    try {
      final response = await _apiService.getHealthLogs(petId);
      return response.map(_mapResponseToModel).toList();
    } catch (e) {
      throw Exception('Failed to fetch health logs: ${e.toString()}');
    }
  }

  Future<HealthLog> createHealthLog({
    required String petId,
    required LogType logType,
    String? value,
    String? notes,
    List<String>? imageUrls,
  }) async {
    try {
      final request = CreateHealthLogRequest(
        petId: petId,
        logType: logType.value,
        value: value,
        notes: notes,
        imageUrls: imageUrls,
      );
      final response = await _apiService.createHealthLog(request);
      return _mapResponseToModel(response);
    } catch (e) {
      throw Exception('Failed to create health log: ${e.toString()}');
    }
  }

  HealthLog _mapResponseToModel(HealthLogResponse response) {
    return HealthLog(
      id: response.id,
      petId: response.petId,
      logType: LogTypeExtension.fromString(response.logType),
      value: response.value,
      notes: response.notes,
      imageUrls: response.imageUrls,
      aiAnalysis: response.aiAnalysis,
      createdAt: response.createdAt,
    );
  }
}