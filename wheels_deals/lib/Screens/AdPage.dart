import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wheels_deals/globalVariables.dart';
import 'package:timeago/timeago.dart' as timeAgo;

class AdPage extends StatefulWidget {
  @override
  State<AdPage> createState() => _AdPageState();
}

class _AdPageState extends State<AdPage> {
  final Stream<QuerySnapshot> _carsStream = FirebaseFirestore.instance
      .collection('cars')
      .orderBy("time", descending: true)
      .snapshots();

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser.uid;
    print(userId);
    userEmail = FirebaseAuth.instance.currentUser.email;
  }

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;

    return Container(
        padding: EdgeInsets.all(5),
        //height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.deepPurple[50], Colors.purple[100]],
          ),
        ),
        //color: Color.fromARGB(255, 202, 200, 200),
        child: StreamBuilder<QuerySnapshot>(
            stream: _carsStream,
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
                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    shadowColor: Colors.black,
                    clipBehavior: Clip.antiAlias,
                    child: Column(children: [
                      ListTile(
                          leading: GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          'https://carwow-uk-wp-3.imgix.net/Volvo-XC40-white-scaled.jpg'),
                                      fit: BoxFit.fill)),
                            ),
                          ),
                          title: GestureDetector(
                            onTap: () {},
                            child: Text(data['userName']),
                          ),
                          subtitle: GestureDetector(
                            onTap: () {},
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.location_pin,
                                  color: Colors.grey,
                                ),
                                Text(
                                  data['userPostcode'],
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.6)),
                                ),
                                SizedBox(
                                  width: 0.4,
                                ),
                              ],
                            ),
                          ),
                          trailing: data['uId'] == userId
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      onTap: (() {}),
                                      child: Icon(
                                        FontAwesomeIcons.edit,
                                        size: 20,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    GestureDetector(
                                        onDoubleTap: () {},
                                        child: Icon(
                                          FontAwesomeIcons.trashAlt,
                                          size: 20,
                                          color: Colors.black54,
                                        )),
                                  ],
                                )
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [],
                                )),
                      Padding(
                          padding: const EdgeInsets.all(16),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                data['imageURls'][0],
                                fit: BoxFit.cover,
                                height: 300,
                                width: 400,
                              ))),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, bottom: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(FontAwesomeIcons.poundSign,
                                    size: 20, color: Colors.black54),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Align(
                                    child: Text(
                                      data['price'].toString(),
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    alignment: Alignment.topLeft,
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  FontAwesome.tachometer,
                                  color: Colors.black54,
                                  size: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(data['mileage'] + ' Miles')),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.car,
                                  color: Colors.black54,
                                  size: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Align(
                                    child: Text(
                                      data['make'] + ' : ' + data['model'],
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    alignment: Alignment.topLeft,
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.calendarAlt,
                                  color: Colors.black54,
                                  size: 18,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(data['year'])),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.gasPump,
                                  color: Colors.black54,
                                  size: 18,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Align(
                                    child: Text(
                                      data['fuelType'],
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    alignment: Alignment.topLeft,
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.cogs,
                                  color: Colors.black54,
                                  size: 18,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(data['gearbox'])),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.palette,
                                  color: Colors.black54,
                                  size: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Align(
                                    child: Text(
                                      data['colour'],
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    alignment: Alignment.topLeft,
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.clock,
                                  color: Colors.black54,
                                  size: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(timeAgo.format(
                                          DateTime.parse(data['time'])))),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ]),
                  );
                }).toList(),
              );
            }));
  }
}
