import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_theme.dart';
import '../../data/repositories/goals_repository.dart';
import '../../data/repositories/meal_repository.dart';
import '../foods/foods_screen.dart';
import '../meals/log_meal_screen.dart';
import '../settings/settings_screen.dart';
import '../workouts/workouts_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      _TodayTab(onOpenFoods: () => setState(() => _tab = 1)),
      const FoodsScreen(),
      const WorkoutsScreen(),
      const _ProgressTab(),
    ];
    return Scaffold(
      body: screens[_tab],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (index) => setState(() => _tab = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.today), label: 'Today'),
          NavigationDestination(icon: Icon(Icons.restaurant), label: 'Foods'),
          NavigationDestination(
            icon: Icon(Icons.fitness_center),
            label: 'Workouts',
          ),
          NavigationDestination(icon: Icon(Icons.insights), label: 'Progress'),
        ],
      ),
    );
  }
}

class _TodayTab extends ConsumerWidget {
  const _TodayTab({required this.onOpenFoods});

  final VoidCallback onOpenFoods;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final totals = ref.watch(selectedDateNutritionProvider);
    final entries = ref.watch(selectedDateEntriesProvider);
    final goals = ref.watch(nutritionGoalsProvider);
    return Scaffold(
      appBar: AppBar(
        title: PopupMenuButton<String>(
          onSelected: (value) => _handleMenu(context, ref, value),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'goals',
              child: goals.when(
                data: (value) =>
                    Text('Deficit Calorie Goal · ${value.calories} kcal'),
                loading: () => const Text('Deficit Calorie Goal'),
                error: (_, __) => const Text('Deficit Calorie Goal'),
              ),
            ),
            const PopupMenuItem(
              value: 'foods',
              child: Text('Food Macro Database'),
            ),
            const PopupMenuItem(
              value: 'reset',
              child: Text(
                "Reset Today's Log",
                style: TextStyle(color: AppColors.over),
              ),
            ),
          ],
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'KAIN TRACK',
                style: TextStyle(
                  color: AppColors.teal,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(width: 4),
              Icon(Icons.keyboard_arrow_down),
            ],
          ),
        ),
        actions: [
          _DatePill(
            date: selectedDate,
            onPrevious: () => _changeDate(ref, selectedDate, -1),
            onNext: () => _changeDate(ref, selectedDate, 1),
          ),
          IconButton(
            tooltip: 'Settings',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: totals.when(
        data: (nutrition) => entries.when(
          data: (grouped) {
            final allEntries = [
              for (final mealEntries in grouped.values) ...mealEntries,
            ]..sort((a, b) => b.entry.loggedAt.compareTo(a.entry.loggedAt));
            return allEntries.isEmpty
                ? _EmptyToday(
                    goals: goals,
                    onOpenGoals: () => _showGoalsDialog(context, ref),
                  )
                : _ActiveToday(
                    nutrition: nutrition,
                    goals: goals.valueOrNull ?? NutritionGoals.defaults,
                    entries: allEntries,
                    onDelete: (entryId) => _deleteEntry(context, ref, entryId),
                  );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => _ErrorMessage(error: error),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _ErrorMessage(error: error),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final logged = await showModalBottomSheet<bool>(
            context: context,
            isScrollControlled: true,
            builder: (_) => FractionallySizedBox(
              heightFactor: 0.88,
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Expanded(
                    child: LogMealScreen(loggedAt: selectedDate),
                  ),
                ],
              ),
            ),
          );
          if (logged == true && context.mounted) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(const SnackBar(content: Text('Meal logged.')));
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Log meal'),
      ),
    );
  }

  static void _changeDate(WidgetRef ref, DateTime date, int days) {
    ref.read(selectedDateProvider.notifier).state =
        date.add(Duration(days: days));
  }

  Future<void> _handleMenu(
    BuildContext context,
    WidgetRef ref,
    String value,
  ) async {
    switch (value) {
      case 'goals':
        await _showGoalsDialog(context, ref);
      case 'foods':
        onOpenFoods();
      case 'reset':
        await _resetDate(context, ref);
    }
  }

  Future<void> _showGoalsDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final current =
        ref.read(nutritionGoalsProvider).valueOrNull ?? NutritionGoals.defaults;
    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => _GoalsDialog(initial: current),
    );
    if (saved == true && context.mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('Goals saved.')));
    }
  }

  Future<void> _resetDate(BuildContext context, WidgetRef ref) async {
    final date = ref.read(selectedDateProvider);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Reset today's log?"),
        content: Text(
          'Delete all meal entries for ${_dateLabel(date)}? Workouts are not affected.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(mealRepositoryProvider).deleteEntriesForDate(date);
      if (context.mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(const SnackBar(content: Text("Today's log reset.")));
      }
    }
  }

  Future<void> _deleteEntry(
    BuildContext context,
    WidgetRef ref,
    int entryId,
  ) async {
    await ref.read(mealRepositoryProvider).deleteEntry(entryId);
    if (context.mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('Meal deleted.')));
    }
  }
}

