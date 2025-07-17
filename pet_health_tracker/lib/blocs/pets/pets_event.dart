import 'package:equatable/equatable.dart';

abstract class PetsEvent extends Equatable {
  const PetsEvent();

  @override
  List<Object> get props => [];
}

class PetsLoadRequested extends PetsEvent {}

class PetCreateRequested extends PetsEvent {
  final String name;
  final String? breed;
  final int? age;
  final double? weight;
  final String? medicalHistory;

  const PetCreateRequested({
    required this.name,
    this.breed,
    this.age,
    this.weight,
    this.medicalHistory,
  });

  @override
  List<Object> get props => [name];
}

class PetUpdateRequested extends PetsEvent {
  final String petId;
  final String name;
  final String? breed;
  final int? age;
  final double? weight;
  final String? medicalHistory;

  const PetUpdateRequested({
    required this.petId,
    required this.name,
    this.breed,
    this.age,
    this.weight,
    this.medicalHistory,
  });

  @override
  List<Object> get props => [petId, name];
}

class PetDeleteRequested extends PetsEvent {
  final String petId;

  const PetDeleteRequested({required this.petId});

  @override
  List<Object> get props => [petId];
}