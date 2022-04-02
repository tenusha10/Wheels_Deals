import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:wheels_deals/Screens/seller_page.dart';
import 'package:wheels_deals/Screens/viewAd.dart';
import 'package:wheels_deals/globalVariables.dart';
import 'package:timeago/timeago.dart' as timeAgo;
import 'package:wheels_deals/presentation/my_flutter_app_icons.dart';
import 'package:wheels_deals/Googlemaps_requests/distanceMatrix.dart';

class searchView extends StatefulWidget {
  final Stream<QuerySnapshot> queryCars;
  final String minPrice, maxPrice;
  final String minMileage, maxMileage;
  final String minEngine, maxEngine;
  final String minYear, maxYear;

  searchView(
      {this.queryCars,
      this.maxPrice,
      this.minPrice,
      this.minMileage,
      this.maxMileage,
      this.maxEngine,
      this.minEngine,
      this.maxYear,
      this.minYear});

  @override
  State<searchView> createState() => _searchViewState();
}

class _searchViewState extends State<searchView> {
  List<QueryDocumentSnapshot<Object>> filteredlist = [];
  List<QueryDocumentSnapshot<Object>> copylist = [];
  bool decending = true;
  bool yearSort = false, disYear = false;
  bool mileageSort = false, disMileage = false;

  String SortFilter;
  List<String> ListofSortFilters = ['Price', 'Year', 'Mileage'];

  final CollectionReference _usersAdref =
      FirebaseFirestore.instance.collection('users');

  Future<String> calculateDistance(
    String destlat,
    String destlng,
    String originlat,
    String originlng,
  ) async {
    var res = await distanceMatrix.getDistance(
        destlat, destlng, originlat, originlng);
    String r = res['rows'][0]['elements'][0]['distance']['text'];
    return r;
  }

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
                bool filtered = false;

