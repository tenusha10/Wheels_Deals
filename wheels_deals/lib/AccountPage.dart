import 'package:flutter/material.dart';
import 'package:wheels_deals/authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wheels_deals/login.dart';

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: [
          Text('Home'),
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
