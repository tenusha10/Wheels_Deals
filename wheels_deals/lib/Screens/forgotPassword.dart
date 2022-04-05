import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wheels_deals/loginScreen.dart';

class ForgotPassword extends StatefulWidget {
  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final passwordresetKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  String email = '';
  RegExp regExp_Email =
      new RegExp(r'^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$', caseSensitive: false);

  Future resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Email Sent',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        backgroundColor: Colors.deepPurple,
      ));
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => loginScreen()));
    } on FirebaseAuthException catch (error) {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          error.toString(),
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        backgroundColor: Colors.deepPurple,
      ));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Reset Password'),
        ),
        //backgroundColor: Colors.grey,
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
              key: passwordresetKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Enter your Email to receive a password reset link',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: emailController,
                    cursorColor: Colors.purple,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                        labelText: 'Email',
                        icon: Icon(FontAwesomeIcons.envelope)),
                    onChanged: (value) {
                      this.email = value.trim();
                    },
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value.trim() == null || value.trim().isEmpty) {
                        return 'Please enter an email address';
                      }
                      if (!regExp_Email.hasMatch(value.trim())) {
                        return 'Invalid Email Format';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton.icon(
                          onPressed: () async {
                            if (passwordresetKey.currentState.validate()) {
                              resetPassword();
                            }
                          },
                          icon: Icon(FontAwesomeIcons.envelopeCircleCheck),
                          label: Text('Reset Password',
                              style: TextStyle(fontSize: 20))))
                ],
              )),
        ));
  }
}
