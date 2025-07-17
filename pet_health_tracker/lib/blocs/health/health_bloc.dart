import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/health_repository.dart';
import 'health_event.dart';
import 'health_state.dart';

class HealthBloc extends Bloc<HealthEvent, HealthState> {
  final HealthRepository _healthRepository;

  HealthBloc({required HealthRepository healthRepository})
      : _healthRepository = healthRepository,
        super(HealthInitial()) {
    
    on<HealthLogsLoadRequested>(_onLoadRequested);
    on<HealthLogCreateRequested>(_onCreateRequested);
  }

  Future<void> _onLoadRequested(
    HealthLogsLoadRequested event,
    Emitter<HealthState> emit,
  ) async {
    emit(HealthLoading());
    
    try {
      final healthLogs = await _healthRepository.getHealthLogs(event.petId);
      emit(HealthLoaded(healthLogs: healthLogs, petId: event.petId));
    } catch (e) {
      emit(HealthError(message: e.toString()));
    }
  }

  Future<void> _onCreateRequested(
    HealthLogCreateRequested event,
    Emitter<HealthState> emit,
  ) async {
    final currentState = state;
    if (currentState is HealthLoaded) {
      emit(HealthLoading());
    }
    
    try {
      await _healthRepository.createHealthLog(
        petId: event.petId,
        logType: event.logType,
        value: event.value,
        notes: event.notes,
        imageUrls: event.imageUrls,
      );
      
      final healthLogs = await _healthRepository.getHealthLogs(event.petId);
      emit(HealthLoaded(healthLogs: healthLogs, petId: event.petId));
    } catch (e) {
      emit(HealthError(message: e.toString()));
    }
  }
}