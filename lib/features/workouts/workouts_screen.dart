import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/workout_repository.dart';
import 'log_workout_screen.dart';

class WorkoutsScreen extends ConsumerWidget {
  const WorkoutsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workouts = ref.watch(todayWorkoutsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Workouts')),
      body: workouts.when(
        data: (items) => items.isEmpty
            ? const Center(child: Text('No workouts logged today.'))
            : ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  for (final workout in items)
                    Card(
                      child: ListTile(
                        title: Text(workout.name),
                        subtitle: Text([
                          if (workout.durationMinutes != null)
                            '${workout.durationMinutes} minutes',
                          if (workout.notes != null) workout.notes!,
                        ].join(' · ')),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            try {
                              await ref
                                  .read(workoutRepositoryProvider)
                                  .deleteSession(workout.id);
                              ref.invalidate(todayWorkoutsProvider);
                            } on Object catch (error) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Delete failed: $error')),
                                );
                              }
                            }
                          },
                        ),
                      ),
                    ),
                ],
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) =>
            Center(child: Text('Unable to load workouts: $error')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const LogWorkoutScreen()),
          );
          ref.invalidate(todayWorkoutsProvider);
        },
        icon: const Icon(Icons.add),
        label: const Text('Add workout'),
      ),
    );
  }
}
