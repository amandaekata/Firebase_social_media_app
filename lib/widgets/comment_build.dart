import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_application_1/models/comments_model.dart';

import 'package:firebase_application_1/widgets/comment_widget.dart';

import 'package:flutter/material.dart';

Widget commentBuild(DocumentSnapshot doc, context) {
  Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
  CommentsModel commentsModel = CommentsModel.fromMap(data);
  return CommentWidget(commentsModel: commentsModel);
}
