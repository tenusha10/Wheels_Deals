import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wheels_deals/API/CarModels.dart';
import 'package:wheels_deals/API/fetchedCar.dart';
import 'package:wheels_deals/Googlemaps_requests/MapUtils.dart';
import 'package:wheels_deals/Googlemaps_requests/distanceMatrix.dart';
import 'package:wheels_deals/Googlemaps_requests/geocodeRequest.dart';
import 'package:wheels_deals/Screens/seller_page.dart';
import 'package:wheels_deals/Widgets/image_swipe.dart';
import 'package:wheels_deals/globalVariables.dart';
import '/presentation/my_flutter_app_icons.dart';
import 'package:http/http.dart' as http;
import 'package:timeago/timeago.dart' as timeAgo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_static_maps_controller/google_static_maps_controller.dart'
    as sMaps;
import 'package:favorite_button/favorite_button.dart';

class ViewAd extends StatefulWidget {
  final String AdvertID;
  final bool isFav;
  ViewAd({this.AdvertID, this.isFav});

  @override
  State<ViewAd> createState() => _ViewAdState();
}

class _ViewAdState extends State<ViewAd> {
  final CollectionReference _usersAdref =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _carAdReference =
      FirebaseFirestore.instance.collection('cars');
  var distanceData;
  bool f = false;

  Future addToSaved() {
    return _usersAdref
        .doc(userId)
        .collection('Saved')
        .doc(widget.AdvertID)
        .set({});
  }

  Future removeSaved() {
    return _usersAdref
        .doc(userId)
        .collection('Saved')
        .doc(widget.AdvertID)
        .delete();
  }

  final SnackBar _snackBarAdd = SnackBar(
    content: Text(
      'Added to Favourites',
      style: TextStyle(color: Colors.white, fontSize: 18),
    ),
    backgroundColor: Colors.deepPurple,
  );
  final SnackBar _snackBarRemove = SnackBar(
    content: Text(
      'Removed from Favourites',
      style: TextStyle(color: Colors.white, fontSize: 18),
    ),
    backgroundColor: Colors.deepPurple,
  );

  Future<dynamic> calculateDistance(
    String destlat,
    String destlng,
    String originlat,
    String originlng,
  ) async {
    var res = await distanceMatrix.getDistance(
        destlat, destlng, originlat, originlng);

    return res;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    sendtxt(String phoneNumber) async {
      if (Platform.isAndroid) {
        String uri = 'sms:${phoneNumber}?body=Hi';
        await launch(uri);
      } else if (Platform.isIOS) {
        // iOS
        String uri = 'sms:${phoneNumber}';
        await launch(uri);
      }
    }

    sendEmail(String email) async {
      String uri = "mailto:smith@example.org?subject=News&body=New%20plugin";
      await launch(uri);
    }

    phonecall(String phoneNumber) async {
      String uri = 'tel:${phoneNumber}';
      await launch(uri);
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.all(15),
            child: FavoriteButton(
              isFavorite: widget.isFav,
              valueChanged: (valueChanged) async {
                if (valueChanged == false) {
                  await removeSaved();
                  ScaffoldMessenger.of(context).showSnackBar(_snackBarRemove);
                } else {
                  await addToSaved();
                  ScaffoldMessenger.of(context).showSnackBar(_snackBarAdd);
                }
              },
              iconColor: Colors.yellow,
              iconSize: 45,
            ),
          ),
        ],
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
                Color.fromARGB(255, 240, 219, 245),
                Color.fromARGB(255, 252, 252, 252),
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
                int price = data['price'];
                int mileage = data['mileage'];
                List imageList = data['imageURls'];
                bool sold = data['sold'];

                String membersince =
                    timeAgo.format(DateTime.parse(data['userCreatedTime']));

