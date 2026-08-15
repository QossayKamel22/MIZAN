import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'app/app.dart';

// NOTE: Firebase initialization (Firebase.initializeApp) is intentionally
// not called here — this build has no provisioned Firebase project
// (docs/DEPLOYMENT_PLAN.md §3, pending). Once `firebase_options.dart` is
// generated via `flutterfire configure` against a real project, add:
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
// before runApp(). This is a clean, documented integration point, not a
// silently-skipped requirement (master prompt §25).

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MizanApp());
}
