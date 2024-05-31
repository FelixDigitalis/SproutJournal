import 'package:flutter/material.dart';
import 'app.dart';
import 'utils/log.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/firebase/firebase_options.dart';

void main() async {
  Log().i("Main started");
  await dotenv.load(fileName: ".env");
  DefaultFirebaseOptions.setCreds({
    'api_key_android': dotenv.env['API_KEY_ANDROID'],
    'api_key_ios': dotenv.env['API_KEY_IOS'],
    'api_key_web': dotenv.env['API_KEY_WEB'],
    'app_id': dotenv.env['APP_ID'],
    'messaging_sender_id': dotenv.env['MESSAGING_SENDER_ID'],
    'project_id': dotenv.env['PROJECT_ID'],
    'storage_bucket': dotenv.env['STORAGE_BUCKET'],
  });

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.android,
  );
  
  runApp(const App());
}