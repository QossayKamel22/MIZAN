// File generated from Firebase project `mizan-aeb05` configuration.
//
// Web app `mizan-web` (App ID 1:553571091996:web:576a4db21bc8300935c1d9,
// project number 553571091996) is real and filled in below. `apiKey` is
// still a placeholder — see the TODO(firebase-config) comment on `web`.
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

  // TODO(firebase-config): apiKey still needed — Firebase Console →
  // Project Settings → General → Your apps → mizan-web → SDK setup and
  // configuration → Config → copy the `apiKey` value.
  static const web = FirebaseOptions(
    apiKey: '',
    appId: '1:553571091996:web:576a4db21bc8300935c1d9',
    messagingSenderId: '553571091996',
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
