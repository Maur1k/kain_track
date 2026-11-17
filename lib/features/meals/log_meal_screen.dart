import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/db/database.dart';
import '../../data/repositories/food_repository.dart';
import '../../data/repositories/meal_repository.dart';
import '../foods/foods_screen.dart';

class LogMealScreen extends ConsumerStatefulWidget {
  const LogMealScreen({super.key, this.loggedAt});

  final DateTime? loggedAt;

  @override
  ConsumerState<LogMealScreen> createState() => _LogMealScreenState();
}

class _LogMealScreenState extends ConsumerState<LogMealScreen> {
  final _gramsController = TextEditingController();
  final _searchController = TextEditingController();
  Food? _food;
  String _mealSlot = 'breakfast';
  String _category = 'All';
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _gramsController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final grams = double.tryParse(_gramsController.text.trim());
    if (_food == null) {
      setState(() => _error = 'Choose a food.');
      return;
    }
    if (grams == null || !grams.isFinite || grams <= 0) {
      setState(() => _error = 'Grams must be positive.');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref.read(mealRepositoryProvider).addEntry(
            foodId: _food!.id,
            grams: grams,
            mealSlot: _mealSlot,
            loggedAt: widget.loggedAt ?? DateTime.now(),
          );
      if (mounted) Navigator.pop(context, true);
    } on Object catch (error) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = 'Save failed: $error';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final foods = ref.watch(foodsProvider);
    final grams = double.tryParse(_gramsController.text) ?? 0;
    final preview =
        _food == null ? null : nutritionFor(_food!, grams > 0 ? grams : 0);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log meal'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            tooltip: 'Close',
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          16,
          0,
          16,
          16 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        children: [
          DropdownButtonFormField<String>(
            initialValue: _mealSlot,
            decoration: const InputDecoration(labelText: 'Meal slot'),
            items: const [
              DropdownMenuItem(value: 'breakfast', child: Text('Breakfast')),
              DropdownMenuItem(value: 'lunch', child: Text('Lunch')),
              DropdownMenuItem(value: 'dinner', child: Text('Dinner')),
              DropdownMenuItem(value: 'snack', child: Text('Snack')),
            ],
            onChanged: (value) => setState(() => _mealSlot = value!),
          ),
          const SizedBox(height: 16),
          foods.when(
            data: _buildFoodPicker,
            loading: () => const LinearProgressIndicator(),
            error: (error, _) => Text('Unable to load foods: $error'),
          ),
          const SizedBox(height: 12),
          TextField(
            key: const Key('meal-grams'),
            controller: _gramsController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(labelText: 'Grams'),
          ),
          if (preview != null) ...[
            const SizedBox(height: 16),
            Text(
              'Preview: ${preview.calories.toStringAsFixed(2)} kcal · '
              '${preview.protein.toStringAsFixed(2)}g protein · '
              '${preview.carbs.toStringAsFixed(2)}g carbs · '
              '${preview.fat.toStringAsFixed(2)}g fat',
            ),
          ],
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                _error!,
                style: TextStyle(color: Colors.red.shade700),
              ),
            ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _saving ? null : _save,
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodPicker(List<Food> items) {
    const categories = [
      'All',
      'High Protein',
      'Filipino',
      'Carbs & Grains',
      'Fruits & Snacks',
    ];
    final query = _searchController.text.trim().toLowerCase();
    final filtered = items.where((food) {
      final matchesSearch =
          query.isEmpty || food.name.toLowerCase().contains(query);
      final matchesCategory = switch (_category) {
        'High Protein' => food.category == 'Protein',
        'Filipino' => food.category == 'Filipino',
        'Carbs & Grains' => food.category == 'Carbs',
        'Fruits & Snacks' => food.category == 'Snacks',
        _ => true,
      };
      return matchesSearch && matchesCategory;
    }).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          key: const Key('food-search'),
          controller: _searchController,
          onChanged: (_) => setState(() {}),
          decoration: const InputDecoration(
            labelText: 'Search foods',
            prefixIcon: Icon(Icons.search),
          ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final category in categories)
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: FilterChip(
                    label: Text(category),
                    selected: _category == category,
                    onSelected: (_) => setState(() => _category = category),
                  ),
                ),
              ActionChip(
                label: const Text('+ Custom Food'),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const FoodsScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        if (filtered.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('No foods found.'),
          )
        else
          for (final food in filtered)
            Card(
              child: ListTile(
                selected: _food?.id == food.id,
                onTap: () => setState(() => _food = food),
                title: Text(food.name),
                subtitle: Text(
                  '${food.caloriesPer100g.round()} kcal per 100g · '
                  '${food.category}',
                ),
                trailing: _food?.id == food.id
                    ? const Icon(Icons.check_circle)
                    : null,
              ),
            ),
      ],
    );
  }
}
