class History {
  int? id;
  int? userId;
  String? name;
  String? type;
  int? accuracy;
  String? imageUrl;
  int? tag;
  String? date;

  History(
      {this.id,
      this.userId,
      this.name,
      this.type,
      this.accuracy,
      this.imageUrl,
      this.tag,
      this.date});

  History.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    name = json['name'];
    type = json['type'];
    accuracy = json['accuracy'];
    imageUrl = json['imageUrl'];
    tag = json['tag'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['name'] = name;
    data['type'] = type;
    data['accuracy'] = accuracy;
    data['imageUrl'] = imageUrl;
    data['tag'] = tag;
    data['date'] = date;
    return data;
  }

  @override
  String toString() {
    return 'History{id: $id, userId: $userId, name: $name, type: $type, accuracy: $accuracy,imageUrl: $imageUrl,tag: $tag,date: $date';
  }
}
