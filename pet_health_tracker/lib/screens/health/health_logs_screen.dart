import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_health_api_client/pet_health_api_client.dart' as api;
import '../../blocs/health/health_bloc.dart';
import '../../blocs/health/health_event.dart';
import '../../blocs/health/health_state.dart';
import 'add_health_log_screen.dart';

class HealthLogsScreen extends StatefulWidget {
  final api.PetResponse pet;

  const HealthLogsScreen({super.key, required this.pet});

  @override
  State<HealthLogsScreen> createState() => _HealthLogsScreenState();
}

class _HealthLogsScreenState extends State<HealthLogsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HealthBloc>().add(HealthLogsLoadRequested(petId: widget.pet.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.pet.name}\'s Health'),
      ),
      body: BlocBuilder<HealthBloc, HealthState>(
        builder: (context, state) {
          if (state is HealthInitial || state is HealthLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HealthError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<HealthBloc>().add(
                            HealthLogsLoadRequested(petId: widget.pet.id),
                          );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state is HealthLoaded) {
            if (state.healthLogs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.health_and_safety,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No health logs yet',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Start tracking ${widget.pet.name}\'s health!',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => _navigateToAddHealthLog(context),
                      icon: const Icon(Icons.add),
                      label: const Text('Add Health Log'),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<HealthBloc>().add(
                      HealthLogsLoadRequested(petId: widget.pet.id),
                    );
              },
              child: ListView.builder(
                itemCount: state.healthLogs.length,
                itemBuilder: (context, index) {
                  final log = state.healthLogs[index];
                  return _HealthLogCard(log: log);
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddHealthLog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToAddHealthLog(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddHealthLogScreen(pet: widget.pet),
      ),
    );
  }
}

class _HealthLogCard extends StatelessWidget {
  final api.HealthLogResponse log;

  const _HealthLogCard({required this.log});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getLogTypeIcon(log.logType),
                  color: _getLogTypeColor(log.logType),
                ),
                const SizedBox(width: 8),
                Text(
                  _getLogTypeDisplayName(log.logType),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  _formatDate(log.createdAt),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (log.value != null) ...[
              Text(
                'Value: ${log.value}',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
            ],
            if (log.notes != null) ...[
              Text(
                'Notes: ${log.notes}',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 4),
            ],
            if (log.imageUrls != null && log.imageUrls!.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Text(
                'Images:',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              SizedBox(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: log.imageUrls!.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(right: 8),
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[200],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          log.imageUrls![index],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.image, color: Colors.grey);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
            if (log.aiAnalysis != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.psychology, color: Colors.blue.shade700, size: 16),
                    const SizedBox(width: 8),
                    const Text(
                      'AI Analysis Available',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}