
class Post {
  int? id;
  int? userId;
  String? text;
  String? imageUrl;
  String? date;
  String? name;
  String? icon;
  int? likeNum;
  int? commentNum;
  bool? isLiked;

  Post(
      {this.id,
        this.userId,
        this.date,
        this.text,
        this.imageUrl,
        this.name,
        this.icon,
        this.likeNum,
        this.commentNum,
        this.isLiked,
      });

  Post.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    date = json['date'];
    text = json['text'];
    imageUrl = json['imageUrl'];
    name = json['name'];
    icon = json['icon'];
    likeNum = json['likeNum'];
    commentNum = json['commentNum'];
    isLiked = json['isLiked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['date'] = date;
    data['text'] = text;
    data['imageUrl'] = imageUrl;
    data['name'] = name;
    data['icon'] = icon;
    data['likeNum'] = likeNum;
    data['commentNum'] = commentNum;
    data['isLiked'] = isLiked;
    return data;
  }

  @override
  String toString() {
    return 'Post{id: $id, userId: $userId, date: $date, text: $text, imageUrl: $imageUrl, name: $name,icon: $icon likeNum: $likeNum, commentNum: $commentNum, isLiked: $isLiked,}';
  }

}