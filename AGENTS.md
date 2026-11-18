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
1. Maintain the implemented Drift tables and schema migrations.
2. Keep selected-date nutrition, goals, meal logging, foods, workouts, and backups consistent across the UI and repositories.
3. Preserve JSON backup compatibility and the current schema version.
4. Verify Android and iPhone XR builds before changing iOS delivery settings.

## Done Criteria
- App runs on an Android emulator with `flutter run`.
- Data persists after the app restarts.
- Export produces a file that import restores exactly.
- iOS build produces an installable `.ipa`.
