class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };
}

class RegisterRequest {
  final String email;
  final String password;

  RegisterRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };
}

class AuthResponse {
  final String token;
  final String userId;

  AuthResponse({required this.token, required this.userId});

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
        token: json['token'],
        userId: json['user_id'],
      );
}

class CreatePetRequest {
  final String name;
  final String? breed;
  final int? age;
  final double? weight;
  final String? medicalHistory;

  CreatePetRequest({
    required this.name,
    this.breed,
    this.age,
    this.weight,
    this.medicalHistory,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        if (breed != null) 'breed': breed,
        if (age != null) 'age': age,
        if (weight != null) 'weight': weight,
        if (medicalHistory != null) 'medical_history': medicalHistory,
      };
}

class PetResponse {
  final String id;
  final String userId;
  final String name;
  final String? breed;
  final int? age;
  final double? weight;
  final String? medicalHistory;
  final String? profileImageUrl;
  final DateTime createdAt;

  PetResponse({
    required this.id,
    required this.userId,
    required this.name,
    this.breed,
    this.age,
    this.weight,
    this.medicalHistory,
    this.profileImageUrl,
    required this.createdAt,
  });

  factory PetResponse.fromJson(Map<String, dynamic> json) => PetResponse(
        id: json['id'],
        userId: json['user_id'],
        name: json['name'],
        breed: json['breed'],
        age: json['age'],
        weight: json['weight']?.toDouble(),
        medicalHistory: json['medical_history'],
        profileImageUrl: json['profile_image_url'],
        createdAt: DateTime.parse(json['created_at']),
      );
}

class CreateHealthLogRequest {
  final String petId;
  final String logType;
  final String? value;
  final String? notes;
  final List<String>? imageUrls;

  CreateHealthLogRequest({
    required this.petId,
    required this.logType,
    this.value,
    this.notes,
    this.imageUrls,
  });

  Map<String, dynamic> toJson() => {
        'pet_id': petId,
        'log_type': logType,
        if (value != null) 'value': value,
        if (notes != null) 'notes': notes,
        if (imageUrls != null) 'image_urls': imageUrls,
      };
}

class HealthLogResponse {
  final String id;
  final String petId;
  final String logType;
  final String? value;
  final String? notes;
  final List<String>? imageUrls;
  final Map<String, dynamic>? aiAnalysis;
  final DateTime createdAt;

  HealthLogResponse({
    required this.id,
    required this.petId,
    required this.logType,
    this.value,
    this.notes,
    this.imageUrls,
    this.aiAnalysis,
    required this.createdAt,
  });

  factory HealthLogResponse.fromJson(Map<String, dynamic> json) =>
      HealthLogResponse(
        id: json['id'],
        petId: json['pet_id'],
        logType: json['log_type'],
        value: json['value'],
        notes: json['notes'],
        imageUrls: json['image_urls']?.cast<String>(),
        aiAnalysis: json['ai_analysis'],
        createdAt: DateTime.parse(json['created_at']),
      );
}

class ApiError {
  final String message;
  final int? statusCode;

  ApiError({required this.message, this.statusCode});

  factory ApiError.fromJson(Map<String, dynamic> json) => ApiError(
        message: json['message'] ?? 'Unknown error',
        statusCode: json['status_code'],
      );

  @override
  String toString() => message;
}