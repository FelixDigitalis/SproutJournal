import 'package:flutter/material.dart';
import 'app.dart';
import 'utils/log.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'database_services/firebase/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Log().i("Main started");

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Set Firebase credentials
  DefaultFirebaseOptions.setCreds({
    'api_key_android': dotenv.env['API_KEY'],
    'app_id': dotenv.env['APP_ID'],
    'messaging_sender_id': dotenv.env['MESSAGING_SENDER_ID'],
    'project_id': dotenv.env['PROJECT_ID'],
    'storage_bucket': dotenv.env['STORAGE_BUCKET'],
  });

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.android,
  );

  runApp(const App());
}
