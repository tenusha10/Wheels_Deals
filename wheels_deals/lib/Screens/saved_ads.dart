import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wheels_deals/Screens/seller_page.dart';
import 'package:wheels_deals/Screens/viewAd.dart';
import 'package:wheels_deals/globalVariables.dart';
import 'package:timeago/timeago.dart' as timeAgo;

import '../presentation/my_flutter_app_icons.dart';

class saveAds extends StatefulWidget {
  @override
  State<saveAds> createState() => _saveAdsState();
}

class _saveAdsState extends State<saveAds> {
  final Stream<QuerySnapshot> _savedAdstream = FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('Saved')
      .snapshots();

  final CollectionReference _usersAdref =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _carAdref =
      FirebaseFirestore.instance.collection('cars');

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.deepPurple,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 5),
                        child: Icon(
                          FontAwesomeIcons.heart,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      Text(
                        'Saved Ads',
                        style: GoogleFonts.patrickHand(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  )),
              Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width * 0.98,
                child: StreamBuilder<QuerySnapshot>(
                    stream: _savedAdstream,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong ');
                      }
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return ListView(
                          children: snapshot.data.docs
                              .map((DocumentSnapshot document) {
                        return FutureBuilder(
                          future: _carAdref.doc(document.id).get(),
                          builder: (context, Adsnap) {
                            if (Adsnap.hasError) {
                              return Text('Something went wrong ');
                            }
                            if (Adsnap.connectionState ==
                                ConnectionState.done) {
                              Map data = Adsnap.data.data();
                              int price = data['price'];
                              int mileage = data['mileage'];
                              String membersince = timeAgo.format(
                                  DateTime.parse(data['userCreatedTime']));

                              return Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                shadowColor: Colors.black,
                                clipBehavior: Clip.antiAlias,
                                child: Column(children: [
                                  ListTile(
                                    leading: GestureDetector(
                                      onTap: () async {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    sellerPage(
                                                      sellerName:
                                                          data['userName'],
                                                      sellerImage:
                                                          data['imgPro'],
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
                                                image: NetworkImage(
                                                    data['imgPro']),
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
                                                color: Colors.black
                                                    .withOpacity(0.6)),
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
                                        data['sold']
                                            ? Icon(MyFlutterApp.sold_solid,
                                                size: 30, color: Colors.red)
                                            : Icon(
                                                FontAwesomeIcons.rectangleAd,
                                                color: Colors.deepPurple,
                                                size: 20,
                                              )
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
                                            borderRadius:
                                                BorderRadius.circular(20),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(FontAwesomeIcons.sterlingSign,
                                                size: 20,
                                                color: Colors.black54),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
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
                                              padding: const EdgeInsets.only(
                                                  right: 10),
                                              child: Align(
                                                  alignment: Alignment.topRight,
                                                  child: Text(mileage
                                                          .round()
                                                          .toString() +
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              FontAwesomeIcons.car,
                                              color: Colors.black54,
                                              size: 20,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Align(
                                                child: Text(
                                                  data['make'] +
                                                      ' : ' +
                                                      data['model'],
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
                                              padding: const EdgeInsets.only(
                                                  right: 10),
                                              child: Align(
                                                  alignment: Alignment.topRight,
                                                  child: Text(
                                                      data['year'].toString())),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              FontAwesomeIcons.gasPump,
                                              color: Colors.black54,
                                              size: 18,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
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
                                              padding: const EdgeInsets.only(
                                                  right: 10),
                                              child: Align(
                                                  alignment: Alignment.topRight,
                                                  child: Text(data['gearbox'])),
                                            ),
                                            data['gearbox'] == 'Manual'
                                                ? Icon(
                                                    MyFlutterApp
                                                        .manual_transmission,
                                                    color: Colors.black54,
                                                    size: 22,
                                                  )
                                                : Icon(
                                                    MyFlutterApp
                                                        .automatic_transmission,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              FontAwesomeIcons.palette,
                                              color: Colors.black54,
                                              size: 20,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
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
                                              padding: const EdgeInsets.only(
                                                  right: 10),
                                              child: Align(
                                                  alignment: Alignment.topRight,
                                                  child: Text(timeAgo.format(
                                                      DateTime.parse(
                                                          data['time'])))),
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
                            }
                            return Container(
                              child: Center(child: CircularProgressIndicator()),
                            );
                          },
                        );
                      }).toList());
                    }),
              )
            ],
          ),
        ));
  }
}
