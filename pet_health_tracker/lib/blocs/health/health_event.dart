import 'package:equatable/equatable.dart';
import 'package:pet_health_api_client/pet_health_api_client.dart';

abstract class HealthEvent extends Equatable {
  const HealthEvent();

  @override
  List<Object> get props => [];
}

class HealthLogsLoadRequested extends HealthEvent {
  final String petId;

  const HealthLogsLoadRequested({required this.petId});

  @override
  List<Object> get props => [petId];
}

class HealthLogCreateRequested extends HealthEvent {
  final String petId;
  final LogType logType;
  final String? value;
  final String? notes;
  final List<String>? imageUrls;

  const HealthLogCreateRequested({
    required this.petId,
    required this.logType,
    this.value,
    this.notes,
    this.imageUrls,
  });

  @override
  List<Object> get props => [petId, logType];
}