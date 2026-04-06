# Worthra

Worthra is a Flutter-based personal finance companion focused on clean UX, offline-first data handling, and production-style mobile architecture. The app helps users track transactions, monitor balance trends, manage savings goals and streak challenges, review insights, protect the app with biometrics, and receive daily reminder notifications.

This repository was built from HTML/CSS design blueprints and translated into a native Flutter mobile experience with a feature-first structure, shared theming, local persistence, and test coverage.

## Overview

Worthra is designed around four core product goals:

- make daily money tracking fast and clear
- keep essential finance data available offline
- provide visually polished dashboards, goals, and insights
- use maintainable architecture that is easy to review and extend

## Key Features

### User-facing features

- Dashboard with current balance, income, expense, and recent activity
- Transaction history with scrollable lists, filtering support, and add/delete flows
- Add Transaction modal sheet with category, amount, notes, and date inputs
- Savings goals and streak challenges with circular progress UI
- Insights screen with category breakdowns and interactive donut visualization
- Settings screen for theme, language, currency, notifications, biometrics, and exports
- Branded splash screen
- Light and dark theme support
- Daily reminder notifications
- Biometric app lock
- Local data export for transactions and insights
- English and Spanish localization support

### Technical features

- Offline-first local database using Isar
- Riverpod-based state management and dependency injection
- Repository layer between UI and persistence
- Feature-first UI organization
- Shared theming and reusable core widgets
- Golden tests, widget tests, repository tests, and provider tests
- Auth token storage and backend client foundation
- Sync queue and sync service foundation for future online sync expansion

## Architecture

The app follows a layered architecture with a feature-first UI structure.

### Data flow

1. UI widgets read state from Riverpod providers.
2. Providers/controllers call repositories.
3. Repositories read and write Isar collections.
4. Shared services handle notifications, biometrics, auth, and sync orchestration.

This keeps the UI independent from direct database access and makes the app easier to test and extend.

### Project structure

