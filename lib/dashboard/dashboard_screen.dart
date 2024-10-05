import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_application_1/dashboard/create_post.dart';
import 'package:firebase_application_1/user_authentication/login_screen.dart';
import 'package:firebase_application_1/widgets/buildlist.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  var users;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      printDetails();
    });
    super.initState();
  }

  void printDetails() async {
    User? user = FirebaseAuth.instance.currentUser;

    final db = FirebaseFirestore.instance;
    await db.collection("users").doc(user!.uid).get().then((event) {
      users = event.data();

      print(event.data());
      setState(() {});
    });
  }

  Future<void> signout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    } catch (e) {
      // Handle sign-out error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        title: const Text(
          '@Firebase',
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic),
        ),
        backgroundColor: const Color.fromARGB(255, 196, 213, 162),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (users != null) ...[
              Text(
                "Name: ${users?["fullname"] ?? ''}",
                textAlign: TextAlign.start,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
              ),
              Text(
                'school: ${users?['school'] ?? ''}',
                textAlign: TextAlign.start,
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                'Email: ${users?['email'] ?? ''}',
                textAlign: TextAlign.start,
                style: const TextStyle(fontSize: 16),
              ),
            ],
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("posts")
                      .orderBy('date', descending: true)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text('error');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          // height: MediaQuery.of(context).size.height,
                          // width: MediaQuery.of(context).size.width,
                          child: CircularProgressIndicator());
                    }
                    debugPrint('list of posts: ${snapshot.data?.docs.length}');
                    return ListView(
                      children: snapshot.data!.docs
                          .map<Widget>((doc) => buildList(doc, context))
                          .toList(),
                    );
                  }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreatePost(
                                  fullname: users["fullname"],
                                )));
                  },
                  backgroundColor: const Color.fromARGB(255, 196, 213, 162),
                  child: const Text(
                    '+',
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            Center(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(150, 30),
                      backgroundColor: Colors.black),
                  onPressed: () {
                    signout();
                  },
                  child: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.white),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
