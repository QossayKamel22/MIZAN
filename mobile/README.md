# MIZAN Mobile

Flutter client for MIZAN. See the repository root `README.md` and `/docs` for full product/architecture context.

## Stack
Flutter/Dart, GetX (state management, DI, navigation), Firebase (Auth/FCM/Firestore — pending live project), local mock data layer (`lib/core/local_store`) standing in for the backend API until deployed.

## Structure
See `docs/TECHNICAL_ARCHITECTURE.md` §1.

## Running
Requires the Flutter SDK (not available in the authoring environment — see root `docs/FINAL_TECHNICAL_REPORT.md`).

```bash
flutter pub get
flutter run
```

## Testing
```bash
flutter test
```
