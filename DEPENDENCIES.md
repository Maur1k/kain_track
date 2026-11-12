# Dependencies

| Package | Version | License | Purpose | iOS 18 notes |
|---|---|---|---|---|
| flutter_riverpod | ^2.5.1 | MIT | State management | Pure Dart, no native code |
| flutter_lints | ^4.0.0 (dev) | BSD-3 | Lint rules | Dev only |
| drift | 2.30.0 | MIT | Type-safe local SQLite database | Supports Android and iOS |
| path | ^1.9.1 | BSD-3 | Cross-platform database path joining | Pure Dart |
| path_provider | ^2.1.6 | BSD-3 | Resolves the app documents directory for SQLite | Supports Android and iOS |
| sqlite3_flutter_libs | ^0.5.24 | MIT | Bundles SQLite native libraries for Flutter | Supports Android and iOS |
| file_picker | ^13.3.3 | MIT | Select JSON files for backup import | Supports Android and iOS 18 through platform implementations |
| share_plus | ^13.3.1 | BSD-3-Clause | Share exported JSON backup files | Supports Android and iOS 18 through platform implementations |
| drift_dev | 2.30.0 (dev) | MIT | Drift code generation | Dev only; generated code targets Android and iOS |
| build_runner | 2.15.1 (dev) | BSD-3-Clause | Runs Drift code generation | Dev only |

Planned (add when implemented, verify license and iOS support first):
- drift, drift_flutter, sqlite3_flutter_libs, path_provider, path (database)
- drift_dev, build_runner (dev, code generation)
- fl_chart (charts)
- flutter_local_notifications (reminders)
