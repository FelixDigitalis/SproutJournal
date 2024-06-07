import 'package:flutter/material.dart';
import '../../../models/post_model.dart';
import '../../database_services/firebase/firebase_service.dart';
import '../../../utils/log.dart';

class PostNotifier extends ChangeNotifier {
  List<PostModel> _posts = [];
  bool _isFetching = false;

  List<PostModel> get posts => _posts;
  bool get isFetching => _isFetching;

  Future<void> fetchPosts(String uid) async {
    _isFetching = true;
    notifyListeners();

    try {
      FirebaseService service = FirebaseService(uid: uid);
      _posts = await service.getPostsFromFollowedUsers();
    } catch (e) {
      Log().e('Failed to fetch posts: $e');
    } finally {
      _isFetching = false;
      notifyListeners();
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

  Future<void> deletePost(String uid, String postId) async {
    try {
      FirebaseService service = FirebaseService(uid: uid);
      await service.deletePost(postId);
      await fetchPosts(uid);  // Refresh the posts
    } catch (e) {
      Log().e('Failed to delete post: $e');
    }
  }
}
