

class PostModel {
  final String title;
  final String body;
 final String id;
  final DateTime? date;
  final List? comments;
final List ?likes;
  final String userID;
  final String fullName;

  PostModel({
    required this.userID,
    required this.fullName,
    required this.body,
    required this.title,
    this.comments,
this.likes  ,
   required this.id,
    this.date,
  }) ;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'date': date,
      'fullname': fullName,
      'userID': userID,
      'likes': likes,
      'comments' : comments,

    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: map['title'],
      body: map['body'],
      date:  DateTime.fromMillisecondsSinceEpoch( map["date"].millisecondsSinceEpoch  ),
      userID: map['userID'] ?? "",
      fullName: map['fullname']?? "",
      likes: map['likes'] ?? [],
    );
  }
}
