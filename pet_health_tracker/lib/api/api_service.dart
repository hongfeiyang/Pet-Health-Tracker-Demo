import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_models.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8000';
  String? _authToken;

  void setAuthToken(String token) {
    _authToken = token;
  }

  void clearAuthToken() {
    _authToken = null;
  }

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (_authToken != null) 'Authorization': 'Bearer $_authToken',
      };

  Future<AuthResponse> login(LoginRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: _headers,
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return AuthResponse.fromJson(data);
    } else {
      final error = jsonDecode(response.body);
      throw ApiError.fromJson(error);
    }
  }

  Future<AuthResponse> register(RegisterRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: _headers,
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return AuthResponse.fromJson(data);
    } else {
      final error = jsonDecode(response.body);
      throw ApiError.fromJson(error);
    }
  }

  Future<List<PetResponse>> getPets() async {
    final response = await http.get(
      Uri.parse('$baseUrl/pets/'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => PetResponse.fromJson(json)).toList();
    } else {
      final error = jsonDecode(response.body);
      throw ApiError.fromJson(error);
    }
  }

  Future<PetResponse> createPet(CreatePetRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/pets/'),
      headers: _headers,
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return PetResponse.fromJson(data);
    } else {
      final error = jsonDecode(response.body);
      throw ApiError.fromJson(error);
    }
  }

  Future<PetResponse> getPet(String petId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/pets/$petId'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return PetResponse.fromJson(data);
    } else {
      final error = jsonDecode(response.body);
      throw ApiError.fromJson(error);
    }
  }

  Future<PetResponse> updatePet(String petId, CreatePetRequest request) async {
    final response = await http.put(
      Uri.parse('$baseUrl/pets/$petId'),
      headers: _headers,
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return PetResponse.fromJson(data);
    } else {
      final error = jsonDecode(response.body);
      throw ApiError.fromJson(error);
    }
  }

  Future<void> deletePet(String petId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/pets/$petId'),
      headers: _headers,
    );

    if (response.statusCode != 204) {
      final error = jsonDecode(response.body);
      throw ApiError.fromJson(error);
    }
  }

  Future<HealthLogResponse> createHealthLog(CreateHealthLogRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/health/log'),
      headers: _headers,
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return HealthLogResponse.fromJson(data);
    } else {
      final error = jsonDecode(response.body);
      throw ApiError.fromJson(error);
    }
  }

  Future<List<HealthLogResponse>> getHealthLogs(String petId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/health/log/$petId'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => HealthLogResponse.fromJson(json)).toList();
    } else {
      final error = jsonDecode(response.body);
      throw ApiError.fromJson(error);
    }
  }
}