                sMaps.StaticMapController _controller =
                    sMaps.StaticMapController(
                        width: 500,
                        height: 300,
                        googleApiKey: 'AIzaSyCsnujoiLStcDjAxK4Ier7paGsTxifP2Y4',
                        zoom: 13,
                        center: sMaps.Location(double.parse(data['latlng'][0]),
                            double.parse(data['latlng'][1])),
                        markers: <sMaps.Marker>[
                      sMaps.Marker(
                        color: Colors.purple,
                        locations: [
                          sMaps.Location(double.parse(data['latlng'][0]),
                              double.parse(data['latlng'][1]))
                        ],
                      )
                    ]);

                ImageProvider image = _controller.image;

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
                            Icon(
                              FontAwesomeIcons.sterlingSign,
                              size: 18,
                            ),
                            SizedBox(width: 2),
                            Text(
                              price.round().toString(),
                              style: GoogleFonts.anton(
                                  fontSize: 20, color: Colors.deepPurple),
                              textAlign: TextAlign.left,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 50),
                              child: Text(
                                mileage.round().toString() + ' miles',
                                style: GoogleFonts.anton(
                                    fontSize: 18, color: Colors.black87),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Icon(
                                FontAwesome.tachometer,
                                size: 20,
                                color: Colors.black87,
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.2),
                                child: sold
                                    ? Icon(
                                        MyFlutterApp.sold_solid,
                                        size: 60,
                                        color: Colors.red,
                                      )
                                    : Icon(
                                        MyFlutterApp.available,
                                        size: 60,
                                        color: Colors.deepPurple,
                                      ))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5, right: 5),
                        child: Text(
                          'Description',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5, right: 5),
                        child: Text(data['description']),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5, right: 5),
                        child: Text(
                          'Overview',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
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
                                  MyFlutterApp.car_body,
                                  color: Colors.black87,
                                  size: 26,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Align(
                                    child: Text(
                                      data['bodyType'],
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
                                  MyFlutterApp.engine,
                                  color: Colors.black87,
                                  size: 26,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Align(
                                    child: Text(
                                      carModels().getEngineSize(
                                          data['engineCapacity']),
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
                                data['fuelType'] == 'ELECTRICITY'
                                    ? Padding(
                                        padding: EdgeInsets.only(left: 2),
                                        child: Icon(
                                          MyFlutterApp.electric,
                                          color: Colors.black87,
                                          size: 22,
                                        ))
                                    : Padding(
                                        padding: EdgeInsets.only(left: 4),
                                        child: Icon(
                                          FontAwesomeIcons.gasPump,
                                          color: Colors.black54,
                                          size: 20,
                                        ),
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
                                      child:
                                          Text(data['co2'].toString() + 'g')),
                                ),
                                Icon(
                                  MyFlutterApp.carbon_dioxide,
                                  color: Colors.black87,
                                  size: 24,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 7,
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
                                  MyFlutterApp.car_door,
                                  color: Colors.black87,
                                  size: 25,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Align(
                                    child: Text(
                                      data['numofDoors'],
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
                                data['numofDoors'] == '5 Door' ||
                                        data['numofDoors'] == '3 Door'
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Align(
                                            alignment: Alignment.topRight,
                                            child: Text('4 Seats')),
                                      )
                                    : Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Align(
                                            alignment: Alignment.topRight,
                                            child: Text('7 Seats')),
                                      ),
                                Icon(
                                  MyFlutterApp.car_seat,
                                  color: Colors.black87,
                                  size: 24,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 9,
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
                                  MyFlutterApp.tax,
                                  color: Colors.black87,
                                  size: 28,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 7),
                                  child: Align(
                                    child: Text(
                                      data['taxStatus'],
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
                                      child: Text(
                                          'ULEZ (Ultra Low Emission Zone):')),
                                ),
                                data['ulez'] == 'true'
                                    ? Icon(
                                        FontAwesomeIcons.circleCheck,
                                        color: Colors.black54,
                                        size: 20,
                                      )
                                    : Icon(
                                        FontAwesomeIcons.circleXmark,
                                        color: Colors.black54,
                                        size: 20,
                                      )
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, bottom: 3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Icon(
                                    FontAwesomeIcons.calendar,
                                    color: Colors.black54,
                                    size: 20,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Align(
                                    child: data['taxDueDate'] != null
                                        ? Text(
                                            'Tax Due Date : ' +
                                                data['taxDueDate'],
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                          )
                                        : Text(
                                            'Tax Due Date : ' + 'N/A',
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
                                data['numofDoors'] == '5 Door' ||
                                        data['numofDoors'] == '3 Door'
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Align(
                                            alignment: Alignment.topRight,
                                            child: Text('4 Seats')),
                                      )
                                    : Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Align(
                                            alignment: Alignment.topRight,
                                            child: Text('7 Seats')),
                                      ),
                                Icon(
                                  MyFlutterApp.car_seat,
                                  color: Colors.black87,
                                  size: 24,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 9,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, bottom: 3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Icon(
                                    MyFlutterApp.mot,
                                    color: Colors.black87,
                                    size: 22,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Align(
                                    child: Text(
                                      'MOT Status: ' + data['motStatus'],
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
                                      child: Text(data['colour'])),
                                ),
                                Icon(
                                  FontAwesomeIcons.brush,
                                  color: Colors.black54,
                                  size: 20,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 9,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, bottom: 3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Icon(
                                    FontAwesomeIcons.calendarDay,
                                    color: Colors.black54,
                                    size: 20,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Align(
                                    child: data['motExpiry'] != ''
                                        ? Text(
                                            'MOT Due Date: ' +
                                                data['motExpiry'],
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                          )
                                        : Text(
                                            'MOT Due Date: N/A',
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
                                data['cat'] == 'true'
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Align(
                                            alignment: Alignment.topRight,
                                            child: Text('CAT S/N: Declared')),
                                      )
                                    : Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Align(
                                            alignment: Alignment.topRight,
                                            child:
                                                Text('CAT S/N: Not Declared')),
                                      ),
                                Icon(
                                  FontAwesomeIcons.carBurst,
                                  color: Colors.black54,
                                  size: 20,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5, right: 5),
                        child: Text(
                          'Seller Information',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 10, left: 10, right: 5),
                          child: InkWell(
                            onTap: () {},
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              shadowColor: Colors.grey,
                              clipBehavior: Clip.antiAlias,
                              child: Column(
                                children: [
                                  ListTile(
                                    onTap: () {},
                                    leading: GestureDetector(
                                      onTap: () {
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
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      sellerPage(
                                                        sellerName:
                                                            data['userName'],
                                                        sellerImage:
                                                            data['imgPro'],
                                                        sellerSince:
                                                            membersince,
                                                        sellerId: data['uId'],
                                                      )));
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: 10, bottom: 10),
                                          child: Text(
                                            data['userName'],
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )),
                                    subtitle: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      sellerPage(
                                                        sellerName:
                                                            data['userName'],
                                                        sellerImage:
                                                            data['imgPro'],
                                                        sellerSince:
                                                            membersince,
                                                        sellerId: data['uId'],
                                                      )));
                                        },
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  FontAwesomeIcons
                                                      .mobileScreenButton,
                                                  size: 20,
                                                  color: Colors.grey,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  data['userPhoneNumber']
                                                      .toString()
                                                      .toUpperCase(),
                                                  style: TextStyle(
                                                      color: Colors.black
                                                          .withOpacity(0.6)),
                                                ),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                Icon(
                                                  FontAwesomeIcons.envelope,
                                                  size: 20,
                                                  color: Colors.black54,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  data['userEmail']
                                                      .toString()
                                                      .toUpperCase(),
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black
                                                          .withOpacity(0.6)),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  FontAwesomeIcons.userClock,
                                                  size: 20,
                                                  color: Colors.grey,
                                                ),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                Text(
                                                  'Member Since: ' +
                                                      membersince,
                                                  style: TextStyle(
                                                      color: Colors.black
                                                          .withOpacity(0.6)),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          FontAwesomeIcons.idCard,
                                          size: 20,
                                          color: Colors.black54,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                      Padding(
                        padding: EdgeInsets.only(left: 5, right: 5, top: 5),
                        child: Text(
                          'Seller Location',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(left: 5, right: 5, top: 15),
                          child: Row(
                            children: [
                              Icon(
                                FontAwesomeIcons.locationDot,
                                color: Colors.black54,
                                size: 20,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                data['location'],
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                            ],
                          )),
                      Padding(
                        padding: EdgeInsets.only(left: 5, top: 10, bottom: 5),
                        child: FutureBuilder(
                          future: calculateDistance(
                              UserlatlngPosition.latitude.toString(),
                              UserlatlngPosition.longitude.toString(),
                              data['latlng'][0],
                              data['latlng'][1]),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot2) {
                            if (snapshot2.hasError) {
                              return Text('Error: ${snapshot2.error}');
                            }
                            if (snapshot2.hasData) {
                              var result = snapshot2.data;
                              //print(snapshot2.data);
                              return Row(
                                children: [
                                  Icon(
                                    FontAwesomeIcons.locationArrow,
                                    color: Colors.black54,
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    result['rows'][0]['elements'][0]['distance']
                                                ['text']
                                            .toString() +
                                        ' away',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(
                                    width: 50,
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(left: 30),
                                      child: Icon(
                                        FontAwesomeIcons.route,
                                        color: Colors.black54,
                                        size: 20,
                                      )),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 10, right: 5),
                                    child: Text(
                                      'Travel time: ' +
                                          result['rows'][0]['elements'][0]
                                                  ['duration']['text']
                                              .toString(),
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ],
                              );
                            }
                            return Text('Loading');
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5, right: 5, top: 5),
                        child: Text(
                          'Location and Travel Times are approximate',
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(left: 5, right: 5, top: 2),
                          child: Container(
                              decoration: BoxDecoration(shape: BoxShape.circle),
                              alignment: Alignment.topLeft,
                              height: 250,
                              width: MediaQuery.of(context).size.width,
                              child: InkWell(
                                onTap: () {
                                  MapUtils.openMap(
                                      double.parse(data['latlng'][0]),
                                      double.parse(data['latlng'][1]));
                                },
                                child: Image(
                                  image: image,
                                  fit: BoxFit.cover,
                                ),
                              ))),
                      Padding(
                          padding:
                              EdgeInsets.only(left: 5, top: 10, bottom: 10),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  sendtxt(data['userPhoneNumber'].toString());
                                },
                                child: Container(
                                    height: 40,
                                    width: 160,
                                    decoration: BoxDecoration(
                                        gradient: new LinearGradient(
                                            colors: [
                                              Colors.deepPurpleAccent,
                                              Colors.indigoAccent,
                                            ],
                                            begin: const FractionalOffset(
                                                0.0, 0.0),
                                            end: const FractionalOffset(
                                                1.0, 0.0),
                                            stops: [0.0, 1.0],
                                            tileMode: TileMode.clamp),
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    //alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          FontAwesomeIcons.commentSms,
                                          color: Colors.white,
                                          size: 26,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'Text Seller',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        )
                                      ],
                                    )),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          0.15,
                                      right: 5),
                                  child: InkWell(
                                    onTap: () {
                                      phonecall(data['userPhoneNumber']);
                                    },
                                    child: Container(
                                        height: 40,
                                        width: 180,
                                        decoration: BoxDecoration(
                                            gradient: new LinearGradient(
                                                colors: [
                                                  Colors.deepPurpleAccent,
                                                  Colors.purpleAccent,
                                                ],
                                                begin: const FractionalOffset(
                                                    0.0, 0.0),
                                                end: const FractionalOffset(
                                                    1.0, 0.0),
                                                stops: [0.0, 1.0],
                                                tileMode: TileMode.clamp),
                                            borderRadius:
                                                BorderRadius.circular(16)),
                                        //alignment: Alignment.center,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              FontAwesomeIcons.phone,
                                              color: Colors.white,
                                              size: 26,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Call Seller',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18),
                                            )
                                          ],
                                        )),
                                  ))
                            ],
                          ))
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
