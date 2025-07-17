import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_health_api_client/pet_health_api_client.dart';
import '../../blocs/pets/pets_bloc.dart';
import '../../blocs/pets/pets_event.dart';
import '../../blocs/pets/pets_state.dart';
import '../../blocs/health/health_bloc.dart';
import '../../blocs/health/health_event.dart';
import '../health/health_logs_screen.dart';
import 'edit_pet_screen.dart';

class PetDetailScreen extends StatelessWidget {
  final PetResponse pet;

  const PetDetailScreen({
    super.key,
    required this.pet,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pet.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _navigateToEditPet(context),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete') {
                _showDeleteDialog(context);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Delete Pet', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: BlocListener<PetsBloc, PetsState>(
        listener: (context, state) {
          if (state is PetsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is PetsLoaded) {
            final petExists = state.pets.any((p) => p.id == pet.id);
            if (!petExists) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Pet deleted successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.blue.shade100,
                  child: pet.profileImageUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: Image.network(
                            pet.profileImageUrl!,
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.pets,
                                size: 60,
                                color: Colors.blue,
                              );
                            },
                          ),
                        )
                      : const Icon(
                          Icons.pets,
                          size: 60,
                          color: Colors.blue,
                        ),
                ),
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pet Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _InfoRow(label: 'Name', value: pet.name),
                      if (pet.breed != null) _InfoRow(label: 'Breed', value: pet.breed!),
                      if (pet.age != null) _InfoRow(label: 'Age', value: '${pet.age} years'),
                      if (pet.weight != null) _InfoRow(label: 'Weight', value: '${pet.weight} kg'),
                      if (pet.medicalHistory != null) ...[
                        const SizedBox(height: 8),
                        const Text(
                          'Medical History:',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 4),
                        Text(pet.medicalHistory!),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _navigateToHealthLogs(context),
                  icon: const Icon(Icons.health_and_safety),
                  label: const Text('View Health Logs'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToEditPet(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditPetScreen(pet: pet),
      ),
    );
  }

  void _navigateToHealthLogs(BuildContext context) {
    context.read<HealthBloc>().add(HealthLogsLoadRequested(petId: pet.id));
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => HealthLogsScreen(pet: pet),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Pet'),
        content: Text('Are you sure you want to delete ${pet.name}? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<PetsBloc>().add(PetDeleteRequested(petId: pet.id));
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}