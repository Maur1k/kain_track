import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/meal_repository.dart';
import '../meals/log_meal_screen.dart';
import '../settings/settings_screen.dart';
import '../workouts/log_workout_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calories = ref.watch(todayCaloriesProvider);
    final summary = calories.when(
      data: (total) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${total == total.roundToDouble() ? total.toInt() : total.toStringAsFixed(2)} kcal',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 8),
          if (total == 0) const Text('No meals logged yet'),
        ],
      ),
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) => const Text('Unable to load calories'),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Today'),
        actions: [
          IconButton(
            tooltip: 'Settings',
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: summary,
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: 'log-workout',
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const LogWorkoutScreen(),
                ),
              );
            },
            icon: const Icon(Icons.fitness_center),
            label: const Text('Log workout'),
          ),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            heroTag: 'log-meal',
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const LogMealScreen()),
              );
              ref.invalidate(todayCaloriesProvider);
            },
            icon: const Icon(Icons.add),
            label: const Text('Log meal'),
          ),
        ],
      ),
    );
  }
}
