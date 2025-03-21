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
    apiKey: 'AIzaSyCXtUZX54vdIQxLMshJ4kIFHt966z4P3CA',
    appId: '1:788404651902:web:be0b9bd91470541eb2152f',
    messagingSenderId: '788404651902',
    projectId: 'chatcupid-87b76',
    authDomain: 'chatcupid-87b76.firebaseapp.com',
    storageBucket: 'chatcupid-87b76.appspot.com',
    measurementId: 'G-6NVLZH2HS2',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDas_1cyssbAeuGK6u7HxgOPcgxl6TNjMY',
    appId: '1:788404651902:android:8fb94af388b9fe47b2152f',
    messagingSenderId: '788404651902',
    projectId: 'chatcupid-87b76',
    storageBucket: 'chatcupid-87b76.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDlGg39jqFCWtGJ24S8R567KNr32kXmhMI',
    appId: '1:788404651902:ios:1f3fa1a7897205b6b2152f',
    messagingSenderId: '788404651902',
    projectId: 'chatcupid-87b76',
    storageBucket: 'chatcupid-87b76.appspot.com',
    androidClientId: '788404651902-5pl48h8afeco1itna73jja9mk6s2ov3c.apps.googleusercontent.com',
    iosClientId: '788404651902-h26c6h19pleesjd4tm0u5uq0muc35f0c.apps.googleusercontent.com',
    iosBundleId: 'com.app.chatcupid',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDlGg39jqFCWtGJ24S8R567KNr32kXmhMI',
    appId: '1:788404651902:ios:cf82b6ef7ab3d973b2152f',
    messagingSenderId: '788404651902',
    projectId: 'chatcupid-87b76',
    storageBucket: 'chatcupid-87b76.appspot.com',
    iosBundleId: 'com.example.chatcupid',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCXtUZX54vdIQxLMshJ4kIFHt966z4P3CA',
    appId: '1:788404651902:web:1cde314db9fd248db2152f',
    messagingSenderId: '788404651902',
    projectId: 'chatcupid-87b76',
    authDomain: 'chatcupid-87b76.firebaseapp.com',
    storageBucket: 'chatcupid-87b76.appspot.com',
    measurementId: 'G-BHTBZGTBMS',
  );
}