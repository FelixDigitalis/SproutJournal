class UserModel {
  final String uid;
  String email;
  String nickname;
  List<String> followedNicknames;

  UserModel({
    required this.uid,
    required this.email,
    required this.nickname,
    required this.followedNicknames,
  });

  UserModel copyWith({
    String? uid,
    String? email,
    String? nickname,
    List<String>? followedNicknames,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      nickname: nickname ?? this.nickname,
      followedNicknames: followedNicknames ?? List.from(this.followedNicknames),
    );
  }

  @override
  String toString() {
    return 'User(uid: $uid, email: $email, nickname: $nickname, followedNicknames: $followedNicknames)';
  }
}
