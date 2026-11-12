import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/meal_repository.dart';

class LogMealScreen extends ConsumerStatefulWidget {
  const LogMealScreen({super.key});

  @override
  ConsumerState<LogMealScreen> createState() => _LogMealScreenState();
}

class _LogMealScreenState extends ConsumerState<LogMealScreen> {
  final _foodNameController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _gramsController = TextEditingController();
  String _mealType = 'breakfast';
  String? _error;
  bool _isSaving = false;

  @override
  void dispose() {
    _foodNameController.dispose();
    _caloriesController.dispose();
    _gramsController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final calories = double.tryParse(_caloriesController.text.trim());
    final grams = double.tryParse(_gramsController.text.trim());
    if (_foodNameController.text.trim().isEmpty) {
      setState(() => _error = 'Food name is required.');
      return;
    }
    if (calories == null || !calories.isFinite || calories <= 0) {
      setState(() => _error = 'Calories must be a positive number.');
      return;
    }
    if (grams == null || !grams.isFinite || grams <= 0) {
      setState(() => _error = 'Grams must be a positive number.');
      return;
    }

    setState(() {
      _error = null;
      _isSaving = true;
    });
    try {
      await ref.read(mealRepositoryProvider).logMeal(
            foodName: _foodNameController.text,
            caloriesPer100g: calories,
            grams: grams,
            mealType: _mealType,
          );
      if (mounted) Navigator.of(context).pop();
    } on ArgumentError catch (error) {
      if (mounted) {
        setState(() {
          _error = error.message;
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Log meal')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _foodNameController,
            decoration: const InputDecoration(labelText: 'Food name'),
          ),
          TextField(
            controller: _caloriesController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Calories per 100g',
            ),
          ),
          TextField(
            controller: _gramsController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Grams eaten'),
          ),
          DropdownButtonFormField<String>(
            initialValue: _mealType,
            decoration: const InputDecoration(labelText: 'Meal type'),
            items: const [
              DropdownMenuItem(value: 'breakfast', child: Text('Breakfast')),
              DropdownMenuItem(value: 'lunch', child: Text('Lunch')),
              DropdownMenuItem(value: 'dinner', child: Text('Dinner')),
              DropdownMenuItem(value: 'snack', child: Text('Snack')),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _mealType = value);
            },
          ),
          if (_error != null) ...[
            const SizedBox(height: 16),
            Text(_error!, style: TextStyle(color: Colors.red.shade700)),
          ],
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _isSaving ? null : _save,
            child: const Text('Save meal'),
          ),
        ],
      ),
    );
  }
}