```text
lib/
|-- core/
|   |-- constants/         # shared colors, typography
|   |-- network/           # API client, token storage, connectivity helpers
|   |-- services/          # notifications, local auth, sync
|   |-- theme/             # app themes, palette, theme extensions
|   |-- utils/             # localization and formatting helpers
|   `-- widgets/           # shared scaffold, nav, buttons, app lock gate
|-- features/
|   |-- auth/
|   |-- dashboard/
|   |-- goals/
|   |-- insights/
|   |-- settings/
|   |-- splash/
|   `-- transactions/
|-- l10n/                  # ARB files and generated localization classes
|-- models/                # Isar collections
|-- repositories/          # data access layer
|-- state/                 # Riverpod providers and controllers
`-- main.dart              # app entry point
```

### Important directories outside `lib/`

```text
assets/                    # logos, icons, branding assets
stitch_add_transaction/    # source HTML/CSS blueprints and mockups
test/                      # widget, golden, repository, and provider tests
android/ ios/ web/         # platform runners and app config
```

## Core Modules

### Dashboard

- shows current balance, monthly income, monthly expense
- highlights recent transactions
- acts as the home surface for the app

### Transactions

- stores expense and income entries locally
- supports category-based organization
- powers dashboard totals and insights

### Goals

- supports savings goals and streak-style challenges
- uses progress-based visuals for motivation and quick review

### Insights

- aggregates category spending
- displays spending distribution and summary metrics

### Settings

- handles theme, currency, language, notifications, biometric lock, exports, and local profile preferences

## Tech Stack

- Flutter
- Dart
- Riverpod
- Isar Community
- Google Fonts
- Flutter Local Notifications
- Timezone / Flutter Timezone
- Local Auth
- Flutter Secure Storage
- Connectivity Plus
- HTTP

## Local Database Model

The app persists data locally with Isar collections.

### Main collections

- `Transaction`
  - amount
  - expense or income type
  - category
  - date
  - optional notes
- `Goal`
  - title
  - target amount
  - current amount
  - savings goal or streak challenge flag
- `AppSettings`
  - theme mode
  - language
  - currency
  - biometric lock setting
  - daily reminder time
  - seed/bootstrap flags
- `SyncOperation`
  - queued sync work for future online sync flows

## Current Implementation Status

### Fully implemented in the current app

- local persistence for transactions, goals, and settings
- live dashboard calculations
- category insights aggregation
- add/delete transaction flows
- goal and streak progress handling
- daily reminder scheduling
- biometric lock flow
- export utilities
- light/dark theme switching
- localization wiring

### Foundation prepared for future expansion

- token-based auth client
- secure token storage
- sync queue repository
- sync orchestration service

These foundation pieces are present in the codebase, but the app should still be described primarily as an offline-first local finance app rather than a fully cloud-synced finance platform.

## Design Notes

The visual system is based on the provided HTML/CSS mockups stored in `stitch_add_transaction/`. Those blueprints were translated into Flutter widgets while preserving:

- structural hierarchy
- spacing and padding rhythm
- visual grouping of dashboard cards and lists
- light and dark theme direction
- goals and insights visual treatment

The app also includes branded assets in `assets/` for the launcher and splash experience.

## Setup

### Prerequisites

- Flutter SDK installed
- Dart SDK available through Flutter
- Android Studio or VS Code with Flutter tooling
- An emulator or physical device for testing

This repository was verified in the current workspace with:

- Flutter `3.43.0-0.3.pre`
- Dart `3.11.0`

### Install dependencies

```bash
flutter pub get
```

### Generate localization files

```bash
flutter gen-l10n
```

### Generate Isar files after model changes

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Run the app

```bash
flutter run
```

## Testing and Quality Checks

### Static analysis

```bash
flutter analyze
```

### Run tests

```bash
flutter test -j 1
```

### Golden update workflow

Use this only when an intentional UI change requires new golden baselines:

```bash
flutter test --update-goldens -j 1
```

### Test coverage included in the repo

- widget smoke test
- golden tests for shared components and finance cards
- repository tests for local persistence behavior
- provider/state tests for bootstrap and settings flows

## Build Instructions

### Release APK

```bash
flutter build apk --release
```

### Android App Bundle

```bash
flutter build appbundle
```

## Platform-Specific Notes

### Notifications

- Android reminder notifications require notification permission
- some Android versions may also require exact alarm permission
- reminders are timezone-aware

### Biometrics

- biometric lock depends on supported device hardware and enrolled biometrics
- the app authenticates before enabling the biometric lock setting

## Assessor Notes

If you are reviewing this project, the strongest areas to inspect are:

- architecture separation between UI, providers, repositories, and models
- offline-first local persistence with Isar
- provider-driven UI refresh patterns with Riverpod
- theme consistency across light and dark mode
- feature completeness across dashboard, transactions, goals, insights, and settings
- local notification and biometric integration
- test structure and quality gates

### Recommended review path

1. Start at `lib/main.dart` for app bootstrapping and routing.
2. Review `lib/state/` for Riverpod providers and controllers.
3. Review `lib/repositories/` and `lib/models/` for data architecture.
4. Review `lib/features/` for screen-level implementation.
5. Review `test/` for automated verification coverage.

## Suggested Future Enhancements

- complete production-grade cloud sync conflict handling
- wire backend authentication to a live server environment
- add integration tests for end-to-end device flows
- add onboarding and analytics
- extend export/share capabilities
- add recurring transactions and budget planning

## Repository Notes

- `stitch_add_transaction/` contains the original design blueprint sources used to guide the Flutter implementation
- generated files such as Isar `.g.dart` files and localization outputs are included where needed for buildability
- build outputs are intentionally ignored from version control

## License

This project is currently maintained as a private/internal assessment-style application. Add a formal license here if the repository is intended for public distribution.
