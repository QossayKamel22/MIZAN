import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'app/app.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    // Expected until real Firebase project values are set in
    // firebase_options.dart (see its TODO(firebase-config) comments) — the
    // app still renders so it can be reviewed; auth calls will fail until
    // real config is in place (docs/FINAL_TECHNICAL_REPORT.md §4).
    debugPrint('Firebase.initializeApp failed — auth will not work until '
        'firebase_options.dart has real project values: $e');
  }
  await GetStorage.init();
  runApp(const MizanApp());
}
