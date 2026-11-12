# Tech Stack

All tools are free and open source. The app works fully offline.

## Core
- **Framework:** Flutter (Dart), BSD license
- **Target platforms:** Android (primary dev/test), iOS (via Codemagic + Sideloadly), optionally Windows/Linux desktop later
- **Local database:** SQLite via **Drift** (type-safe Dart wrapper)
- **State management:** **Riverpod** (Provider is an acceptable fallback)

## Packages
- **fl_chart**: calorie trend and workout progress charts
- **flutter_local_notifications**: meal and workout reminders (offline)
- **file_picker** / **share_plus**: JSON or CSV export and import for backups

## Data Sources
- **USDA FoodData Central** (public domain): bundle a trimmed food dataset as a SQLite file in the app assets.
- **Open Food Facts** (ODbL): optional. Requires attribution and share-alike for derived databases. Confirm before use.

## Tooling
- Android Studio + Flutter SDK; verify with `flutter doctor`
- Git + GitHub for version control
- Codemagic (free tier) for cloud iOS builds producing an unsigned `.ipa`
- Sideloadly (or AltStore) to install the `.ipa` on iPhone XR from Windows/Linux

## Constraints
- Target device: iPhone XR, maximum iOS 18. Check all plugin support before adding it.
- No backend, no accounts, no cloud sync in v1. All data stays on device.
- Free Apple ID sideloads expire every 7 days.

## Alternatives Considered
- **Tauri + React + SQLite**: good for desktop-only; rejected because mobile is the priority.
- **Python + SQLite + Streamlit**: good for quick prototypes; rejected for the final product.
