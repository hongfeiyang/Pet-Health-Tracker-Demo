import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/pet_repository.dart';
import 'pets_event.dart';
import 'pets_state.dart';

class PetsBloc extends Bloc<PetsEvent, PetsState> {
  final PetRepository _petRepository;

  PetsBloc({required PetRepository petRepository})
      : _petRepository = petRepository,
        super(PetsInitial()) {
    
    on<PetsLoadRequested>(_onLoadRequested);
    on<PetCreateRequested>(_onCreateRequested);
    on<PetUpdateRequested>(_onUpdateRequested);
    on<PetDeleteRequested>(_onDeleteRequested);
  }

  Future<void> _onLoadRequested(
    PetsLoadRequested event,
    Emitter<PetsState> emit,
  ) async {
    emit(PetsLoading());
    
    try {
      final pets = await _petRepository.getPets();
      emit(PetsLoaded(pets: pets));
    } catch (e) {
      emit(PetsError(message: e.toString()));
    }
  }

  Future<void> _onCreateRequested(
    PetCreateRequested event,
    Emitter<PetsState> emit,
  ) async {
    if (state is PetsLoaded) {
      emit(PetsLoading());
    }
    
    try {
      await _petRepository.createPet(
        name: event.name,
        breed: event.breed,
        age: event.age,
        weight: event.weight,
        medicalHistory: event.medicalHistory,
      );
      
      final pets = await _petRepository.getPets();
      emit(PetsLoaded(pets: pets));
    } catch (e) {
      emit(PetsError(message: e.toString()));
    }
  }

  Future<void> _onUpdateRequested(
    PetUpdateRequested event,
    Emitter<PetsState> emit,
  ) async {
    if (state is PetsLoaded) {
      emit(PetsLoading());
    }
    
    try {
      await _petRepository.updatePet(
        petId: event.petId,
        name: event.name,
        breed: event.breed,
        age: event.age,
        weight: event.weight,
        medicalHistory: event.medicalHistory,
      );
      
      final pets = await _petRepository.getPets();
      emit(PetsLoaded(pets: pets));
    } catch (e) {
      emit(PetsError(message: e.toString()));
    }
  }

  Future<void> _onDeleteRequested(
    PetDeleteRequested event,
    Emitter<PetsState> emit,
  ) async {
    if (state is PetsLoaded) {
      emit(PetsLoading());
    }
    
    try {
      await _petRepository.deletePet(event.petId);
      
      final pets = await _petRepository.getPets();
      emit(PetsLoaded(pets: pets));
    } catch (e) {
      emit(PetsError(message: e.toString()));
    }
  }
}