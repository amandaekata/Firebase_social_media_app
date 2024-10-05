import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_application_1/models/post_model.dart';
import 'package:firebase_application_1/widgets/post_widget.dart';
import 'package:flutter/material.dart';

Widget buildList(DocumentSnapshot document, context) {
  Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
  PostModel postModel = PostModel.fromMap(data);
   
  return PostWidget(postModel: postModel);
}
