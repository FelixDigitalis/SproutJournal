import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting

class PostModel {
  final String id;
  final String content;
  final String authorName;
  final String timestamp;

  PostModel({
    required this.id,
    required this.content,
    required this.authorName,
    required this.timestamp,
  });

  factory PostModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    Timestamp firestoreTimestamp = data['timestamp'] as Timestamp;
    DateTime dateTime = firestoreTimestamp.toDate();
    String formattedTimestamp = DateFormat('dd.MM.yy \'um\' HH:mm').format(dateTime.toLocal());

    return PostModel(
      id: doc.id,
      content: data['content'] ?? '',
      authorName: data['nickname'] ?? '',
      timestamp: formattedTimestamp,
    );
  }
}
