import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdPage extends StatefulWidget {
  @override
  State<AdPage> createState() => _AdPageState();
}

class _AdPageState extends State<AdPage> {
  final Stream<QuerySnapshot> _carsStream = FirebaseFirestore.instance
      .collection('cars')
      .orderBy("time", descending: true)
      .snapshots();
  final CollectionReference cars =
      FirebaseFirestore.instance.collection('cars');
  @override
  Widget build(BuildContext context) {
    return Container(
        child: StreamBuilder<QuerySnapshot>(
            stream: _carsStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong ');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                Center(child: CircularProgressIndicator());
              }

              return ListView(
                children: snapshot.data.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  return Container(
                    child: Text(data['make']),
                  );
                }).toList(),
              );
            }));
  }
}
