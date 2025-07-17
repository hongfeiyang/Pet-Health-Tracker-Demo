import 'package:equatable/equatable.dart';

class Pet extends Equatable {
  final String id;
  final String userId;
  final String name;
  final String? breed;
  final int? age;
  final double? weight;
  final String? medicalHistory;
  final String? profileImageUrl;
  final DateTime createdAt;

  const Pet({
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

  @override
  List<Object?> get props => [
        id,
        userId,
        name,
        breed,
        age,
        weight,
        medicalHistory,
        profileImageUrl,
        createdAt,
      ];

  Pet copyWith({
    String? id,
    String? userId,
    String? name,
    String? breed,
    int? age,
    double? weight,
    String? medicalHistory,
    String? profileImageUrl,
    DateTime? createdAt,
  }) {
    return Pet(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      breed: breed ?? this.breed,
      age: age ?? this.age,
      weight: weight ?? this.weight,
      medicalHistory: medicalHistory ?? this.medicalHistory,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}