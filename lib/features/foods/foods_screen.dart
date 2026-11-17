import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/db/database.dart';
import '../../data/repositories/food_repository.dart';

class FoodsScreen extends ConsumerStatefulWidget {
  const FoodsScreen({super.key});

  @override
  ConsumerState<FoodsScreen> createState() => _FoodsScreenState();
}

class _FoodsScreenState extends ConsumerState<FoodsScreen> {
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _showFoodForm([Food? food]) async {
    final form = await showDialog<_FoodFormResult>(
      context: context,
      builder: (_) => _FoodFormDialog(food: food),
    );
    if (form != null) {
      try {
        final repository = ref.read(foodRepositoryProvider);
        final parsed = form.values.map(double.parse).toList();
        if (food == null) {
          await repository.addCustomFood(
            name: form.name,
            caloriesPer100g: parsed[0],
            proteinPer100g: parsed[1],
            carbsPer100g: parsed[2],
            fatPer100g: parsed[3],
          );
        } else {
          await repository.editCustomFood(
            id: food.id,
            name: form.name,
            caloriesPer100g: parsed[0],
            proteinPer100g: parsed[1],
            carbsPer100g: parsed[2],
            fatPer100g: parsed[3],
          );
        }
        ref.invalidate(foodsProvider);
      } on Object catch (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Save failed: $error')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final foods = ref.watch(foodsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Foods')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _search,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                labelText: 'Search foods',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: foods.when(
              data: (items) => ListView(
                children: [
                  for (final food in items.where(
                    (food) => food.name.toLowerCase().contains(
                          _search.text.toLowerCase(),
                        ),
                  ))
                    ListTile(
                      title: Text(food.name),
                      subtitle: Text(
                        '${food.caloriesPer100g} kcal · P ${food.proteinPer100g}g · '
                        'C ${food.carbsPer100g}g · F ${food.fatPer100g}g',
                      ),
                      trailing: food.isCustom
                          ? IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _showFoodForm(food),
                            )
                          : null,
                    ),
                ],
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) =>
                  Center(child: Text('Unable to load foods: $error')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showFoodForm,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _FoodFormResult {
  const _FoodFormResult({required this.name, required this.values});

  final String name;
  final List<String> values;
}

class _FoodFormDialog extends StatefulWidget {
  const _FoodFormDialog({this.food});

  final Food? food;

  @override
  State<_FoodFormDialog> createState() => _FoodFormDialogState();
}

class _FoodFormDialogState extends State<_FoodFormDialog> {
  late final TextEditingController _name;
  late final List<TextEditingController> _values;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.food?.name);
    _values = [
      TextEditingController(text: widget.food?.caloriesPer100g.toString()),
      TextEditingController(text: widget.food?.proteinPer100g.toString()),
      TextEditingController(text: widget.food?.carbsPer100g.toString()),
      TextEditingController(text: widget.food?.fatPer100g.toString()),
    ];
  }

  @override
  void dispose() {
    _name.dispose();
    for (final controller in _values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.food == null ? 'Add custom food' : 'Edit food'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            for (final pair in [
              ('Calories per 100g', _values[0]),
              ('Protein per 100g', _values[1]),
              ('Carbs per 100g', _values[2]),
              ('Fat per 100g', _values[3]),
            ])
              TextField(
                controller: pair.$2,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: pair.$1),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(
            context,
            _FoodFormResult(
              name: _name.text,
              values: [for (final value in _values) value.text],
            ),
          ),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
