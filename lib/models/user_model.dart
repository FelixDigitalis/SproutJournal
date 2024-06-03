class UserModel {

  final String uid;
  String email;
  String nickname;

  UserModel({
    required this.uid,
    this.email = '',
    this.nickname = '',
  });

  @override
  String toString() {
    return 'User(uid: $uid, email: $email, nickname: $nickname)';
  }

}