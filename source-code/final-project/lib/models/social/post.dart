class Post {
  late final int userId;
  late final int? id;
  late final String title;
  late final String body;

  Post({
    required this.userId,
    this.id,
    required this.title,
    required this.body,
  });
  
  
  Post.fromJson(Map<String, dynamic> json){
    userId = json['userId'];
    id = json['id'];
    title = json['title'];
    body = json['body'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['userId'] = userId;
    data['id'] = id;
    data['title'] = title;
    data['body'] = body;
    return data;
  }
}