import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wheels_deals/globalVariables.dart';

import '../login.dart';

class AccountScreen extends StatefulWidget {
  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final Stream<QuerySnapshot> _adstream = FirebaseFirestore.instance
      .collection('cars')
      .where('uId', isEqualTo: userId)
      .snapshots();
  /*Container(
              width: 100,
              height: 100,
              alignment: Alignment.center,
              child: ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    return login();
                  },
                  child: Text('Sign out'))), */
  @override
  Widget build(BuildContext context) {
    return Container(
        child: StreamBuilder<QuerySnapshot>(
            stream: _adstream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong ');
              }
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              return ListView(
                children: snapshot.data.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  return Text(data['make']);
                }).toList(),
              );
            }));
  }
}
