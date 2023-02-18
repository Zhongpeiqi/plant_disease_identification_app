class User {
  int? userId;
  String? email;
  String? username;
  String? avatarUrl;
  String? backImgUrl;
  int? postNum;

  User(
      {this.userId,
        this.email,
        this.username,
        this.avatarUrl,
        this.backImgUrl,
        this.postNum,});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    email = json['email'];
    username = json['username'];
    avatarUrl = json['avatarUrl'];
    backImgUrl = json['backImgUrl'];
    postNum = json['postNum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['email'] = email;
    data['username'] = username;
    data['avatarUrl'] = avatarUrl;
    data['backImgUrl'] = backImgUrl;
    data['postNum'] = postNum;
    return data;
  }

  @override
  String toString() {
    return 'User{userId: $userId, email: $email, username: $username, avatarUrl: $avatarUrl, backImgUrl: $backImgUrl, postNum: $postNum}';
  }

}