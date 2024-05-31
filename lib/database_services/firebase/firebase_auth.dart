import 'package:firebase_auth/firebase_auth.dart';
import '../../utils/log.dart';
import '../../models/user_model.dart';
import 'firebase_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseService fbService = FirebaseService();

  // create custom user obj based on firebase User
  Future<UserModel?> _userFromFirebaseUser(User? fbUser) async {
    if (fbUser != null) {
      fbService.uid = fbUser.uid;
      UserModel? user = await fbService.getUser();
      if (user != null) {
        return user;
      }
    }
    return null;
  }

  // auth change user stream
  Stream<UserModel?> get user {
    return _auth.authStateChanges().asyncMap(_userFromFirebaseUser);
  }

  Future<void> deleteUser(String uid) async {
    try {
      User? user = _auth.currentUser;
      user!.delete();
    } catch (e) {
      Log().e("ERROR: $e");
    }
  }

  // sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      if (user != null) {
        fbService.uid = user.uid;
      }

      return _userFromFirebaseUser(user);
    } catch (e) {
      Log().e(e.toString());
      return null;
    }
  }

  // register with email & password
  Future registerWithEmailAndPassword(
      String email, String password, String firstname, String lastname) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      // add user document in users collection
      if (user != null) {
        fbService.uid = user.uid;
        await fbService.createUser(user.email!, firstname, lastname);
      }

      return _userFromFirebaseUser(user);
    } catch (e) {
      Log().e(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      Log().e(e.toString());
      return null;
    }
  }
}
