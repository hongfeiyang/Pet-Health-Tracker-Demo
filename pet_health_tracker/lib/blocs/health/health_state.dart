import 'package:equatable/equatable.dart';
import 'package:pet_health_api_client/pet_health_api_client.dart';

abstract class HealthState extends Equatable {
  const HealthState();

  @override
  List<Object> get props => [];
}

class HealthInitial extends HealthState {}

class HealthLoading extends HealthState {}

class HealthLoaded extends HealthState {
  final List<HealthLogResponse> healthLogs;
  final String petId;

  const HealthLoaded({
    required this.healthLogs,
    required this.petId,
  });

  @override
  List<Object> get props => [healthLogs, petId];
}

class HealthError extends HealthState {
  final String message;

  const HealthError({required this.message});

  @override
  List<Object> get props => [message];
}