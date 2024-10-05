import 'package:firebase_application_1/user_authentication/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailAddress = TextEditingController();
  void resetPassword() async{
    await FirebaseAuth.instance
    .sendPasswordResetEmail(email: emailAddress.text);
 
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 236, 163, 249),
        title: const Text(
          'Forgot Password',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body:  Padding(
        padding: const EdgeInsets.only(top: 70, left: 15, right: 15),
        child: Center(
          child: Column( 
          crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            const   Text(
                'Recover with E-mail',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            const   SizedBox(
                height: 15,
              ),
               TextField(
                controller: emailAddress,
                decoration: const InputDecoration(
                  
                    hintText: 'Input Your Email adresss', 
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)))),
                       
                             ),
              const SizedBox(height: 77 ,),
               ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(200, 40),
                      backgroundColor: Colors.black),
                  onPressed: () {
                    resetPassword();

                      Navigator.pop(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                          setState(() {
                            
                          });
                  },
                  child: const Text(
                    'Reset Password',
                    style: TextStyle(color: Colors.white),
                  )),
        
            ],
          ),
        ),
      ),
    );
  }
}
