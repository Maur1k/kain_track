# Kain Track

Kain Track is a personal project for tracking calories and workouts.

## Status
- Implemented and usable on Android and iPhone XR builds.

## Features
- Today screen with selected-date navigation, calorie totals, macro progress, persistent goals, and meal logging.
- Persistent nutrition goals with defaults of 1800 calories, 135g protein, 180g carbohydrates, and 60g fat; saved values are validated.
- Grams-based meal logging from a categorized food library.
- Food library search and category filters for All, High Protein, Filipino, Carbs & Grains, and Fruits & Snacks.
- Custom foods with a default Protein category; custom food nutrition values can be edited, but category editing is not available.
- Workouts tab with workout logging and deletion.
- JSON backup export/import that includes food categories and replaces the local foods, meal entries, and workout sessions atomically.
- Reset the selected date's meal log only; workouts and other dates are preserved.

## Data
- Offline SQLite storage through Drift.
- Current schema version: 5.
- The v4 to v5 migration adds `Foods.category`, backfills categories for prototype foods by name, and does not overwrite existing nutrition values.
- Fresh installs seed 26 foods: 18 prototype foods and 8 legacy foods.
- Legacy foods remain in the library alongside prototype foods.

## Progress
- The redesign is implemented.
- The current test suite contains 22 tests covering migrations, backup round trips, goals persistence, meal/workout repositories, and Today, workout, meal, and food screens.

## Known Gaps
- Custom foods default to the Protein category and cannot have their category edited.
- Legacy foods are kept alongside prototype foods.
- USDA or Open Food Facts datasets are not bundled.
- The Progress tab is a placeholder and does not yet show charts or trends.
