class User {
  int? id;
  String? email;
  String? username;
  String? avatarUrl;
  int? postNum;
  int? likedNum;

  User(
      {this.id,
        this.email,
        this.username,
        this.avatarUrl,
        this.postNum,
      this.likedNum});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    username = json['username'];
    avatarUrl = json['avatarUrl'];
    postNum = json['postNum'];
    likedNum = json['likedNum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['username'] = username;
    data['avatarUrl'] = avatarUrl;
    data['postNum'] = postNum;
    data['likedNum'] = likedNum;
    return data;
  }

  @override
  String toString() {
    return 'User{id: $id, email: $email, username: $username, avatarUrl: $avatarUrl, postNum: $postNum,,likedNum: $likedNum';
  }

}