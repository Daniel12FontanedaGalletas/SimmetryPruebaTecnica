import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
        return web;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions para Linux no está soportado en este proyecto.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions no está soportado para la plataforma actual.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCJ44zG3XTcUbuWMwTv38IHUkDIcJp-umU',
    appId: '1:227977661590:web:d1f23cf37a8567c27f86b7',
    messagingSenderId: '227977661590',
    projectId: 'symmetry-reporter-backend',
    authDomain: 'symmetry-reporter-backend.firebaseapp.com',
    storageBucket: 'symmetry-reporter-backend.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCJ44zG3XTcUbuWMwTv38IHUkDIcJp-umU',
    appId: '1:227977661590:android:c581fe95dea8cc4e7f86b7',
    messagingSenderId: '227977661590',
    projectId: 'symmetry-reporter-backend',
    storageBucket: 'symmetry-reporter-backend.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCJ44zG3XTcUbuWMwTv38IHUkDIcJp-umU',
    appId: '1:227977661590:ios:fd9da54acb5c7f4b7f86b7',
    messagingSenderId: '227977661590',
    projectId: 'symmetry-reporter-backend',
    storageBucket: 'symmetry-reporter-backend.appspot.com',
    iosBundleId: 'com.example.newsAppCleanArchitecture',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCJ44zG3XTcUbuWMwTv38IHUkDIcJp-umU',
    appId: '1:227977661590:ios:fd9da54acb5c7f4b7f86b7',
    messagingSenderId: '227977661590',
    projectId: 'symmetry-reporter-backend',
    storageBucket: 'symmetry-reporter-backend.appspot.com',
    iosBundleId: 'com.example.newsAppCleanArchitecture',
  );
}
