import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_application_1/dashboard/dashboard_screen.dart';
import 'package:firebase_application_1/user_authentication/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool ishide = true;
  bool loading = false;
  TextEditingController emailAddress = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController school = TextEditingController();
  TextEditingController name = TextEditingController();

  void userCollection(UserCredential authentifiedUsers) async {
    try {
      final db = FirebaseFirestore.instance;
      final user = <String, dynamic>{
        "fullname": name.text,
        "email": emailAddress.text,
        "school": school.text,
        "id": authentifiedUsers.user!.uid
      };

// Add a new document with a generated ID
      await db.collection("users").doc(authentifiedUsers.user!.uid).set(user);
      await Navigator.push(context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()));
    } catch (e) {
      print(e);
    }
  }

  void getCredential() async {
    loading = true;
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress.text,
        password: password.text,
      );
      print(credential);
      userCollection(credential);

      loading = false;
    } on FirebaseAuthException catch (e) {
      loading = false;
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.code),
      ));
    } catch (e) {
      print(e);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: name,
              decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.only(left: 12, bottom: 20, top: 22),
                  hintText: 'Full name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)))),
            ),
            const SizedBox(
              height: 50,
            ),
            TextField(
              controller: emailAddress,
              decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.only(left: 12, bottom: 20, top: 22),
                  hintText: 'Email adresss',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)))),
            ),
            const SizedBox(
              height: 50,
            ),
            TextField(
              controller: school,
              decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.only(left: 12, bottom: 20, top: 22),
                  hintText: 'School',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)))),
            ),
            const SizedBox(
              height: 50,
            ),
            TextFormField(
              controller: password,
              //obscure text sets the password to either hide or show 'onpressed'
              obscureText: ishide,
              decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.only(left: 12, bottom: 12, top: 8),
                  suffix: IconButton(
                      onPressed: () {
                        setState(() {
                          ishide = !ishide;
                        });
                      },
                      icon: ishide
                          ? const Icon(
                              Icons.visibility_off_outlined,
                            )
                          : const Icon(
                              Icons.visibility_outlined,
                            )),
                  hintText: 'Password',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5))),
            ),
            const SizedBox(
              height: 200,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(200, 40),
                    backgroundColor: Colors.black),
                onPressed: () {
                  getCredential();
                },
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text(
                        'Sign Up',
                        style: TextStyle(color: Colors.white),
                      )),
            TextButton(
                onPressed: () {
                  Navigator.pop(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                },
                child: const Text(
                  'Already  have an account? Log in',
                  textAlign: TextAlign.end,
                  style: TextStyle(color: Colors.purpleAccent, fontSize: 10),
                ))
          ],
        ),
      ),
    );
  }
}
