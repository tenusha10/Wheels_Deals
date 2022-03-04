import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wheels_deals/login.dart';

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: [
          ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                return login();
              },
              child: Text('Sign out'))
        ],
      )),
    );
  }
}
