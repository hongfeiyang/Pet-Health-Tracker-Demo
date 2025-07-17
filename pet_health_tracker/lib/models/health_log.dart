import 'package:equatable/equatable.dart';

enum LogType {
  weight,
  temperature,
  vetVisit,
  vaccination,
  symptom,
}

extension LogTypeExtension on LogType {
  String get value {
    switch (this) {
      case LogType.weight:
        return 'weight';
      case LogType.temperature:
        return 'temperature';
      case LogType.vetVisit:
        return 'vet_visit';
      case LogType.vaccination:
        return 'vaccination';
      case LogType.symptom:
        return 'symptom';
    }
  }

  static LogType fromString(String value) {
    switch (value) {
      case 'weight':
        return LogType.weight;
      case 'temperature':
        return LogType.temperature;
      case 'vet_visit':
        return LogType.vetVisit;
      case 'vaccination':
        return LogType.vaccination;
      case 'symptom':
        return LogType.symptom;
      default:
        throw ArgumentError('Unknown log type: $value');
    }
  }

  String get displayName {
    switch (this) {
      case LogType.weight:
        return 'Weight';
      case LogType.temperature:
        return 'Temperature';
      case LogType.vetVisit:
        return 'Vet Visit';
      case LogType.vaccination:
        return 'Vaccination';
      case LogType.symptom:
        return 'Symptom';
    }
  }
}

class HealthLog extends Equatable {
  final String id;
  final String petId;
  final LogType logType;
  final String? value;
  final String? notes;
  final List<String>? imageUrls;
  final Map<String, dynamic>? aiAnalysis;
  final DateTime createdAt;

  const HealthLog({
    required this.id,
    required this.petId,
    required this.logType,
    this.value,
    this.notes,
    this.imageUrls,
    this.aiAnalysis,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        petId,
        logType,
        value,
        notes,
        imageUrls,
        aiAnalysis,
        createdAt,
      ];

  HealthLog copyWith({
    String? id,
    String? petId,
    LogType? logType,
    String? value,
    String? notes,
    List<String>? imageUrls,
    Map<String, dynamic>? aiAnalysis,
    DateTime? createdAt,
  }) {
    return HealthLog(
      id: id ?? this.id,
      petId: petId ?? this.petId,
      logType: logType ?? this.logType,
      value: value ?? this.value,
      notes: notes ?? this.notes,
      imageUrls: imageUrls ?? this.imageUrls,
      aiAnalysis: aiAnalysis ?? this.aiAnalysis,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}