import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_application_1/dashboard/dashboard_screen.dart';
import 'package:firebase_application_1/models/post_model.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({super.key, required this.fullname});
final  String fullname ;
  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final TextEditingController title = TextEditingController();
  final TextEditingController body = TextEditingController();
  Future<void> createPost() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    final postRef = FirebaseFirestore.instance.collection('posts').doc();

    await postRef.set(PostModel(
      
            body: body.text,
            title: title.text,
            id:  postRef.id,
            date: DateTime.now(), 
            userID: userId,
             fullName: widget.fullname,
           
            )
        .toMap());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a Post'),
        backgroundColor: const Color.fromARGB(255, 196, 213, 162),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
                controller: title,
                decoration: const InputDecoration(
                  hintText: 'Title?',
                )),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: body,
              decoration: const InputDecoration(
                hintText: 'What do you want to talk about?',
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Center(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(150, 30),
                    backgroundColor: const Color.fromARGB(255, 196, 213, 162),
                  ),
                  onPressed: () {
                    createPost();

                    Navigator.pop(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DashboardScreen()));
                  },
                  child: const Text(
                    'Post',
                    style: TextStyle(color: Colors.black),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
