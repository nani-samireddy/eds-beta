import 'package:firebase_core/firebase_core.dart' ;
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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBypJVuRsQGtm0fzkH-63hyAeTQTezoqyE',
    appId: '1:1067960690361:android:defa47f91508060be85d68',
    messagingSenderId: '1067960690361',
    projectId: 'endless-store-beta',
    storageBucket: 'endless-store-beta.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCD2UD38Nx_F8w456ZgMWQguEF_K35QxyQ',
    appId: '1:1067960690361:ios:673f23a2af3796c5e85d68',
    messagingSenderId: '1067960690361',
    projectId: 'endless-store-beta',
    storageBucket: 'endless-store-beta.appspot.com',
    iosClientId: '1067960690361-7mnuie8n5lq4sg1ljdobch3714uomgkc.apps.googleusercontent.com',
    iosBundleId: 'com.example.edsBeta',
  );
}
