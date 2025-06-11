# MoneyMate Architecture

## Overview

MoneyMate follows a simple layered architecture suitable for a Flutter mobile app.

```
lib/
├── main.dart           # App entry point, theme setup
├── database/           # Data layer - SQLite via sqflite
├── models/             # Data models (Transaction, EMI)
├── screens/            # UI layer - full page widgets
├── services/           # Business logic (PDF, Notifications)
├── theme/              # App-wide theming
└── widgets/            # Reusable UI components
```

## Data Flow

```
Screen → DatabaseHelper → SQLite
Screen → Service (PDF/Notification)
```

## Key Design Decisions

- **Offline-first**: All data stored locally in SQLite, no network required
- **Single database helper**: `DatabaseHelper` is a singleton managing all DB operations
- **Stateful screens**: Screens manage their own state with `setState` for simplicity
- **Theme persistence**: `SharedPreferences` stores dark/light mode preference

## Database

Two tables: `transactions` and `emi`. See README for full schema.

## Notifications

`NotificationService` uses `flutter_local_notifications` to schedule reminders one day before EMI due dates.

## PDF Reports

`PdfService` uses the `pdf` package to generate financial summaries, rendered via the `printing` package.
