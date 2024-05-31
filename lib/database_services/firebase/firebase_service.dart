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

  // add new user to user
  Future createUser(String email, String firstname, String lastname) async {
    return await _userCollection.doc(uid).set({
      'email': email,
      'firstname': firstname,
      'lastname': lastname,
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
          firstname: userDocument.get('firstname'),
          lastname: userDocument.get('lastname'),
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
}
