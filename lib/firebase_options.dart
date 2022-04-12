// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAGz6yr0SkQI-MjSMiBZKoRd4SIEFhW4QA',
    appId: '1:275250872466:web:893e86a68475dc9db3a64b',
    messagingSenderId: '275250872466',
    projectId: 'e-kodi-202ba',
    authDomain: 'e-kodi-202ba.firebaseapp.com',
    storageBucket: 'e-kodi-202ba.appspot.com',
    measurementId: 'G-07KCRHYHR6',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAUuPwlLvodkNrE6Jh6k7XGbvVLD0FscZU',
    appId: '1:275250872466:android:7ea749b673fc0d53b3a64b',
    messagingSenderId: '275250872466',
    projectId: 'e-kodi-202ba',
    storageBucket: 'e-kodi-202ba.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBeIu4CccBZWo-joZ_Bxa0JijjrdPNJXGE',
    appId: '1:275250872466:ios:506f8abd6dff37eeb3a64b',
    messagingSenderId: '275250872466',
    projectId: 'e-kodi-202ba',
    storageBucket: 'e-kodi-202ba.appspot.com',
    androidClientId: '275250872466-7blo3v6rdup7jjmefbu03quem59g3vmb.apps.googleusercontent.com',
    iosClientId: '275250872466-pgm2pvsgbvr036a0gpfsa841uae040jq.apps.googleusercontent.com',
    iosBundleId: 'com.ekodi.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBeIu4CccBZWo-joZ_Bxa0JijjrdPNJXGE',
    appId: '1:275250872466:ios:506f8abd6dff37eeb3a64b',
    messagingSenderId: '275250872466',
    projectId: 'e-kodi-202ba',
    storageBucket: 'e-kodi-202ba.appspot.com',
    androidClientId: '275250872466-7blo3v6rdup7jjmefbu03quem59g3vmb.apps.googleusercontent.com',
    iosClientId: '275250872466-pgm2pvsgbvr036a0gpfsa841uae040jq.apps.googleusercontent.com',
    iosBundleId: 'com.ekodi.app',
  );
}