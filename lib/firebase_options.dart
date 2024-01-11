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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBYWv3Gu03a32oLYKz0sYen2N3P-rZzjTQ',
    appId: '1:760700497317:web:d0b67534a2e52d38198c4c',
    messagingSenderId: '760700497317',
    projectId: 'fir-connect-fb93c',
    authDomain: 'fir-connect-fb93c.firebaseapp.com',
    databaseURL: 'https://fir-connect-fb93c-default-rtdb.firebaseio.com',
    storageBucket: 'fir-connect-fb93c.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCttPFY1_lEitGSqIMQk9k1T6U5hxFlXdk',
    appId: '1:760700497317:android:1db0b2dca3ae1c36198c4c',
    messagingSenderId: '760700497317',
    projectId: 'fir-connect-fb93c',
    databaseURL: 'https://fir-connect-fb93c-default-rtdb.firebaseio.com',
    storageBucket: 'fir-connect-fb93c.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCz8I96yvhdrEO6Bn4ayVi936SX2BfEvAQ',
    appId: '1:760700497317:ios:a660dbb0a57e49c2198c4c',
    messagingSenderId: '760700497317',
    projectId: 'fir-connect-fb93c',
    databaseURL: 'https://fir-connect-fb93c-default-rtdb.firebaseio.com',
    storageBucket: 'fir-connect-fb93c.appspot.com',
    iosBundleId: 'com.example.house',
  );
}
