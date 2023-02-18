
class Post {
  int? postId;
  int? userId;
  String? date;
  String? text;
  String? imageUrl;
  int? likeNum;
  int? commentNum;
  bool? isLiked;

  Post(
      {this.postId,
        this.userId,
        this.date,
        this.text,
        this.imageUrl,
        this.likeNum,
        this.commentNum,
        this.isLiked,});

  Post.fromJson(Map<String, dynamic> json) {
    postId = json['postId'];
    userId = json['userId'];
    date = json['date'];
    text = json['text'];
    imageUrl = json['imageUrl'];
    likeNum = json['likeNum'];
    commentNum = json['commentNum'];
    isLiked = json['isLiked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['postId'] = postId;
    data['userId'] = userId;
    data['date'] = date;
    data['text'] = text;
    data['imageUrl'] = imageUrl;
    data['likeNum'] = likeNum;
    data['commentNum'] = commentNum;
    data['isLiked'] = isLiked;
    return data;
  }

  @override
  String toString() {
    return 'Post{postId: $postId, userId: $userId, date: $date, text: $text, imageUrl: $imageUrl,  likeNum: $likeNum, commentNum: $commentNum, isLiked: $isLiked,}';
  }

}