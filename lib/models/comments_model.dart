import 'package:cloud_firestore/cloud_firestore.dart';

class CommentsModel {
  final String? id;
  final String userID;
  final String fullname;
  final String commentBody;
  final List? comments;
  final String postId;
  final Timestamp? timestamp;

  const CommentsModel(
      {required this.fullname,
      required this.postId,
      required this.userID,
      this.id,
      this.timestamp,
      this.comments,
      required this.commentBody});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullname': fullname,
      'commentBody': commentBody,
      'userID': userID,
      'comments': comments,
      'postId': postId,
      'timestamp': timestamp ?? FieldValue.serverTimestamp(),
    };
  }

  factory CommentsModel.fromMap(Map<String, dynamic> map) {
    return CommentsModel(
      id: map['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
    timestamp: map['timestamp'] ?? Timestamp.now(),
      //fromMillisecondsSinceEpoch( map["date"].millisecondsSinceEpoch  ),
      fullname: map['fullname'] ?? '',
      commentBody: map['commentBody'] ?? '',
      comments: map['comments'] ?? [],
      userID: map['userID'] ?? '',
      postId: map['postId'] ?? '',
    );
  }
}
