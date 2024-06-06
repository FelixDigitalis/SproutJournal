import 'package:flutter/material.dart';
import '../../../models/post_model.dart';
import '../../database_services/firebase/firebase_service.dart';
import '../../../utils/log.dart';

class PostNotifier extends ChangeNotifier {
  List<PostModel> _posts = [];

  List<PostModel> get posts => _posts;

  Future<void> fetchPosts(String uid) async {
    try {
      FirebaseService service = FirebaseService(uid: uid);
      _posts = await service.getPostsFromFollowedUsers();
      notifyListeners();
    } catch (e) {
      Log().e('Failed to fetch posts: $e');
    }
  }

  Future<void> addPost(String uid, String content) async {
    try {
      FirebaseService service = FirebaseService(uid: uid);
      await service.addPost(content);
      await fetchPosts(uid);  // Refresh the posts
    } catch (e) {
      Log().e('Failed to add post: $e');
    }
  }
}
