import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/pets/pets_bloc.dart';
import '../../blocs/pets/pets_event.dart';
import '../../blocs/pets/pets_state.dart';
import '../../models/pet.dart';

class EditPetScreen extends StatefulWidget {
  final Pet pet;

  const EditPetScreen({super.key, required this.pet});

  @override
  State<EditPetScreen> createState() => _EditPetScreenState();
}

class _EditPetScreenState extends State<EditPetScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _breedController;
  late final TextEditingController _ageController;
  late final TextEditingController _weightController;
  late final TextEditingController _medicalHistoryController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.pet.name);
    _breedController = TextEditingController(text: widget.pet.breed ?? '');
    _ageController = TextEditingController(text: widget.pet.age?.toString() ?? '');
    _weightController = TextEditingController(text: widget.pet.weight?.toString() ?? '');
    _medicalHistoryController = TextEditingController(text: widget.pet.medicalHistory ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _medicalHistoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit ${widget.pet.name}'),
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
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Pet updated successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.blue.shade100,
                          child: widget.pet.profileImageUrl != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(40),
                                  child: Image.network(
                                    widget.pet.profileImageUrl!,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.pets, size: 40, color: Colors.blue);
                                    },
                                  ),
                                )
                              : const Icon(Icons.pets, size: 40, color: Colors.blue),
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Pet Name *',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.pets),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your pet\'s name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _breedController,
                          decoration: const InputDecoration(
                            labelText: 'Breed (Optional)',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.category),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _ageController,
                          decoration: const InputDecoration(
                            labelText: 'Age in years (Optional)',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.cake),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value != null && value.isNotEmpty) {
                              final age = int.tryParse(value);
                              if (age == null || age < 0 || age > 50) {
                                return 'Please enter a valid age (0-50)';
                              }
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _weightController,
                          decoration: const InputDecoration(
                            labelText: 'Weight in kg (Optional)',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.monitor_weight),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value != null && value.isNotEmpty) {
                              final weight = double.tryParse(value);
                              if (weight == null || weight < 0 || weight > 200) {
                                return 'Please enter a valid weight (0-200 kg)';
                              }
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _medicalHistoryController,
                          decoration: const InputDecoration(
                            labelText: 'Medical History (Optional)',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.medical_services),
                            alignLabelWithHint: true,
                          ),
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                BlocBuilder<PetsBloc, PetsState>(
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: state is PetsLoading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  _submitForm();
                                }
                              },
                        child: state is PetsLoading
                            ? const CircularProgressIndicator()
                            : const Text('Update Pet'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    final name = _nameController.text.trim();
    final breed = _breedController.text.trim().isEmpty ? null : _breedController.text.trim();
    final age = _ageController.text.trim().isEmpty ? null : int.tryParse(_ageController.text.trim());
    final weight = _weightController.text.trim().isEmpty ? null : double.tryParse(_weightController.text.trim());
    final medicalHistory = _medicalHistoryController.text.trim().isEmpty ? null : _medicalHistoryController.text.trim();

    context.read<PetsBloc>().add(
          PetUpdateRequested(
            petId: widget.pet.id,
            name: name,
            breed: breed,
            age: age,
            weight: weight,
            medicalHistory: medicalHistory,
          ),
        );
  }
}