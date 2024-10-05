import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_application_1/dashboard/comments_page.dart';

import 'package:firebase_application_1/models/post_model.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class PostWidget extends StatefulWidget {
  const PostWidget({super.key, required this.postModel});
  final PostModel postModel;

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;
      isLiked = widget.postModel.likes?.contains(userId) ?? false;
    } else {
      print("User is null. No UID available.");
      // Handle the case where user is null, perhaps set default values
      isLiked = false;
    }
  }

  void likeMethod() async {
    final post = widget.postModel;
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print('User is not logged in');
      return; // Prevent like operation if user is null
    }

    final userId = user.uid;
    final hasLiked = post.likes!.contains(userId);

    if (hasLiked) {
      post.likes!.remove(userId);
    } else {
      post.likes!.add(userId);
    }

    final postRef = FirebaseFirestore.instance.collection('posts').doc(post.id);
    postRef.set(post.toMap());

    setState(() {
      isLiked = post.likes!.contains(userId);
    });
  }

  void _commentsPopup() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        builder: (BuildContext bc) {
          return SizedBox(
              height: MediaQuery.of(context).size.height * 70,
              width: MediaQuery.of(context).size.width,
              child: CommentsPage(
                  fullname: widget.postModel.fullName,
                  postId: widget.postModel.id
                  //add time?
                  ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 30,
                width: 30,
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 114, 136, 153),
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
                    widget.postModel.fullName,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    '${widget.postModel.date}',
                    textAlign: TextAlign.start,
                    style: const TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 300,
            width: double.infinity,
            decoration: const BoxDecoration(
                color: Color.fromARGB(255, 237, 235, 235),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.postModel.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 23),
                    ),
                    Text(
                      widget.postModel.body,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    isLiked = !isLiked;
                    likeMethod();
                    setState(() {});
                  },
                  icon: Icon(Icons.favorite,
                      color: isLiked
                          ? Colors.red
                          : const Color.fromARGB(255, 201, 199, 199))),
              Text(
                '${widget.postModel.likes!.length}',
              ),
              const SizedBox(
                width: 10,
              ),
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        _commentsPopup();
                        setState(() {});
                      },
                      icon: const Icon(Icons.comment_outlined)),

                  // use stream view to display number of comments
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("comments")
                        .where('postId', isEqualTo: widget.postModel.id)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Error');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(
                          height: 20,
                          width: 20,
                          // child: CircularProgressIndicator(),
                        );
                      }

                      int numberOfComments = snapshot.data?.docs.length ?? 0;
                      return Text(
                        '$numberOfComments',
                      );
                    },
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
