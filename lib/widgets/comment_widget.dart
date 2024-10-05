
import 'package:firebase_application_1/models/comments_model.dart';

import 'package:flutter/material.dart';

class CommentWidget extends StatefulWidget {
  const CommentWidget({super.key,  this.commentsModel});
final CommentsModel? commentsModel;

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
 
  @override
  Widget build(BuildContext context) {
    
    return    Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 30,
                  width: 30,
                  decoration: const BoxDecoration( color: Color.fromARGB(255, 114, 136, 153),
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: const Icon(Icons.person),
                ),
                const SizedBox(
                  width: 9,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                     widget.commentsModel!.fullname,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                           fontSize: 12),
                    ),
                    SizedBox( width: 300,
                      child: Text(
                                         widget.commentsModel!.commentBody, 
                        textAlign: TextAlign.start,
                        style: const TextStyle(fontSize: 15, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}