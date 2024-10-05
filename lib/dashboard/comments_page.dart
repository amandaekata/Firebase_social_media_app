import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_application_1/models/comments_model.dart';
import 'package:firebase_application_1/widgets/comment_build.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CommentsPage extends StatefulWidget {
  const CommentsPage({super.key, required this.fullname, required this.postId});
  final String fullname;
  final String postId;
  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final TextEditingController inputComments = TextEditingController();

  Future<void> commentsMethod() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final fullname = userDoc['fullname'];
    final commentsRef = FirebaseFirestore.instance.collection('comments').doc();

    if (inputComments.text.isNotEmpty) {
      await commentsRef.set(
        CommentsModel(
          fullname: fullname,
          userID: userId,
          commentBody: inputComments.text,
          postId: widget.postId,
          id: commentsRef.id,
          timestamp: Timestamp.now(),
        ).toMap(),
      );
      inputComments.clear(); // Clear input after submitting
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // print number of comments here
            //use stream view to display number of comments
            SizedBox(
              height: 30,
              width: 200,
              child: Center(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("comments")
                      .where('postId', isEqualTo: widget.postId)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Error');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return  const SizedBox(
                        height: 5,
                        width: 5,
                        child:  Center(child: CircularProgressIndicator()),
                      );
                    }
                    // Display the number of comments
                    int numberOfComments = snapshot.data?.docs.length ?? 0;
                    return Text('$numberOfComments comments',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ));
                  },
                ),
              ),
            ),

            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("comments")
                      .where('postId', isEqualTo: widget.postId)
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      debugPrint('Error: ${snapshot.error}');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const  SizedBox(
                          height:2,
                          width:5,
                          child:  Center(child: CircularProgressIndicator()));
                    }

                    debugPrint(
                        'list of comments: ${snapshot.data?.docs.length}');
                    return ListView(
                      children: snapshot.data!.docs
                          .map<Widget>((doc) => commentBuild(doc, context))
                          .toList(),
                    );
                  }),
            ),

            Row(
              children: [
                SizedBox(
                  height: 25,
                  width: 330,
                  child: TextField(
                    controller: inputComments,
                    decoration: const InputDecoration(
                      hintText: 'Add comment...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                    onPressed: () {
                      commentsMethod();
                      setState(() {});
                    },
                    icon: const Icon(Icons.send_outlined))
              ],
            )
          ],
        ),
      ),
    );
  }
}
