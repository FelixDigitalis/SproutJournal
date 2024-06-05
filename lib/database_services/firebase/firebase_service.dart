import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_model.dart';
import '../../utils/log.dart';

class FirebaseService {
  String uid;

  FirebaseService({
    this.uid = '',
  });

  // users collection
  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _postCollection =
      FirebaseFirestore.instance.collection('posts');

  // add new user to user
  Future createUser(String email, String nickname) async {
    if (await isNicknameTaken(nickname)) {
      throw Exception('Nickname is already taken');
    }
    return await _userCollection.doc(uid).set({
      'email': email,
      'nickname': nickname,
      'follows': [],
    });
  }

  // delete user from user
  Future<void> deleteUser() async {
    await _userCollection.doc(uid).delete();
  }

  // get user and convert to user model
  Future<UserModel?> getUser() async {
    try {
      DocumentSnapshot userDocument = await _userCollection.doc(uid).get();
      if (userDocument.exists) {
        UserModel user = UserModel(
          uid: userDocument.id,
          email: userDocument.get('email'),
          nickname: userDocument.get('nickname'),
          followedNicknames: List<String>.from(userDocument.get('follows')),
        );
        return user;
      } else {
        return null;
      }
    } catch (e) {
      Log().e(e.toString());
      return null;
    }
  }

  // check if a user is already registered
  Future<bool> isUserRegistered(String email) async {
    // if user is not registered he is not allowed to read in the user table
    if (uid.isNotEmpty) {
      return false;
    } else {
      final QuerySnapshot result =
          await _userCollection.where('email', isEqualTo: email).limit(1).get();
      return result.docs.isNotEmpty;
    }
  }

  // check if a nickname is already taken
  Future<bool> isNicknameTaken(String nickname) async {
    final QuerySnapshot result = await _userCollection
        .where('nickname', isEqualTo: nickname)
        .limit(1)
        .get();
    return result.docs.isNotEmpty;
  }

  // search nicknames
  Future<List<String>> searchNicknames(String searchString) async {
    final QuerySnapshot result = await _userCollection
        .where('nickname', isGreaterThanOrEqualTo: searchString)
        .where('nickname', isLessThanOrEqualTo: '$searchString\uf8ff')
        .get();

    List<String> nicknames = [];
    for (var doc in result.docs) {
      nicknames.add(doc.get('nickname'));
    }
    return nicknames;
  }

  // follow a user by nickname
  Future<void> followUser(String nicknameToFollow) async {
    try {
      final QuerySnapshot result = await _userCollection
          .where('nickname', isEqualTo: nicknameToFollow)
          .limit(1)
          .get();
      if (result.docs.isEmpty) {
        throw Exception('User with nickname $nicknameToFollow does not exist');
      }
      DocumentReference currentUserDoc = _userCollection.doc(uid);

      await currentUserDoc.update({
        'follows': FieldValue.arrayUnion([nicknameToFollow])
      });
    } catch (e) {
      Log().e(e.toString());
      throw Exception('Failed to follow user: $e');
    }
  }

  // unfollow a user by nickname
  Future<void> unfollowUser(String nicknameToUnfollow) async {
    try {
      final QuerySnapshot result = await _userCollection
          .where('nickname', isEqualTo: nicknameToUnfollow)
          .limit(1)
          .get();

      if (result.docs.isEmpty) {
        throw Exception(
            'User with nickname $nicknameToUnfollow does not exist');
      }

      DocumentReference currentUserDoc = _userCollection.doc(uid);

      await currentUserDoc.update({
        'follows': FieldValue.arrayRemove([nicknameToUnfollow])
      });
    } catch (e) {
      Log().e(e.toString());
      throw Exception('Failed to unfollow user: $e');
    }
  }

  // add a new post
  Future<void> addPost(String content) async {
    try {
      await _postCollection.add({
        'uid': uid,
        'content': content,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      Log().e(e.toString());
      throw Exception('Failed to add post: $e');
    }
  }

  // delete a post by post ID
  Future<void> deletePost(String postId) async {
    try {
      DocumentSnapshot postSnapshot = await _postCollection.doc(postId).get();
      if (postSnapshot.exists && postSnapshot.get('uid') == uid) {
        await _postCollection.doc(postId).delete();
      } else {
        throw Exception('Post does not exist or you do not have permission to delete it');
      }
    } catch (e) {
      Log().e(e.toString());
      throw Exception('Failed to delete post: $e');
    }
  }
}