class _DatePill extends StatelessWidget {
  const _DatePill({
    required this.date,
    required this.onPrevious,
    required this.onNext,
  });

  final DateTime date;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.pillGrey,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: onPrevious,
            icon: const Icon(Icons.chevron_left),
          ),
          Text(
            _dateLabel(date),
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: onNext,
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}

class _EmptyToday extends StatelessWidget {
  const _EmptyToday({required this.goals, required this.onOpenGoals});

  final AsyncValue<NutritionGoals> goals;
  final VoidCallback onOpenGoals;

  @override
  Widget build(BuildContext context) {
    final calories =
        goals.valueOrNull?.calories ?? NutritionGoals.defaults.calories;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '0 kcal',
              style: TextStyle(
                color: AppColors.teal,
                fontSize: 48,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'No meals logged yet',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 20),
            ActionChip(
              onPressed: onOpenGoals,
              label: Text('Deficit Target: $calories kcal'),
              avatar: const Icon(Icons.edit_outlined, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActiveToday extends StatelessWidget {
  const _ActiveToday({
    required this.nutrition,
    required this.goals,
    required this.entries,
    required this.onDelete,
  });

  final Nutrition nutrition;
  final NutritionGoals goals;
  final List<MealEntryWithFood> entries;
  final Future<void> Function(int entryId) onDelete;

  @override
  Widget build(BuildContext context) {
    final over = nutrition.calories > goals.calories;
    final remaining = (goals.calories - nutrition.calories).round().abs();
    final progress = (nutrition.calories / goals.calories).clamp(0.0, 1.0);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'CONSUMED',
                  style: TextStyle(
                    color: AppColors.teal,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${nutrition.calories.round()}',
                      style: const TextStyle(
                        fontSize: 44,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8, left: 8),
                      child: Text('/ ${goals.calories} kcal'),
                    ),
                    const Spacer(),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: over
                            ? AppColors.over.withAlpha(24)
                            : AppColors.mint,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(16)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        child: Text(
                          '$remaining kcal ${over ? 'over' : 'left'}',
                          style: TextStyle(
                            color: over ? AppColors.over : AppColors.teal,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: LinearProgressIndicator(
                    minHeight: 10,
                    value: progress,
                    color: over ? AppColors.over : AppColors.teal,
                    backgroundColor: AppColors.pillGrey,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _MacroTile(
              label: 'Protein',
              value: nutrition.protein,
              goal: goals.protein,
              color: AppColors.protein,
            ),
            const SizedBox(width: 8),
            _MacroTile(
              label: 'Carbs',
              value: nutrition.carbs,
              goal: goals.carbs,
              color: AppColors.carbs,
            ),
            const SizedBox(width: 8),
            _MacroTile(
              label: 'Fat',
              value: nutrition.fat,
              goal: goals.fat,
              color: AppColors.fat,
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Logged Foods',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            Text('${entries.length} ${entries.length == 1 ? 'item' : 'items'}'),
          ],
        ),
        const SizedBox(height: 8),
        for (final item in entries)
          _LoggedFoodCard(item: item, onDelete: () => onDelete(item.entry.id)),
      ],
    );
  }
}

class _MacroTile extends StatelessWidget {
  const _MacroTile({
    required this.label,
    required this.value,
    required this.goal,
    required this.color,
  });

  final String label;
  final double value;
  final int goal;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration:
                        BoxDecoration(color: color, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 6),
                  Text(label,
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${value.round()}g',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              Text('of ${goal}g',
                  style: const TextStyle(color: Colors.black54)),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoggedFoodCard extends StatelessWidget {
  const _LoggedFoodCard({required this.item, required this.onDelete});

  final MealEntryWithFood item;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        title: Text(item.food.name,
            style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(
          '${_slotLabel(item.entry.mealSlot)} · ${_format(item.entry.grams)}g · '
          'P ${_format(item.nutrition.protein)}g · C ${_format(item.nutrition.carbs)}g · '
          'F ${_format(item.nutrition.fat)}g',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${item.nutrition.calories.round()} kcal',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            IconButton(
              tooltip: 'Delete meal',
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoalsDialog extends ConsumerStatefulWidget {
  const _GoalsDialog({required this.initial});

  final NutritionGoals initial;

  @override
  ConsumerState<_GoalsDialog> createState() => _GoalsDialogState();
}

class _GoalsDialogState extends ConsumerState<_GoalsDialog> {
  late final List<TextEditingController> _controllers;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controllers = [
      TextEditingController(text: widget.initial.calories.toString()),
      TextEditingController(text: widget.initial.protein.toString()),
      TextEditingController(text: widget.initial.carbs.toString()),
      TextEditingController(text: widget.initial.fat.toString()),
    ];
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    final values = _controllers
        .map((controller) => int.tryParse(controller.text))
        .toList();
    if (values.any((value) => value == null)) {
      setState(() => _error = 'Enter whole numbers for every goal.');
      return;
    }
    final goals = NutritionGoals(
      calories: values[0]!,
      protein: values[1]!,
      carbs: values[2]!,
      fat: values[3]!,
    );
    try {
      goals.validate();
      await ref.read(nutritionGoalsProvider.notifier).save(goals);
      if (mounted) Navigator.pop(context, true);
    } on ArgumentError catch (error) {
      setState(() => _error = error.message?.toString() ?? 'Invalid goals.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Deficit Calorie Goal'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            for (final pair in [
              ('Calories', _controllers[0]),
              ('Protein (g)', _controllers[1]),
              ('Carbs (g)', _controllers[2]),
              ('Fat (g)', _controllers[3]),
            ])
              TextField(
                controller: pair.$2,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: pair.$1),
              ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  _error!,
                  style: const TextStyle(color: AppColors.over),
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _save, child: const Text('Save')),
      ],
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  const _ErrorMessage({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) =>
      Center(child: Text('Unable to load meals: $error'));
}

class _ProgressTab extends StatelessWidget {
  const _ProgressTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Progress')),
      body: const Center(child: Text('Progress charts coming later.\nTODO')),
    );
  }
}

String _dateLabel(DateTime date) {
  final today = DateTime.now();
  final todayOnly = DateTime(today.year, today.month, today.day);
  final difference =
      DateTime(date.year, date.month, date.day).difference(todayOnly).inDays;
  if (difference == 0) return 'Today';
  if (difference == -1) return 'Yesterday';
  if (difference == 1) return 'Tomorrow';
  const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  return '${weekdays[date.weekday - 1]} ${date.day}';
}

String _format(double value) => value == value.roundToDouble()
    ? value.toInt().toString()
    : value.toStringAsFixed(1);

String _slotLabel(String slot) =>
    slot[0].toUpperCase() + slot.substring(1).toLowerCase();
