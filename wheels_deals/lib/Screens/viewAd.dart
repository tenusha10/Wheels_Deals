import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wheels_deals/Widgets/image_swipe.dart';

class ViewAd extends StatefulWidget {
  final String AdvertID;
  ViewAd({this.AdvertID});

  @override
  State<ViewAd> createState() => _ViewAdState();
}

class _ViewAdState extends State<ViewAd> {
  final CollectionReference _carAdReference =
      FirebaseFirestore.instance.collection('cars');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: new BoxDecoration(
              gradient: new LinearGradient(
                  colors: [Colors.deepPurpleAccent, Colors.purple],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp)),
        ),
      ),
      body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color.fromARGB(255, 250, 249, 250),
                Color.fromARGB(255, 234, 203, 240)
              ],
            ),
          ),
          child: FutureBuilder(
            future: _carAdReference.doc(widget.AdvertID).get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text('Error: ${snapshot.error}'),
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> data = snapshot.data.data();
                double price = double.parse(data['price']);
                double mileage = double.parse(data['mileage']);
                List imageList = data['imageURls'];

                return ListView(
                    //padding: EdgeInsets.only(left: 1, right: 1),
                    children: [
                      ImageSwipe(
                        imageList: imageList,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5, right: 5),
                        child: Text(
                          data['make'] + " : " + data['model'],
                          style: GoogleFonts.bungee(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5, right: 5),
                        child: Row(
                          children: [
                            Text(
                              "£ " + price.round().toString(),
                              style: GoogleFonts.anton(
                                  fontSize: 20, color: Colors.deepPurple),
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(
                              width: 240,
                            ),
                            Text(
                              mileage.round().toString() + 'miles',
                              style: GoogleFonts.anton(
                                  fontSize: 18, color: Colors.black87),
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5, right: 5),
                        child: Text(data['description']),
                      )
                    ]);
              }
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          )),
    );
  }
}
