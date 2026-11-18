# Tech Stack

All tools are free and open source. The app works fully offline.

## Core
- **Framework:** Flutter (Dart), BSD license
- **Target platforms:** Android (primary dev/test), iOS (via Codemagic + Sideloadly), optionally Windows/Linux desktop later
- **Local database:** SQLite via **Drift** (type-safe Dart wrapper)
- **State management:** **Riverpod**
- **Fonts:** `google_fonts` applies the Inter typeface in the app theme

## Packages
- **drift** / **sqlite3_flutter_libs**: local SQLite persistence
- **shared_preferences**: persistent nutrition goals
- **file_picker** / **share_plus**: JSON backup import and export
- **google_fonts**: Inter text theme
- **path** / **path_provider**: database file location

## Data Sources
- The app uses a local seed library of 26 foods; no external dataset is bundled.
- USDA FoodData Central and Open Food Facts are not currently bundled.

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
