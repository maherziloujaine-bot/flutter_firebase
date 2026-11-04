// File: lib/firebase_options.dart
import 'package:firebase_core/firebase_core.dart';
/*
Remplacer les valeurs par celles de ton google-services.json :
current_key → apiKey
mobilesdk_app_id → appId
project_id → projectId
storage_bucket → storageBucket
project_number → messagingSenderId*/

 class DefaultFirebaseOptions {
     static const FirebaseOptions currentPlatform = FirebaseOptions(
       apiKey: 'AIzaSyDEtQyJ1Bv71l5cnEra4LEw-a7XTGycrzQ',
       appId: '1:243284139114:android:dd30b52eb5483dd0dd3e13',
       messagingSenderId: '',
       projectId: 'flutter-firebase-4548a',
       storageBucket: 'flutter-firebase-4548a.firebasestorage.app',
     );
   }