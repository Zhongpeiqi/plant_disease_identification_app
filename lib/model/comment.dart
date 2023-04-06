class Comment {
  int? id;
  int? userId;
  int? postId;
  String? text;
  String? imageUrl;
  String? date;
  String? icon;
  String? name;
  bool? isLiked;
  int? likeNum;
  int? replyNum;
  // List<Reply>? replyList;

  Comment(
      {this.id,
        this.userId,
        this.icon,
        this.name,
        this.date,
        this.text,
        this.imageUrl,
        this.isLiked,
        this.likeNum,
        this.replyNum,
        });

  Comment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    postId = json['postId'];
    icon = json['icon'];
    name = json['name'];
    date = json['date'];
    text = json['text'];
    imageUrl = json['imageUrl'];
    // isLiked = json['isLiked'];
    // likeNum = json['likeNum'];
    // replyNum = json['replyNum'];
    // if (json['replyList'] != null) {
    //   replyList = <Reply>[];
    //   json['replyList'].forEach((v) {
    //     replyList?.add(Reply.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['postId'] = postId;
    data['icon'] = icon;
    data['name'] = name;
    data['date'] = date;
    data['text'] = text;
    data['imageUrl'] = imageUrl;
    // data['isLiked'] = isLiked;
    // data['likeNum'] = likeNum;
    // data['replyNum'] = replyNum;
    // if (replyList != null) {
    //   data['replyList'] = replyList?.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}