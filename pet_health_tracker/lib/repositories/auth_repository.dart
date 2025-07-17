import '../api/api_service.dart';
import '../api/api_models.dart';
import '../models/user.dart';

class AuthRepository {
  final ApiService _apiService;

  AuthRepository({ApiService? apiService}) 
      : _apiService = apiService ?? ApiService();

  Future<User> login(String email, String password) async {
    try {
      final request = LoginRequest(email: email, password: password);
      final response = await _apiService.login(request);
      
      _apiService.setAuthToken(response.token);
      
      return User(
        id: response.userId,
        email: email,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  Future<User> register(String email, String password) async {
    try {
      final request = RegisterRequest(email: email, password: password);
      final response = await _apiService.register(request);
      
      _apiService.setAuthToken(response.token);
      
      return User(
        id: response.userId,
        email: email,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    _apiService.clearAuthToken();
  }

  bool get isAuthenticated => false;
}