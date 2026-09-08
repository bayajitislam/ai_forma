// File generated from native Firebase config files.
// android/app/google-services.json  +  ios/Runner/GoogleService-Info.plist

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBuAk34MeCAOHLdI40QPzD5RqrEd-sBoZE',
    appId: '1:160691479770:android:1f1bc0530b66aff52731e3',
    messagingSenderId: '160691479770',
    projectId: 'ai-forma',
    storageBucket: 'ai-forma.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAYL3lFtjZqgdlsq6Jot7nl2ApQok-2YU0',
    appId: '1:160691479770:ios:dca661af356c989e2731e3',
    messagingSenderId: '160691479770',
    projectId: 'ai-forma',
    storageBucket: 'ai-forma.firebasestorage.app',
    iosBundleId: 'com.aiforma.app',
  );
}
