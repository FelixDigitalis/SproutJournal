import 'package:firebase_auth/firebase_auth.dart';
import '../../utils/log.dart';
import '../../models/user_model.dart';
import 'firebase_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseService? fbService;

  // create custom user obj based on firebase User
  Future<UserModel?> _userFromFirebaseUser(User? fbUser) async {
    if (fbUser != null) {
      FirebaseService fbService = FirebaseService(uid: fbUser.uid);
      UserModel? user = await fbService.getUser();
      return user;
    }
    Log().e("User is null");
    return null;
  }

  // auth change user stream
  Stream<UserModel?> get user {
    return _auth.authStateChanges().asyncMap(_userFromFirebaseUser);
  }

  Future<void> deleteUser() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        fbService = FirebaseService(uid: user.uid);
        await fbService?.deleteUser();
        await user.delete();
      }
    } catch (e) {
      Log().e("ERROR: $e");
    }
  }

  // sign in with email & password
  Future<UserModel?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      if (user != null) {
        fbService = FirebaseService(uid: user.uid);
      }

      return _userFromFirebaseUser(user);
    } catch (e) {
      Log().e(e.toString());
      return null;
    }
  }

  // register with email & password
  Future<UserModel?> registerWithEmailAndPassword(
      String email, String password, String nickname) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      // add user document in users collection
      if (user != null) {
        fbService = FirebaseService(uid: user.uid);
        await fbService?.createUser(user.email!, nickname);
      }
      return await _userFromFirebaseUser(user);
    } catch (e) {
      Log().e("registerWithEmailAndPassword: ${e.toString()}");
      return null;
    }
  }

  // sign out
  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      Log().e(e.toString());
      return;
    }
  }
}
