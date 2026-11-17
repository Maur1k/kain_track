import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/workout_repository.dart';

class LogWorkoutScreen extends ConsumerStatefulWidget {
  const LogWorkoutScreen({super.key});

  @override
  ConsumerState<LogWorkoutScreen> createState() => _LogWorkoutScreenState();
}

class _LogWorkoutScreenState extends ConsumerState<LogWorkoutScreen> {
  final _name = TextEditingController();
  final _duration = TextEditingController();
  final _notes = TextEditingController();
  DateTime _date = DateTime.now();
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _duration.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final duration = _duration.text.trim().isEmpty
        ? null
        : int.tryParse(_duration.text.trim());
    if (_name.text.trim().isEmpty ||
        (_duration.text.trim().isNotEmpty && duration == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Enter a workout name and valid duration.')),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      await ref.read(workoutRepositoryProvider).addSession(
            name: _name.text,
            durationMinutes: duration,
            notes: _notes.text,
            performedAt: _date,
          );
      if (mounted) Navigator.pop(context);
    } on Object catch (error) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Save failed: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add workout')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _name,
            decoration: const InputDecoration(labelText: 'Workout name/type'),
          ),
          TextField(
            controller: _duration,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
                labelText: 'Duration (minutes, optional)'),
          ),
          TextField(
            controller: _notes,
            decoration: const InputDecoration(labelText: 'Notes (optional)'),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              'Date: ${MaterialLocalizations.of(context).formatMediumDate(_date)}',
            ),
            onTap: () async {
              final selected = await showDatePicker(
                context: context,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                initialDate: _date,
              );
              if (selected != null) setState(() => _date = selected);
            },
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _saving ? null : _save,
            child: const Text('Save workout'),
          ),
        ],
      ),
    );
  }
}
