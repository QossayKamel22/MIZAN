// File generated from Firebase project `mizan-aeb05` configuration.
//
// PENDING: the actual project values below are placeholders. Real values
// come from Firebase Console → Project Settings → General → Your apps
// (or from running `flutterfire configure` against project `mizan-aeb05`).
// See docs/FINAL_TECHNICAL_REPORT.md for exactly what's needed and why.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  DefaultFirebaseOptions._();

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not configured for this platform yet — '
          'only web is wired up in this build (no Android/iOS SDK config '
          'available in this environment). See docs/FINAL_TECHNICAL_REPORT.md.',
        );
    }
  }

  // TODO(firebase-config): replace with the real Web app config from
  // Firebase Console → Project Settings → General → Your apps → Web app
  // for project `mizan-aeb05`. If no Web app is registered yet, add one
  // there first (the "</>" icon).
  static const web = FirebaseOptions(
    apiKey: '',
    appId: '',
    messagingSenderId: '',
    projectId: 'mizan-aeb05',
    authDomain: 'mizan-aeb05.firebaseapp.com',
    storageBucket: 'mizan-aeb05.firebasestorage.app',
  );

  // TODO(firebase-config): replace with google-services.json values for
  // project `mizan-aeb05` (Project Settings → Your apps → Android).
  static const android = FirebaseOptions(
    apiKey: '',
    appId: '',
    messagingSenderId: '',
    projectId: 'mizan-aeb05',
    storageBucket: 'mizan-aeb05.firebasestorage.app',
  );

  // TODO(firebase-config): replace with GoogleService-Info.plist values for
  // project `mizan-aeb05` (Project Settings → Your apps → iOS).
  static const ios = FirebaseOptions(
    apiKey: '',
    appId: '',
    messagingSenderId: '',
    projectId: 'mizan-aeb05',
    storageBucket: 'mizan-aeb05.firebasestorage.app',
    iosBundleId: 'com.mizan.app',
  );
}
