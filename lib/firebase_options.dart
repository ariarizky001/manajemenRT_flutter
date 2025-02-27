// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyDvC9ebRiSqaVk6S8HuRbK25R5pobPaoHI',
    appId: '1:54913423109:web:3a781eae60c51b49c4c96c',
    messagingSenderId: '54913423109',
    projectId: 'aplikasiku-2d67e',
    authDomain: 'aplikasiku-2d67e.firebaseapp.com',
    databaseURL: 'https://aplikasiku-2d67e-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'aplikasiku-2d67e.firebasestorage.app',
    measurementId: 'G-563WDQRBST',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCE0jsAYFdLaaIVxFZFhEG8W1ixZae7L80',
    appId: '1:54913423109:android:068fb895b1767b6bc4c96c',
    messagingSenderId: '54913423109',
    projectId: 'aplikasiku-2d67e',
    databaseURL: 'https://aplikasiku-2d67e-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'aplikasiku-2d67e.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDlloQBYhCdcHjkVYHfpas_N1ULkgy_DYw',
    appId: '1:54913423109:ios:3dd9fc8a8f8d5914c4c96c',
    messagingSenderId: '54913423109',
    projectId: 'aplikasiku-2d67e',
    databaseURL: 'https://aplikasiku-2d67e-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'aplikasiku-2d67e.firebasestorage.app',
    iosBundleId: 'com.example.aplikasiku',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDlloQBYhCdcHjkVYHfpas_N1ULkgy_DYw',
    appId: '1:54913423109:ios:3dd9fc8a8f8d5914c4c96c',
    messagingSenderId: '54913423109',
    projectId: 'aplikasiku-2d67e',
    databaseURL: 'https://aplikasiku-2d67e-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'aplikasiku-2d67e.firebasestorage.app',
    iosBundleId: 'com.example.aplikasiku',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDvC9ebRiSqaVk6S8HuRbK25R5pobPaoHI',
    appId: '1:54913423109:web:f0a792d1e651ccadc4c96c',
    messagingSenderId: '54913423109',
    projectId: 'aplikasiku-2d67e',
    authDomain: 'aplikasiku-2d67e.firebaseapp.com',
    databaseURL: 'https://aplikasiku-2d67e-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'aplikasiku-2d67e.firebasestorage.app',
    measurementId: 'G-DN83MR8L0M',
  );
}
