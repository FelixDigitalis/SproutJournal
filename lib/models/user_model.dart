class UserModel {

  final String uid;
  String email;
  String firstname;
  String lastname;

  UserModel({
    required this.uid,
    this.email = '',
    this.firstname = '',
    this.lastname = '',
  });

  @override
  String toString() {
    return 'User(uid: $uid, email: $email, firstname: $firstname, lastname: $lastname)';
  }

}