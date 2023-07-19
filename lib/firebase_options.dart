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
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA6gDYlrJzVTwLtJkCRbH_Akhqd_X-n3FA',
    appId: '1:633362482784:web:5b4482f4d1e0c659222505',
    messagingSenderId: '633362482784',
    projectId: 'financetracker-f961e',
    authDomain: 'financetracker-f961e.firebaseapp.com',
    storageBucket: 'financetracker-f961e.appspot.com',
    measurementId: 'G-DSCDT453G7',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBBoj3gLYhYA9XAXZD8dhJPmBZxUEhpifg',
    appId: '1:633362482784:android:ccc3cf38050c8006222505',
    messagingSenderId: '633362482784',
    projectId: 'financetracker-f961e',
    storageBucket: 'financetracker-f961e.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDHFTrhv2uUyWbT56g7tFg8XGNw3du-zZ4',
    appId: '1:633362482784:ios:e2fac72e3a4f2b6d222505',
    messagingSenderId: '633362482784',
    projectId: 'financetracker-f961e',
    storageBucket: 'financetracker-f961e.appspot.com',
    iosClientId: '633362482784-vtn99sq13nfv08cl7c5i25sombch2u00.apps.googleusercontent.com',
    iosBundleId: 'com.example.financeTracker',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDHFTrhv2uUyWbT56g7tFg8XGNw3du-zZ4',
    appId: '1:633362482784:ios:8496604c3c4635b8222505',
    messagingSenderId: '633362482784',
    projectId: 'financetracker-f961e',
    storageBucket: 'financetracker-f961e.appspot.com',
    iosClientId: '633362482784-p8d1k5kq3tn8j1ucenov221p7vq6sj2t.apps.googleusercontent.com',
    iosBundleId: 'com.example.financeTracker.RunnerTests',
  );
}