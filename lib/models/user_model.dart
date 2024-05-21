class UserModel {

  final String uid;
  String email;
  String name;

  UserModel({
    required this.uid,
    this.email = '',
    this.name = '',
  });

  @override
  String toString() {
    return 'User(uid: $uid, email: $email, firstname: $name)';
  }

}