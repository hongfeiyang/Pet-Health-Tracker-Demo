import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_health_api_client/pet_health_api_client.dart' as api;
import '../../blocs/health/health_bloc.dart';
import '../../blocs/health/health_event.dart';
import '../../blocs/health/health_state.dart';

class AddHealthLogScreen extends StatefulWidget {
  final api.PetResponse pet;

  const AddHealthLogScreen({super.key, required this.pet});

  @override
  State<AddHealthLogScreen> createState() => _AddHealthLogScreenState();
}

class _AddHealthLogScreenState extends State<AddHealthLogScreen> {
  final _formKey = GlobalKey<FormState>();
  final _valueController = TextEditingController();
  final _notesController = TextEditingController();
  
  api.LogType _selectedLogType = api.LogType.weight;

  @override
  void dispose() {
    _valueController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Health Log for ${widget.pet.name}'),
      ),
      body: BlocListener<HealthBloc, HealthState>(
        listener: (context, state) {
          if (state is HealthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is HealthLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Health log added successfully!'),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        const Text(
                          'Log Type',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<api.LogType>(
                          value: _selectedLogType,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.category),
                          ),
                          items: api.LogType.values.map((logType) {
                            return DropdownMenuItem(
                              value: logType,
                              child: Row(
                                children: [
                                  Icon(
                                    _getLogTypeIcon(logType),
                                    color: _getLogTypeColor(logType),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(_getLogTypeDisplayName(logType)),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedLogType = value;
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _valueController,
                          decoration: InputDecoration(
                            labelText: _getValueLabel(_selectedLogType),
                            border: const OutlineInputBorder(),
                            prefixIcon: Icon(_getLogTypeIcon(_selectedLogType)),
                            helperText: _getValueHint(_selectedLogType),
                          ),
                          keyboardType: _getKeyboardType(_selectedLogType),
                          validator: (value) {
                            if (_selectedLogType == api.LogType.weight || 
                                _selectedLogType == api.LogType.temperature) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter a value';
                              }
                              final numValue = double.tryParse(value);
                              if (numValue == null) {
                                return 'Please enter a valid number';
                              }
                              if (_selectedLogType == api.LogType.weight && 
                                  (numValue < 0 || numValue > 200)) {
                                return 'Weight should be between 0-200 kg';
                              }
                              if (_selectedLogType == api.LogType.temperature && 
                                  (numValue < 30 || numValue > 45)) {
                                return 'Temperature should be between 30-45°C';
                              }
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _notesController,
                          decoration: const InputDecoration(
                            labelText: 'Notes (Optional)',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.notes),
                            alignLabelWithHint: true,
                          ),
                          maxLines: 3,
                        ),
                        const SizedBox(height: 16),
                        Card(
                          color: Colors.blue.shade50,
                          child: const Padding(
                            padding: EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Icon(Icons.info, color: Colors.blue),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Photo upload and AI analysis features will be added in future updates.',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                BlocBuilder<HealthBloc, HealthState>(
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: state is HealthLoading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  _submitForm();
                                }
                              },
                        child: state is HealthLoading
                            ? const CircularProgressIndicator()
                            : const Text('Add Health Log'),
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
    final value = _valueController.text.trim().isEmpty ? null : _valueController.text.trim();
    final notes = _notesController.text.trim().isEmpty ? null : _notesController.text.trim();

    context.read<HealthBloc>().add(
          HealthLogCreateRequested(
            petId: widget.pet.id,
            logType: _selectedLogType,
            value: value,
            notes: notes,
          ),
        );
  }

  String _getLogTypeDisplayName(api.LogType logType) {
    switch (logType) {
      case api.LogType.weight:
        return 'Weight';
      case api.LogType.temperature:
        return 'Temperature';
      case api.LogType.vetVisit:
        return 'Vet Visit';
      case api.LogType.vaccination:
        return 'Vaccination';
      case api.LogType.symptom:
        return 'Symptom';
      default:
        return 'Unknown';
    }
  }

  IconData _getLogTypeIcon(api.LogType logType) {
    switch (logType) {
      case api.LogType.weight:
        return Icons.monitor_weight;
      case api.LogType.temperature:
        return Icons.thermostat;
      case api.LogType.vetVisit:
        return Icons.local_hospital;
      case api.LogType.vaccination:
        return Icons.vaccines;
      case api.LogType.symptom:
        return Icons.sick;
      default:
        return Icons.pets;
    }
  }

  Color _getLogTypeColor(api.LogType logType) {
    switch (logType) {
      case api.LogType.weight:
        return Colors.blue;
      case api.LogType.temperature:
        return Colors.orange;
      case api.LogType.vetVisit:
        return Colors.green;
      case api.LogType.vaccination:
        return Colors.purple;
      case api.LogType.symptom:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getValueLabel(api.LogType logType) {
    switch (logType) {
      case api.LogType.weight:
        return 'Weight (kg) *';
      case api.LogType.temperature:
        return 'Temperature (°C) *';
      case api.LogType.vetVisit:
        return 'Clinic/Doctor Name (Optional)';
      case api.LogType.vaccination:
        return 'Vaccine Name (Optional)';
      case api.LogType.symptom:
        return 'Symptom Description (Optional)';
      default:
        return 'Value (Optional)';
    }
  }

  String _getValueHint(api.LogType logType) {
    switch (logType) {
      case api.LogType.weight:
        return 'e.g., 25.5';
      case api.LogType.temperature:
        return 'e.g., 38.5';
      case api.LogType.vetVisit:
        return 'e.g., Dr. Smith at Pet Care Clinic';
      case api.LogType.vaccination:
        return 'e.g., Rabies, DHPP';
      case api.LogType.symptom:
        return 'e.g., Vomiting, Lethargy';
      default:
        return 'Enter value';
    }
  }

  TextInputType _getKeyboardType(api.LogType logType) {
    switch (logType) {
      case api.LogType.weight:
      case api.LogType.temperature:
        return TextInputType.number;
      default:
        return TextInputType.text;
    }
  }
}