import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:wheels_deals/Screens/seller_page.dart';
import 'package:wheels_deals/Screens/viewAd.dart';
import 'package:wheels_deals/globalVariables.dart';
import 'package:timeago/timeago.dart' as timeAgo;
import 'package:wheels_deals/presentation/my_flutter_app_icons.dart';

class searchView extends StatefulWidget {
  final Stream<QuerySnapshot> queryCars;

  searchView({this.queryCars});

  @override
  State<searchView> createState() => _searchViewState();
}

class _searchViewState extends State<searchView> {
  /*final Stream<QuerySnapshot> _carsStream = FirebaseFirestore.instance
      .collection('cars')
      .orderBy("time", descending: true)
      .snapshots(); */

  final CollectionReference _usersAdref =
      FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> _carsStream = widget.queryCars;

    Future<bool> checkifFavourites(String adId) async {
      DocumentSnapshot<Map<String, dynamic>> res;
      res = await _usersAdref.doc(userId).collection('Saved').doc(adId).get();
      if (res != null) {
        Map<String, dynamic> d = res.data();
        if (d == null) {
          return false;
        } else {
          return true;
        }
      }
    }

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
          padding: EdgeInsets.all(5),
          //height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.deepPurple, Colors.deepPurpleAccent],
            ),
          ),
          child: StreamBuilder<QuerySnapshot>(
              stream: _carsStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error.toString());
                  return Text('Something went wrong ');
                }
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                return ListView(
                  children: snapshot.data.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    int price = data['price'];
                    int mileage = data['mileage'];
                    String membersince =
                        timeAgo.format(DateTime.parse(data['userCreatedTime']));

                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      shadowColor: Colors.black,
                      clipBehavior: Clip.antiAlias,
                      child: Column(children: [
                        ListTile(
                          leading: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => sellerPage(
                                            sellerName: data['userName'],
                                            sellerImage: data['imgPro'],
                                            sellerSince: membersince,
                                            sellerId: data['uId'],
                                          )));
                            },
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: NetworkImage(data['imgPro']),
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
                                  FontAwesomeIcons.locationDot,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  data['location'],
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.6)),
                                ),
                                SizedBox(
                                  width: 0.4,
                                ),
                              ],
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                FontAwesomeIcons.rectangleAd,
                                size: 20,
                                color: Colors.deepPurple,
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            bool f = false;
                            f = await checkifFavourites(document.id);

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ViewAd(
                                          AdvertID: document.id,
                                          isFav: f,
                                        )));
                          },
                          child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    data['imageURls'][0],
                                    fit: BoxFit.cover,
                                    height: 300,
                                    width: 400,
                                  ))),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, bottom: 3),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(FontAwesomeIcons.sterlingSign,
                                      size: 20, color: Colors.black54),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Align(
                                      child: Text(
                                        price.round().toString(),
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
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Align(
                                        alignment: Alignment.topRight,
                                        child: Text(mileage.round().toString() +
                                            ' miles')),
                                  ),
                                  Icon(
                                    FontAwesome.tachometer,
                                    color: Colors.black54,
                                    size: 20,
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
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, bottom: 3),
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
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Align(
                                        alignment: Alignment.topRight,
                                        child: Text(data['year'].toString())),
                                  ),
                                  Icon(
                                    FontAwesomeIcons.calendarDays,
                                    color: Colors.black54,
                                    size: 20,
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
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, bottom: 5),
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
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Align(
                                        alignment: Alignment.topRight,
                                        child: Text(data['gearbox'])),
                                  ),
                                  data['gearbox'] == 'Manual'
                                      ? Icon(
                                          MyFlutterApp.manual_transmission,
                                          color: Colors.black54,
                                          size: 22,
                                        )
                                      : Icon(
                                          MyFlutterApp.automatic_transmission,
                                          color: Colors.black54,
                                          size: 24,
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
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, bottom: 5),
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
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Align(
                                        alignment: Alignment.topRight,
                                        child: Text(timeAgo.format(
                                            DateTime.parse(data['time'])))),
                                  ),
                                  Icon(
                                    FontAwesomeIcons.clock,
                                    color: Colors.black54,
                                    size: 20,
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
              }),
        ));
  }
}