                if (snapshot.hasError) {
                  print(snapshot.error.toString());
                  return Text('Something went wrong ');
                }
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasData) {
                  //build filter loop
                  while (filtered == false) {
                    copylist.clear();
                    copylist = snapshot.data.docs;
                    filteredlist.clear();

                    //filter price mileage year and engine capacity
                    if (widget.minPrice != null &&
                        widget.maxPrice != null &&
                        widget.minMileage != null &&
                        widget.minMileage != null &&
                        widget.minYear != null &&
                        widget.maxYear != null &&
                        widget.minEngine != null &&
                        widget.maxEngine != null) {
                      List<QueryDocumentSnapshot<Object>> QueryList = [];
                      print('price mileage year engine');
                      for (int i = 0; i < copylist.length; i++) {
                        Map<String, dynamic> p = copylist[i].data();
                        if ((p['price'] <= int.parse(widget.maxPrice)) &&
                            (p['price'] >= int.parse(widget.minPrice)) &&
                            (p['mileage'] <= int.parse(widget.maxMileage)) &&
                            (p['mileage'] >= int.parse(widget.minMileage)) &&
                            (p['engineCapacity'] <=
                                int.parse(widget.maxEngine)) &&
                            (p['engineCapacity'] >=
                                int.parse(widget.minEngine)) &&
                            (p['year'] <= int.parse(widget.maxYear)) &&
                            (p['year'] >= int.parse(widget.minYear))) {
                          QueryList.add(copylist[i]);
                        }
                      }
                      filteredlist = QueryList;
                      filtered = true;
                      break;
                    }

                    //filter price , mileage , year
                    if (widget.minPrice != null &&
                        widget.maxPrice != null &&
                        widget.minMileage != null &&
                        widget.minMileage != null &&
                        widget.minYear != null &&
                        widget.maxYear != null) {
                      List<QueryDocumentSnapshot<Object>> QueryList = [];
                      print('price mileage year');
                      for (int i = 0; i < copylist.length; i++) {
                        Map<String, dynamic> p = copylist[i].data();
                        if ((p['price'] <= int.parse(widget.maxPrice)) &&
                            (p['price'] >= int.parse(widget.minPrice)) &&
                            (p['mileage'] <= int.parse(widget.maxMileage)) &&
                            (p['mileage'] >= int.parse(widget.minMileage)) &&
                            (p['year'] <= int.parse(widget.maxYear)) &&
                            (p['year'] >= int.parse(widget.minYear))) {
                          QueryList.add(copylist[i]);
                        }
                      }
                      filteredlist = QueryList;
                      filtered = true;
                      break;
                    }

                    //filter price , mileage
                    if (widget.minPrice != null &&
                        widget.maxPrice != null &&
                        widget.minMileage != null &&
                        widget.minMileage != null) {
                      List<QueryDocumentSnapshot<Object>> QueryList = [];
                      print('price mileage');
                      for (int i = 0; i < copylist.length; i++) {
                        Map<String, dynamic> p = copylist[i].data();
                        if ((p['price'] <= int.parse(widget.maxPrice)) &&
                            (p['price'] >= int.parse(widget.minPrice)) &&
                            (p['mileage'] <= int.parse(widget.maxMileage)) &&
                            (p['mileage'] >= int.parse(widget.minMileage))) {
                          QueryList.add(copylist[i]);
                        }
                      }
                      filteredlist = QueryList;
                      filtered = true;
                      break;
                    }

                    //filter price and year
                    if (widget.minPrice != null &&
                        widget.maxPrice != null &&
                        widget.minYear != null &&
                        widget.maxYear != null) {
                      List<QueryDocumentSnapshot<Object>> QueryList = [];
                      print('price year');
                      for (int i = 0; i < copylist.length; i++) {
                        Map<String, dynamic> p = copylist[i].data();
                        if ((p['price'] >= int.parse(widget.minPrice) &&
                            p['price'] <= int.parse(widget.maxPrice) &&
                            (p['year'] >= int.parse(widget.minYear) &&
                                p['year'] <= int.parse(widget.maxYear)))) {
                          print(p['make'] + p['model']);
                          QueryList.add(copylist[i]);
                        }
                      }
                      filteredlist = QueryList;
                      filtered = true;
                      break;
                    }

                    //price and engine
                    if (widget.minPrice != null &&
                        widget.maxPrice != null &&
                        widget.minEngine != null &&
                        widget.maxEngine != null) {
                      List<QueryDocumentSnapshot<Object>> QueryList = [];
                      print('price engine');
                      for (int i = 0; i < copylist.length; i++) {
                        Map<String, dynamic> p = copylist[i].data();
                        if ((p['price'] >= int.parse(widget.minPrice) &&
                            p['price'] <= int.parse(widget.maxPrice) &&
                            (p['engineCapacity'] >=
                                    int.parse(widget.minEngine) &&
                                p['engineCapacity'] <=
                                    int.parse(widget.maxEngine)))) {
                          print(p['make'] + p['model']);
                          QueryList.add(copylist[i]);
                        }
                      }
                      filteredlist = QueryList;
                      filtered = true;
                      break;
                    }

                    //mileage and year
                    if (widget.minMileage != null &&
                        widget.maxMileage != null &&
                        widget.minYear != null &&
                        widget.maxYear != null) {
                      List<QueryDocumentSnapshot<Object>> QueryList = [];
                      print('mileage year');
                      for (int i = 0; i < copylist.length; i++) {
                        Map<String, dynamic> p = copylist[i].data();
                        if ((p['mileage'] >= int.parse(widget.minMileage) &&
                            p['mileage'] <= int.parse(widget.maxMileage) &&
                            (p['year'] >= int.parse(widget.minYear) &&
                                p['year'] <= int.parse(widget.maxYear)))) {
                          print(p['make'] + p['model']);
                          QueryList.add(copylist[i]);
                        }
                      }
                      filteredlist = QueryList;
                      filtered = true;
                      break;
                    }

                    //mileage and engine
                    if (widget.minMileage != null &&
                        widget.maxMileage != null &&
                        widget.minEngine != null &&
                        widget.maxEngine != null) {
                      List<QueryDocumentSnapshot<Object>> QueryList = [];
                      print('mileage engine');
                      for (int i = 0; i < copylist.length; i++) {
                        Map<String, dynamic> p = copylist[i].data();
                        if ((p['mileage'] >= int.parse(widget.minMileage) &&
                            p['mileage'] <= int.parse(widget.maxMileage) &&
                            (p['engineCapacity'] >=
                                    int.parse(widget.minEngine) &&
                                p['engineCapacity'] <=
                                    int.parse(widget.maxEngine)))) {
                          print(p['make'] + p['model']);
                          QueryList.add(copylist[i]);
                        }
                      }
                      filteredlist = QueryList;
                      filtered = true;
                      break;
                    }

                    //year and engine
                    if (widget.minYear != null &&
                        widget.maxYear != null &&
                        widget.minEngine != null &&
                        widget.maxEngine != null) {
                      List<QueryDocumentSnapshot<Object>> QueryList = [];
                      print('year engine');
                      for (int i = 0; i < copylist.length; i++) {
                        Map<String, dynamic> p = copylist[i].data();
                        if ((p['year'] >= int.parse(widget.minYear) &&
                            p['year'] <= int.parse(widget.maxYear) &&
                            (p['engineCapacity'] >=
                                    int.parse(widget.minEngine) &&
                                p['engineCapacity'] <=
                                    int.parse(widget.maxEngine)))) {
                          print(p['make'] + p['model']);
                          QueryList.add(copylist[i]);
                        }
                      }
                      filteredlist = QueryList;
                      filtered = true;
                      break;
                    }

                    //price
                    if (widget.minPrice != null && widget.maxPrice != null) {
                      List<QueryDocumentSnapshot<Object>> QueryList = [];
                      print('price');
                      for (int i = 0; i < copylist.length; i++) {
                        Map<String, dynamic> p = copylist[i].data();
                        if ((p['price'] >= int.parse(widget.minPrice) &&
                            p['price'] <= int.parse(widget.maxPrice))) {
                          print(p['make'] + p['model']);
                          QueryList.add(copylist[i]);
                        }
                      }
                      filteredlist = QueryList;
                      filtered = true;
                      break;
                    }

                    //mileage
                    if (widget.minMileage != null &&
                        widget.maxMileage != null) {
                      List<QueryDocumentSnapshot<Object>> QueryList = [];
                      print('mileage ');
                      for (int i = 0; i < copylist.length; i++) {
                        Map<String, dynamic> p = copylist[i].data();
                        if ((p['mileage'] >= int.parse(widget.minMileage) &&
                            p['mileage'] <= int.parse(widget.maxMileage))) {
                          print(p['make'] + p['model']);
                          QueryList.add(copylist[i]);
                        }
                      }
                      filteredlist = QueryList;
                      filtered = true;
                      break;
                    }

                    //year
                    if (widget.minYear != null && widget.maxYear != null) {
                      List<QueryDocumentSnapshot<Object>> QueryList = [];
                      print('year');
                      for (int i = 0; i < copylist.length; i++) {
                        Map<String, dynamic> p = copylist[i].data();
                        if ((p['year'] >= int.parse(widget.minYear) &&
                            p['year'] <= int.parse(widget.maxYear))) {
                          print(p['make'] + p['model']);
                          QueryList.add(copylist[i]);
                        }
                      }
                      filteredlist = QueryList;
                      filtered = true;
                      break;
                    }

                    // engine
                    if (widget.minEngine != null && widget.maxEngine != null) {
                      List<QueryDocumentSnapshot<Object>> QueryList = [];
                      print('engine');
                      for (int i = 0; i < copylist.length; i++) {
                        Map<String, dynamic> p = copylist[i].data();
                        if ((p['engineCapacity'] >=
                                int.parse(widget.minEngine) &&
                            p['engineCapacity'] <=
                                int.parse(widget.maxEngine))) {
                          print(p['make'] + p['model']);
                          QueryList.add(copylist[i]);
                        }
                      }
                      filteredlist = QueryList;
                      filtered = true;
                      break;
                    }

                    filteredlist = copylist;
                    break;
                  }

                  /*decending
                      ? filteredlist.sort(((a, b) {
                          Map<String, dynamic> c = a.data();
                          Map<String, dynamic> d = b.data();
                          int price1 = c['price'];
                          int price2 = d['price'];
                          return price1.compareTo(price2);
                        }))
                      : filteredlist.sort(((a, b) {
                          Map<String, dynamic> c = a.data();
                          Map<String, dynamic> d = b.data();
                          int price1 = c['price'];
                          int price2 = d['price'];
                          return price2.compareTo(price1);
                        })); */

                  if (decending == true) {
                    if (disMileage == true) {
                      filteredlist.sort(((a, b) {
                        Map<String, dynamic> c = a.data();
                        Map<String, dynamic> d = b.data();
                        int price1 = c['mileage'];
                        int price2 = d['mileage'];
                        return price1.compareTo(price2);
                      }));
                    } else if (disYear == true) {
                      filteredlist.sort(((a, b) {
                        Map<String, dynamic> c = a.data();
                        Map<String, dynamic> d = b.data();
                        int price1 = c['year'];
                        int price2 = d['year'];
                        return price1.compareTo(price2);
                      }));
                    } else {
                      filteredlist.sort(((a, b) {
                        Map<String, dynamic> c = a.data();
                        Map<String, dynamic> d = b.data();
                        int price1 = c['price'];
                        int price2 = d['price'];
                        return price1.compareTo(price2);
                      }));
                    }
                  } else {
                    if (disMileage == true) {
                      filteredlist.sort(((a, b) {
                        Map<String, dynamic> c = a.data();
                        Map<String, dynamic> d = b.data();
                        int price1 = c['mileage'];
                        int price2 = d['mileage'];
                        return price2.compareTo(price1);
                      }));
                    } else if (disYear == true) {
                      filteredlist.sort(((a, b) {
                        Map<String, dynamic> c = a.data();
                        Map<String, dynamic> d = b.data();
                        int price1 = c['year'];
                        int price2 = d['year'];
                        return price2.compareTo(price1);
                      }));
                    } else {
                      filteredlist.sort(((a, b) {
                        Map<String, dynamic> c = a.data();
                        Map<String, dynamic> d = b.data();
                        int price1 = c['price'];
                        int price2 = d['price'];
                        return price2.compareTo(price1);
                      }));
                    }
                  }
                }

                return Column(children: [
                  Container(
                      width: MediaQuery.of(context).size.width * 0.70,
                      height: 90,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        shadowColor: Colors.black,
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    FontAwesomeIcons.magnifyingGlass,
                                    size: 16,
                                    color: Colors.black54,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 5),
                                    child: Text('${filteredlist.length}' +
                                        ' ' +
                                        'Cars Found'),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                                padding:
                                    EdgeInsets.only(top: 5, right: 5, left: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.sort,
                                      size: 18,
                                      color: Colors.black54,
                                    ),
                                    Padding(
                                        padding:
                                            EdgeInsets.only(left: 10, right: 5),
                                        child: Container(
                                          width: 69,
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton<String>(
                                              iconSize: 18,
                                              style: GoogleFonts.roboto(
                                                  fontSize: 18,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                              value: SortFilter,
                                              hint: Text('Sort',
                                                  style:
                                                      TextStyle(fontSize: 14)),
                                              isExpanded: false,
                                              onChanged: (String val) {
                                                setState(() {
                                                  this.SortFilter = val;
                                                  if (val == 'Year') {
                                                    this.disYear = true;
                                                    this.disMileage = false;
                                                  } else if (val == 'Mileage') {
                                                    this.disMileage = true;
                                                    this.disYear = false;
                                                  } else {
                                                    this.disYear = false;
                                                    this.disMileage = false;
                                                  }
                                                });
                                              },
                                              items: ListofSortFilters.map<
                                                      DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(
                                                    value,
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        )),
                                    Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Text(
                                        disYear
                                            ? 'Year:'
                                            : disMileage
                                                ? 'Mileage'
                                                : 'Price',
                                        style: GoogleFonts.roboto(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(left: 1),
                                        child: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                decending = !decending;
                                              });
                                            },
                                            icon: Icon(
                                              decending
                                                  ? FontAwesomeIcons.arrowDown19
                                                  : FontAwesomeIcons.arrowUp19,
                                              size: 22,
                                              color: Colors.black54,
                                            ))),
                                    /*Padding(
                                      padding: EdgeInsets.only(left: 5),
                                      child: Text(
                                        'Year:',
                                        style: GoogleFonts.roboto(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(left: 1),
                                        child: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                yearSort = !yearSort;
                                              });
                                            },
                                            icon: Icon(
                                              yearSort
                                                  ? FontAwesomeIcons.arrowUp19
                                                  : FontAwesomeIcons
                                                      .arrowDown19,
                                              size: 22,
                                              color: Colors.black54,
                                            ))) */
                                  ],
                                )),
                          ],
                        ),
                      )),
                  Container(
                      height: MediaQuery.of(context).size.height * 0.750,
                      child: ListView(
                        children: filteredlist.map((document) {
                          Map<String, dynamic> data = document.data();
                          int price = data['price'];
                          int mileage = data['mileage'];
                          String membersince = timeAgo
                              .format(DateTime.parse(data['userCreatedTime']));

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
                                                    sellerName:
                                                        data['userName'],
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
                                              image:
                                                  NetworkImage(data['imgPro']),
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
                                  trailing: FutureBuilder(
                                    future: calculateDistance(
                                        UserlatlngPosition.latitude.toString(),
                                        UserlatlngPosition.longitude.toString(),
                                        data['latlng'][0],
                                        data['latlng'][1]),
                                    builder: (context, snap) {
                                      if (snap.hasError) {
                                        return Text('Error:');
                                      }
                                      if (snap.hasData) {
                                        return Text(
                                          snap.data,
                                          style: TextStyle(fontSize: 15),
                                        );
                                      }

                                      return Text('...');
                                    },
                                  )),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(FontAwesomeIcons.sterlingSign,
                                            size: 20, color: Colors.black54),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
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
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: Align(
                                              alignment: Alignment.topRight,
                                              child: Text(
                                                  mileage.round().toString() +
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
                                          padding:
                                              const EdgeInsets.only(left: 10),
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
                                          padding:
                                              const EdgeInsets.only(right: 10),
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
                                          padding:
                                              const EdgeInsets.only(left: 10),
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
                                          padding:
                                              const EdgeInsets.only(right: 10),
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
                                          padding:
                                              const EdgeInsets.only(left: 10),
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
                                          padding:
                                              const EdgeInsets.only(right: 10),
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
                        }).toList(),
                      ))
                ]);
              }),
        ));
  }
}
