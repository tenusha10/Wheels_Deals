import 'package:flutter/material.dart';

class register extends StatefulWidget {
  @override
  State<register> createState() => _registerState();
}

class _registerState extends State<register> {
  @override
  Widget build(BuildContext context) {
    return Container();
<<<<<<< HEAD
  }

  void _register() async {
    User currentUser;

    await _auth
        .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim())
        .then((auth) {
      currentUser = auth.user;
    });
=======
>>>>>>> parent of e9c0fd5 (12/2 Login designs and Initial firebase)
  }
}
