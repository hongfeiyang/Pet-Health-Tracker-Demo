import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/health/health_bloc.dart';
import '../../blocs/health/health_event.dart';
import '../../blocs/health/health_state.dart';
import '../../models/pet.dart';
import '../../models/health_log.dart';

class AddHealthLogScreen extends StatefulWidget {
  final Pet pet;

  const AddHealthLogScreen({super.key, required this.pet});

  @override
  State<AddHealthLogScreen> createState() => _AddHealthLogScreenState();
}

class _AddHealthLogScreenState extends State<AddHealthLogScreen> {
  final _formKey = GlobalKey<FormState>();
  final _valueController = TextEditingController();
  final _notesController = TextEditingController();
  
  LogType _selectedLogType = LogType.weight;

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
                        DropdownButtonFormField<LogType>(
                          value: _selectedLogType,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.category),
                          ),
                          items: LogType.values.map((logType) {
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
                                  Text(logType.displayName),
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
                            if (_selectedLogType == LogType.weight || 
                                _selectedLogType == LogType.temperature) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter a value';
                              }
                              final numValue = double.tryParse(value);
                              if (numValue == null) {
                                return 'Please enter a valid number';
                              }
                              if (_selectedLogType == LogType.weight && 
                                  (numValue < 0 || numValue > 200)) {
                                return 'Weight should be between 0-200 kg';
                              }
                              if (_selectedLogType == LogType.temperature && 
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

  IconData _getLogTypeIcon(LogType logType) {
    switch (logType) {
      case LogType.weight:
        return Icons.monitor_weight;
      case LogType.temperature:
        return Icons.thermostat;
      case LogType.vetVisit:
        return Icons.local_hospital;
      case LogType.vaccination:
        return Icons.vaccines;
      case LogType.symptom:
        return Icons.sick;
    }
  }

  Color _getLogTypeColor(LogType logType) {
    switch (logType) {
      case LogType.weight:
        return Colors.blue;
      case LogType.temperature:
        return Colors.orange;
      case LogType.vetVisit:
        return Colors.green;
      case LogType.vaccination:
        return Colors.purple;
      case LogType.symptom:
        return Colors.red;
    }
  }

  String _getValueLabel(LogType logType) {
    switch (logType) {
      case LogType.weight:
        return 'Weight (kg) *';
      case LogType.temperature:
        return 'Temperature (°C) *';
      case LogType.vetVisit:
        return 'Clinic/Doctor Name (Optional)';
      case LogType.vaccination:
        return 'Vaccine Name (Optional)';
      case LogType.symptom:
        return 'Symptom Description (Optional)';
    }
  }

  String _getValueHint(LogType logType) {
    switch (logType) {
      case LogType.weight:
        return 'e.g., 25.5';
      case LogType.temperature:
        return 'e.g., 38.5';
      case LogType.vetVisit:
        return 'e.g., Dr. Smith at Pet Care Clinic';
      case LogType.vaccination:
        return 'e.g., Rabies, DHPP';
      case LogType.symptom:
        return 'e.g., Vomiting, Lethargy';
    }
  }

  TextInputType _getKeyboardType(LogType logType) {
    switch (logType) {
      case LogType.weight:
      case LogType.temperature:
        return TextInputType.number;
      default:
        return TextInputType.text;
    }
  }
}