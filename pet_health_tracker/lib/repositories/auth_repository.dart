import 'package:pet_health_api_client/pet_health_api_client.dart';
import 'package:dio/dio.dart';

class AuthRepository {
  final AuthenticationApi _authApi;
  final PetHealthApiClient _apiClient;
  String? _authToken;

  AuthRepository({required AuthenticationApi authApi, required PetHealthApiClient apiClient}) 
      : _authApi = authApi, _apiClient = apiClient;

  Future<UserResponse> login(String email, String password) async {
    try {
      final userLogin = UserLogin((b) => b
        ..email = email
        ..password = password);
      
      final response = await _authApi.loginUserAuthLoginPost(userLogin: userLogin);
      
      if (response.data != null) {
        _authToken = response.data!.accessToken;
        
        // Set bearer token on the shared API client
        _apiClient.setBearerAuth('HTTPBearer', _authToken!);
        
        // Return a user response - we'll need to get user info separately
        // For now, return basic info
        return UserResponse((b) => b
          ..id = 'temp-id' // TODO: Get from separate API call or JWT decode
          ..email = email
          ..createdAt = DateTime.now());
      } else {
        throw Exception('Login failed: No access token received');
      }
    } on DioException catch (e) {
      throw Exception('Login failed: ${e.message}');
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  Future<UserResponse> register(String email, String password) async {
    try {
      final userCreate = UserCreate((b) => b
        ..email = email
        ..password = password);
      
      final response = await _authApi.registerUserAuthRegisterPost(userCreate: userCreate);
      
      if (response.data != null) {
        return response.data!;
      } else {
        throw Exception('Registration failed: No user data received');
      }
    } on DioException catch (e) {
      throw Exception('Registration failed: ${e.message}');
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    _authToken = null;
    // Clear bearer token from the shared API client
    _apiClient.setBearerAuth('HTTPBearer', '');
  }

  bool get isAuthenticated => _authToken != null;
  
  String? get authToken => _authToken;
  
  void setAuthToken(String token) {
    _authToken = token;
    // Set bearer token on the shared API client
    _apiClient.setBearerAuth('HTTPBearer', token);
  }
}