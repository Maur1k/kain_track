# Progress

## 2025-11-12 (scaffolded by hand, not yet compiled)
- Done: pubspec.yaml, analysis_options.yaml, lib/ folder structure, placeholder home screen with "Log meal" button, widget test for home screen, DEPENDENCIES.md, .gitignore.
- Verified: NOT run. Flutter SDK was not available in the environment where these files were written. Nothing has been compiled or tested yet.
- Open:
  1. On the laptop, run `flutter create --project-name kain_track --org com.maurik --platforms android,ios .` inside this folder. This generates android/ and ios/ and may overwrite lib/main.dart and pubspec.yaml; back up first or re-apply these files afterward.
  2. Run `flutter pub get`, `flutter analyze`, `flutter test`, and `flutter run` on the Android emulator.
  3. Add Drift database (next step in AGENTS.md).
- Decisions needing user input: none yet.
-Done
  
  4. Set the display name shown on the phone to "Kain Track": `android:label` in `android/app/src/main/AndroidManifest.xml` and `CFBundleDisplayName` in `ios/Runner/Info.plist`. `flutter create` uses the project name by default.
-Done

## 2026-11-12
- Done: Verified the display name is set to `Kain Track` in `android/app/src/main/AndroidManifest.xml` (`android:label`) and `ios/Runner/Info.plist` (`CFBundleDisplayName`). Ran the required formatter, which formatted `lib/data/repositories/meal_repository.dart`.
- Verified: `dart format .` completed successfully (`Formatted 5 files (1 changed) in 0.04 seconds`); `flutter analyze` completed with `No issues found!`; `flutter test` completed with `All tests passed!` (1 test).
- Open: The next unfinished scope item remains the workout log screen. No new packages, features, or schema changes were added in this session.
- Decisions needing user input: none.

## 2026-11-12
- Done: Connected the home screen to Drift through `MealRepository`, Riverpod database/repository providers, and a today's calorie total query. Added in-memory repository tests and updated the widget test to override `databaseProvider`.
- Verified: `dart format .` completed successfully (`Formatted 8 files (0 changed)`); `flutter analyze` completed with `No issues found!`; `flutter test` completed with `All tests passed!` (3 tests).
- Open: The log-meal form is not added yet.
- Decisions needing user input: none.

## 2026-11-12
- Done: Added the log-meal form for food name, calories per 100g, grams, and meal type. `MealRepository` now validates input, reuses food items by name, stores one meal entry with calories computed at save time, and uses a persistent SQLite file. The home screen refreshes after saving.
- Verified: `dart format .` completed successfully (`Formatted 9 files (0 changed)`); `flutter analyze` completed with `No issues found!`; `flutter test` completed with `All tests passed!` (7 tests).
- Open: Verify the flow manually on the Android emulator, including persistence after fully closing and reopening the app.
- Decisions needing user input: none.

## 2026-11-12
- Done: Added Drift tables and a version-3 migration for exercises, workouts, and workout sets. Added `WorkoutRepository` with validation, exercise reuse, set persistence, and today's filter. Added the log-workout screen with date, notes, dynamic sets, inline validation, and a home-screen button. Added repository and widget tests.
- Verified: `dart run build_runner build --delete-conflicting-outputs` completed successfully; `dart format .` completed successfully (`Formatted 13 files (0 changed)`); `flutter analyze` completed with `No issues found!`; `flutter test` completed with `All tests passed!` (12 tests).
- Open: Verify the workout flow manually on the Android emulator, including that a logged workout remains visible after fully closing and reopening the app.
- Decisions needing user input: none.

## 2026-11-12
- Done: Added strict JSON export/import for all six Drift tables, atomic replacement imports, a sample fixture and backup tests, plus minimal Settings export/import actions reachable from Home. Added `file_picker` and `share_plus`.
- Verified: `dart run build_runner build --delete-conflicting-outputs` required the Dart 3.10 `--force-jit` workaround and then completed; `dart format .` completed successfully; `flutter analyze` completed with `No issues found!`; `flutter test` completed with `All tests passed!` (17 tests).
- Open: Emulator checklist: export a backup, clear or reinstall the app, import the backup, and confirm the calorie total and workouts match.
- Decisions needing user input: none.

## 2026-11-12
- Done: Initialized Git on `main`, added ignore rules for build outputs, environment files, and signing artifacts, and pushed the initial commit to the GitHub `main` branch. Added the iOS 13 Podfile, the Codemagic `ios-unsigned` workflow, and exact Codemagic/Sideloadly instructions.
- Verified: Flutter `3.38.9` with Dart `3.10.8` is installed; `ios/Runner.xcodeproj` exists and targets iOS `13.0`; `flutter pub get`, `dart run build_runner build --delete-conflicting-outputs --force-jit`, `flutter analyze`, and `flutter test` completed successfully (17 tests); `codemagic.yaml` parsed successfully and contains the required workflow commands and artifact. Drift generation's `--force-jit` flag is a local Dart 3.10 workaround and must be re-checked after package updates.
- Open: Run the real Codemagic cloud build, download the unsigned IPA, and install it with Sideloadly on the iPhone XR. The bundle identifier currently differs from the requested value: `com.maurik.kainTrack` (not `com.maurik.kain_track`).
- Decisions needing user input: none. The GitHub repository is public by explicit choice; private visibility remains recommended for personal health-data structure.

## 2026-11-18
- Done: Implemented the redesigned Today screen, persistent validated nutrition goals, date selection, grams-based meal logging, categorized food library, custom foods, workouts tab, JSON backups including `category`, and date-specific meal reset. Added schema-v5 migration and seed backfill behavior.
- Verified: Fresh databases contain 26 foods (18 prototype and 8 legacy). The v4-to-v5 migration backfills categories by name and preserves existing nutrition values. The iOS bundle identifier is `com.maurik.kainTrack`; the `ios-unsigned` workflow packages `kain_track-unsigned.ipa`.
- Test suite: 22 tests cover migration behavior, backup round trips, goals persistence, meal/workout repositories, and Today, workout, meal, and food screens.
- Known gaps: Custom foods default to Protein and cannot have category editing in the UI. Legacy foods remain alongside prototype foods. The Progress tab is a placeholder.
