# MIZAN Mobile

Flutter client for MIZAN. See the repository root `README.md` and `/docs` for full product/architecture context.

## Stack
Flutter/Dart, GetX (state management, DI, navigation), Firebase Authentication (real `firebase_auth` integration — see `lib/features/auth/`), local mock data layer (`lib/core/local_store`) standing in for the rest of the backend API until deployed.

## Structure
See `docs/TECHNICAL_ARCHITECTURE.md` §1.

## Firebase setup
This app targets Firebase project `mizan-aeb05`. `lib/firebase_options.dart` has the real project ID wired in but placeholder (empty) API keys/app IDs — see the `TODO(firebase-config)` comments in that file for exactly which Firebase Console values to fill in per platform (Web / Android / iOS). Until real values are set, `Firebase.initializeApp()` still succeeds, but any Firebase Auth call fails with an `invalid-api-key` error.

Only a Web app target is scaffolded in this build (`mobile/web/`) — Android/iOS platform folders aren't generated yet since this environment's device support doesn't include an emulator/simulator to test them against.

## Running
```bash
flutter pub get
flutter run -d chrome                       # or -d web-server if browser launch is sandboxed
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8000  # point at a local backend
```

## Testing
```bash
flutter test
```
