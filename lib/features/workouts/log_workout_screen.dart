import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/workout_repository.dart';

class LogWorkoutScreen extends ConsumerStatefulWidget {
  const LogWorkoutScreen({super.key});

  @override
  ConsumerState<LogWorkoutScreen> createState() => _LogWorkoutScreenState();
}

class _WorkoutSetFields {
  final exerciseController = TextEditingController();
  final repsController = TextEditingController();
  final weightController = TextEditingController();
  String? error;

  void dispose() {
    exerciseController.dispose();
    repsController.dispose();
    weightController.dispose();
  }
}

class _LogWorkoutScreenState extends ConsumerState<LogWorkoutScreen> {
  final _notesController = TextEditingController();
  final _sets = [_WorkoutSetFields()];
  DateTime _date = DateTime.now();
  bool _isSaving = false;

  @override
  void dispose() {
    _notesController.dispose();
    for (final set in _sets) {
      set.dispose();
    }
    super.dispose();
  }

  Future<void> _selectDate() async {
    final selected = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDate: _date,
    );
    if (selected != null) setState(() => _date = selected);
  }

  Future<void> _save() async {
    var valid = true;
    for (final set in _sets) {
      final reps = int.tryParse(set.repsController.text.trim());
      final weight = double.tryParse(set.weightController.text.trim());
      String? error;
      if (set.exerciseController.text.trim().isEmpty) {
        error = 'Exercise name is required.';
      } else if (reps == null || reps <= 0) {
        error = 'Reps must be a positive whole number.';
      } else if (weight == null || !weight.isFinite || weight < 0) {
        error = 'Weight must be zero or more.';
      }
      set.error = error;
      valid = valid && error == null;
    }
    setState(() {});
    if (!valid) return;

    setState(() => _isSaving = true);
    try {
      await ref.read(workoutRepositoryProvider).saveWorkout(
        date: _date,
        notes: _notesController.text,
        sets: [
          for (final set in _sets)
            WorkoutSetInput(
              exerciseName: set.exerciseController.text,
              reps: int.parse(set.repsController.text.trim()),
              weightKg: double.parse(set.weightController.text.trim()),
            ),
        ],
      );
      if (mounted) Navigator.of(context).pop();
    } on ArgumentError catch (error) {
      if (mounted) {
        setState(() {
          _isSaving = false;
          _sets.first.error = error.message;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Log workout')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              'Workout date: ${MaterialLocalizations.of(context).formatMediumDate(_date)}',
            ),
            trailing: const Icon(Icons.calendar_today),
            onTap: _selectDate,
          ),
          TextField(
            controller: _notesController,
            decoration: const InputDecoration(labelText: 'Notes (optional)'),
          ),
          const SizedBox(height: 24),
          for (var index = 0; index < _sets.length; index++)
            _buildSetFields(index),
          OutlinedButton.icon(
            onPressed: () => setState(() => _sets.add(_WorkoutSetFields())),
            icon: const Icon(Icons.add),
            label: const Text('Add set'),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _isSaving ? null : _save,
            child: const Text('Save workout'),
          ),
        ],
      ),
    );
  }

  Widget _buildSetFields(int index) {
    final set = _sets[index];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text('Set ${index + 1}',
                style: Theme.of(context).textTheme.titleMedium),
            TextField(
              controller: set.exerciseController,
              decoration: const InputDecoration(labelText: 'Exercise name'),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: set.repsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Reps'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: set.weightController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Weight (kg)'),
                  ),
                ),
              ],
            ),
            if (set.error != null)
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    set.error!,
                    style: TextStyle(color: Colors.red.shade700),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
