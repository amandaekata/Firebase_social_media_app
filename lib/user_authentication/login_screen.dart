import 'package:firebase_application_1/dashboard/dashboard_screen.dart';
import 'package:firebase_application_1/user_authentication/forgot_password.dart';
import 'package:firebase_application_1/user_authentication/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool ishide = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkAuth();
    });

    super.initState();
  }

  void checkAuth() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()));
    }
  }

  bool loading = false;
  TextEditingController emailAddress = TextEditingController();
  TextEditingController password = TextEditingController();

  void getCredential() async {
    loading = true;
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddress.text,
        password: password.text,
      );
      print(credential);

      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()));
      loading = false;
    } on FirebaseAuthException catch (e) {
      loading = false;

      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.code),
      ));
    } catch (e) {
      print(e);
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
              controller: emailAddress,
              decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.only(left: 12, bottom: 22, top: 22),
                  hintText: 'Email adresss',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ForgotPassword()));
                    },
                    child: const Text(
                      'forgot password?',
                      textAlign: TextAlign.end,
                      style:
                          TextStyle(color: Colors.purpleAccent, fontSize: 10),
                    )),
              ],
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
                        'Login',
                        style: TextStyle(color: Colors.white),
                      )),
            TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignupScreen()));
                },
                child: const Text(
                  'Dont have an account? Sign up',
                  textAlign: TextAlign.end,
                  style: TextStyle(color: Colors.purpleAccent, fontSize: 10),
                ))
          ],
        ),
      ),
    );
  }
}
