import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static late Map<String, dynamic> creds;

  static late String androidKey;
  static late String appId;
  static late String messagingSenderId;
  static late String projectId;
  static late String storageBucket;

  static void setCreds(Map<String, dynamic> newCreds) {
    creds = newCreds;
    androidKey = creds['api_key_android'];
    appId = creds['app_id'];
    messagingSenderId = creds['messaging_sender_id'];
    projectId = creds['project_id'];
    storageBucket = creds['storage_bucket'];
  }

  static FirebaseOptions get android => FirebaseOptions(
    apiKey: androidKey,
    appId: appId,
    messagingSenderId: messagingSenderId,
    projectId: projectId,
    storageBucket: storageBucket,
  );
}
