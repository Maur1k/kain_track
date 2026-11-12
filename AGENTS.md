# Agent Instructions: Kain Track

## Project Goal
An offline mobile app for tracking calories (meals) and workouts. Personal project for a single user.

## Read First
1. `README.md`: project overview and scope
2. `tech-stack.md`: chosen technologies and constraints
3. `ios-testing-workflow.md`: how the app gets onto the iPhone XR

## Rules
- Use Flutter and Dart only. Do not introduce a backend, authentication, or cloud services in v1.
- Store all data locally in SQLite via Drift.
- Use only free and open source packages. Check the license of each new dependency and list it in a `DEPENDENCIES.md`.
- Keep every package compatible with iOS 18 (iPhone XR).
- Use Riverpod for state management.
- Do not bundle the USDA dataset until the schema is agreed.
- Ask before adding any feature outside the scope in `README.md`.

## Suggested First Steps
1. Scaffold the Flutter project in this folder (`flutter create .`).
2. Set up Drift with tables for `meals`, `food_items`, `workouts`, and `exercises`.
3. Build a basic home screen with a daily calorie total and a "log meal" button.
4. Add a workout log screen.
5. Add JSON export and import.
6. Configure the Codemagic iOS build (unsigned `.ipa`).

## Done Criteria
- App runs on an Android emulator with `flutter run`.
- Data persists after the app restarts.
- Export produces a file that import restores exactly.
- iOS build produces an installable `.ipa`.
