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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyATuIZMr4Y4GXQdhBPW-AxOUVKakc2vOnA',
    appId: '1:414860857847:web:e1f0c383193bb56c7e1ef2',
    messagingSenderId: '414860857847',
    projectId: 'exam-bba94',
    authDomain: 'exam-bba94.firebaseapp.com',
    storageBucket: 'exam-bba94.appspot.com',
    measurementId: 'G-R891YN5E01',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDYMdv8UIVshaP5MRhBgQMtqP2omr7qBHM',
    appId: '1:414860857847:android:81cec9f19020a73c7e1ef2',
    messagingSenderId: '414860857847',
    projectId: 'exam-bba94',
    storageBucket: 'exam-bba94.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCw4RLhpTpbDhURLVJ05tg088g28-6kD2M',
    appId: '1:414860857847:ios:37bc17e047f5ed607e1ef2',
    messagingSenderId: '414860857847',
    projectId: 'exam-bba94',
    storageBucket: 'exam-bba94.appspot.com',
    iosBundleId: 'com.example.examSchedule',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyATuIZMr4Y4GXQdhBPW-AxOUVKakc2vOnA',
    appId: '1:414860857847:web:91c33e77486ef7987e1ef2',
    messagingSenderId: '414860857847',
    projectId: 'exam-bba94',
    authDomain: 'exam-bba94.firebaseapp.com',
    storageBucket: 'exam-bba94.appspot.com',
    measurementId: 'G-P35F2C7F2L',
  );
}
