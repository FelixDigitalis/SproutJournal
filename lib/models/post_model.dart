import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String id;
  final String content;
  final String authorName;

  PostModel({
    required this.id,
    required this.content,
    required this.authorName,
  });

  factory PostModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PostModel(
      id: doc.id,
      content: data['content'] ?? '',
      authorName: data['authorName'] ?? '',
    );
  }
}
