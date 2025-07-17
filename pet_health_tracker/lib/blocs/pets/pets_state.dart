import 'package:equatable/equatable.dart';
import '../../models/pet.dart';

abstract class PetsState extends Equatable {
  const PetsState();

  @override
  List<Object> get props => [];
}

class PetsInitial extends PetsState {}

class PetsLoading extends PetsState {}

class PetsLoaded extends PetsState {
  final List<Pet> pets;

  const PetsLoaded({required this.pets});

  @override
  List<Object> get props => [pets];
}

class PetsError extends PetsState {
  final String message;

  const PetsError({required this.message});

  @override
  List<Object> get props => [message];
}