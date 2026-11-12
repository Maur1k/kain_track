---
name: fitness-app-development
description: Develop the offline Flutter fitness app (calorie and workout tracker) in ~/Documents/fitness-app. Use for any implementation task in this project: scaffolding, database schema, screens, state, charts, notifications, export/import, tests, and iOS build setup. Follows the project's tech stack, scope, and iPhone XR constraints.
---

# Fitness App Development

An offline Flutter app for logging meals (calories) and workouts. Personal project, single user, no backend.

## Before You Start

Read these files in the project root, in this order, every new session:

1. `AGENTS.md`: rules and done criteria
2. `README.md`: scope
3. `tech-stack.md`: approved packages and constraints
4. `PROGRESS.md` (if it exists): what is already done and what is next
5. `ios-testing-workflow.md`: only when working on iOS builds

If a request falls outside the scope in `README.md`, stop and ask before building it.

## Non-Negotiable Constraints

- Flutter and Dart only. No backend, auth, analytics, ads, or cloud sync in v1.
- All data lives on device in SQLite through Drift.
- Every dependency must be free, open source, and compatible with iOS 18. Before adding one, check its license and iOS support, then record it in `DEPENDENCIES.md` with name, version, license, and purpose.
- Use Riverpod for state. Do not mix in another state solution.
- Do not add a food dataset to the app until the schema is agreed with the user.
- Never commit secrets, signing certificates, or Apple credentials.

## Architecture

Use a simple layered structure under `lib/`:

```
lib/
  main.dart
  app/            # app widget, routing, theme
  data/
    db/           # Drift database, tables, DAOs, migrations
    repositories/ # thin layer the UI calls; wraps DAOs
    io/           # JSON export and import
  domain/         # plain Dart models used by UI and logic
  features/
    home/         # daily calorie summary
    meals/        # log and edit meals and food items
    workouts/     # log and edit workouts and exercises
    progress/     # charts and weekly summaries
    settings/     # reminders, export, import
  shared/         # reusable widgets, formatters, constants
test/
  unit/
  widget/
  integration/
```

Keep UI widgets free of database calls. Screens read providers; providers call repositories; repositories call DAOs.

## Data Model (starting point)

Propose changes to this schema before implementing them.

- `food_items`: id, name, calories_per_100g, protein_g, carbs_g, fat_g, serving_size_g, source, is_custom
- `meals`: id, logged_at (UTC), meal_type (breakfast, lunch, dinner, snack), notes
- `meal_entries`: id, meal_id, food_item_id, grams, calories (stored, computed on save)
- `exercises`: id, name, category, is_custom
- `workouts`: id, started_at, duration_minutes, notes
- `workout_sets`: id, workout_id, exercise_id, set_number, reps, weight_kg, duration_seconds

Rules:
- Store timestamps in UTC; convert for display.
- Store weights in metric (kg, g); convert in the UI if needed.
- Store computed calories when a meal entry is saved so history does not change if food data is edited later.
- Use migrations for every schema change. Never edit an old migration after it has shipped.

## Workflow for Each Task

1. **Restate the task** in one or two sentences and confirm it is in scope.
2. **Check current state**: read the relevant files, run `flutter analyze`, and check for existing tests.
3. **Plan small**: list the files you will create or change. Keep each change reviewable.
4. **Implement**: write the code, then the tests for it.
5. **Verify**: run `dart format .`, `flutter analyze` (no warnings), and `flutter test`. For UI changes, run `flutter run` on the Android emulator and check the screen.
6. **Update docs**: add dependencies to `DEPENDENCIES.md` and a dated entry to `PROGRESS.md`.
7. **Report**: summarize what changed, what was verified, and what is still open.

Do not claim a feature works unless you ran it. If you could not run something, say so.

## Code Standards

- Follow the official Dart style guide and `flutter_lints`.
- Prefer `const` constructors and immutable models.
- Put database code behind repositories so it can be tested with an in-memory Drift database.
- Handle empty states, such as a day with no meals, and loading and error states, explicitly.
- Keep numbers that affect health guidance (calorie math, macros) in one tested utility. Do not scatter them across widgets.
- Label every interactive widget for accessibility (`Semantics`, tooltips, readable text sizes).
- Do not give medical advice in the UI. Calorie targets are user-set; do not present them as recommendations.

## Testing Requirements

- **Unit tests**: calorie and macro calculations, unit conversions, date and week boundaries, export and import round trips.
- **Repository tests**: use an in-memory Drift database for every DAO method that writes or deletes.
- **Widget tests**: key screens render with empty data and with sample data.
- **Integration test**: one end-to-end flow (log a meal, log a workout, see both on the home screen).
- A feature is not done without tests for its logic.

## Persistence and Backup

- Data must survive app restarts. Test this on the emulator by killing and relaunching the app.
- JSON export includes a `schema_version` and all tables. Import validates the version and the structure before writing anything, and runs inside a single transaction so a failed import leaves existing data unchanged.
- Export a round-trip test fixture and keep it in `test/fixtures/`.

## Notifications

- Use `flutter_local_notifications` only. Request permission at the moment the user enables reminders, not on first launch.
- Notifications must work offline.

## iOS Build

- Do not try to build iOS locally on Windows or Linux.
- Keep `codemagic.yaml` at the repo root, configured for an unsigned iOS build that outputs an `.ipa`.
- Before the first iOS build, confirm `ios/Podfile` and the minimum iOS deployment target are set to a version that supports iPhone XR on iOS 18.
- Remind the user that free Apple ID sideloads expire after 7 days.

## Progress Log

Maintain `PROGRESS.md` with one entry per session:

```
## YYYY-MM-DD
- Done: ...
- Verified: ... (commands run, emulator checks)
- Open: ...
- Decisions needing user input: ...
```

## When to Ask the User

Stop and ask before:
- adding a feature not in `README.md`
- adding a dependency with a non-permissive license or no iOS support
- changing the data model after it has data in it
- bundling a food database
- anything that would require an account, server, or network call
