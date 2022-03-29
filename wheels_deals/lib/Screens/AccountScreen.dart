import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wheels_deals/Googlemaps_requests/geocodeRequest.dart';
import 'package:wheels_deals/globalVariables.dart';
import 'package:timeago/timeago.dart' as timeAgo;
import 'package:http/http.dart' as http;

import '../API/CarModels.dart';
import '../login.dart';

class AccountScreen extends StatefulWidget {
  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final Stream<QuerySnapshot> _adstream = FirebaseFirestore.instance
      .collection('cars')
      .where('uId', isEqualTo: userId)
      .orderBy("time", descending: true)
      .snapshots();
  final GlobalKey<FormState> _formKeyUpdateCar = GlobalKey<FormState>();
  RegExp regExp = new RegExp(
    r'^[a-z]{1,2}\d[a-z\d]?\s*\d[a-z]{2}',
    caseSensitive: false,
  );
  RegExp regExp_Name = new RegExp(r'^([^0-9]*)$', caseSensitive: false);
  RegExp regExp_Email =
      new RegExp(r'^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$', caseSensitive: false);
  RegExp regExp_phonenumber = new RegExp(r'^[0-9]*$', caseSensitive: false);

  Future<bool> checkPostcode(String postcode) async {
    final response = await http.get(
        Uri.parse('https://api.postcodes.io/postcodes/$postcode/validate'));
    final data = jsonDecode(response.body);
    bool check = data['result'];
    return check;
  }

  Future showDialogForUpdate(DBdata, docID) async {
    String model = DBdata['model'],
        bodyType = DBdata['bodyType'],
        gearbox = DBdata['gearbox'],
        NoofDoors = DBdata['numofDoors'];
    List<String> carmodels = carModels().getModels(DBdata['make']);
    List<String> body_types = carModels().getBodyTypes();
    List<String> gearbox_types = ['GearBox', 'Automatic', 'Manual'];
    List<String> seat_options = ['Number of Doors', '3 Door', '5 Door'];
    double mileage = double.parse(DBdata['mileage']),
        Price = double.parse(DBdata['price']);
    String Description = DBdata['description'],
        Name = DBdata['userName'],
        Email = DBdata['userEmail'],
        Telephone = DBdata['userPhoneNumber'],
        Postcode = DBdata['userPostcode'];
    var C = DBdata['cat'];
    bool CAT = false;
    if (C == 'true') {
      CAT = true;
    } else {
      CAT = false;
    }

    final _Email = TextEditingController();
    _Email.text = DBdata['userEmail'].toString();
    final _Telephone = TextEditingController();
    _Telephone.text = DBdata['userPhoneNumber'].toString();
    final _Price = TextEditingController();
    _Price.text = DBdata['price'].toString();
    final _Mileage = TextEditingController();
    _Mileage.text = DBdata['mileage'].toString();
    final _Description = TextEditingController();
    _Description.text = DBdata['description'].toString();
    final _Postcode = TextEditingController();
    _Postcode.text = DBdata['userPostcode'].toString();
    bool validPostcode = true;

    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                title: Text(
                  "Edit Car details",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                actions: [
                  ElevatedButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  ElevatedButton(
                    child: Text('Update Ad'),
                    onPressed: () async {
                      CollectionReference cars =
                          FirebaseFirestore.instance.collection('cars');
                      validPostcode = await checkPostcode(Postcode);
                      String location = await geocodeRequest
                          .geolocationPostcodetoCity(Postcode);
                      List latlng;
                      latlng = await geocodeRequest
                          .geolocationPostcodetolatlng(Postcode);
                      if (_formKeyUpdateCar.currentState.validate()) {
                        Map<String, dynamic> carData = {
                          'userName': Name,
                          'userEmail': Email,
                          'userPhoneNumber': Telephone,
                          'userPostcode': Postcode,
                          'model': model,
                          'bodyType': bodyType,
                          'gearbox': gearbox,
                          'numofDoors': NoofDoors,
                          'mileage': mileage.toString(),
                          'cat': CAT.toString(),
                          'description': Description,
                          'price': Price.toString(),
                          'location': location,
                          'latlng': latlng
                        };
                        cars.doc(docID).update(carData).then((value) {
                          print('updated');
                          Navigator.pop(context);
                        }).catchError((error) => print(error));
                      }
                    },
                  ),
                ],
                content: SingleChildScrollView(
                  child: Form(
                      key: _formKeyUpdateCar,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Car details',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          DropdownButtonFormField<String>(
                            value: model,
                            isExpanded: true,
                            onChanged: (String val) {
                              setState(() {
                                model = val;
                              });
                            },
                            items: carmodels
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            validator: (value) {
                              if (value == 'Model') {
                                return 'Please select a model';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          DropdownButtonFormField<String>(
                            value: bodyType,
                            isExpanded: true,
                            onChanged: (String val) {
                              setState(() {
                                bodyType = val;
                              });
                            },
                            items: body_types
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            validator: (value) {
                              if (value == 'Body Type') {
                                return 'Please select a Body Type';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          DropdownButtonFormField<String>(
                            value: gearbox,
                            isExpanded: true,
                            onChanged: (String val) {
                              setState(() {
                                gearbox = val;
                              });
                            },
                            items: gearbox_types
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            validator: (value) {
                              if (value == 'GearBox') {
                                return 'Please select the Gear box type';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          DropdownButtonFormField<String>(
                            value: NoofDoors,
                            isExpanded: true,
                            onChanged: (String val) {
                              setState(() {
                                NoofDoors = val;
                              });
                            },
                            items: seat_options
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            validator: (value) {
                              if (value == 'Number of Doors') {
                                return 'Please select the number of doors';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: _Mileage,
                            decoration:
                                InputDecoration(hintText: 'Mileage (Miles)'),
                            onChanged: (value) {
                              mileage = double.parse(value.trim());
                            },
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value.trim() == null || value.isEmpty) {
                                return 'Mileage cannot be empty';
                              }

                              if (double.parse(value.trim()) > 200000) {
                                return 'Mileage is too high';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                'CAT C/D:',
                              ),
                              CupertinoSwitch(
                                  value: CAT,
                                  activeColor: Colors.deepPurple,
                                  onChanged: (bool value) {
                                    setState((() {
                                      CAT = value;
                                    }));
                                  }),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Description',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                              'Enter below all the additional features of your vehicle and a brief description for the listing'),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: _Description,
                            decoration:
                                InputDecoration(hintText: 'Description of Ad'),
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            onChanged: (value) {
                              Description = value;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a Description';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Price',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          TextFormField(
                            controller: _Price,
                            decoration:
                                InputDecoration(hintText: 'Asking Price £'),
                            onChanged: (value) {
                              Price = double.parse(value.trim());
                            },
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value.trim() == null || value.isEmpty) {
                                return 'Please enter a price £';
                              }

                              if (double.parse(value.trim()) <= 99) {
                                return 'Car value is too low, minimum value = £100';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            'Contact Details',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          TextFormField(
                            controller: _Email,
                            decoration:
                                InputDecoration(hintText: 'Email Address'),
                            onChanged: (value) {
                              Email = value.trim();
                            },
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value.trim() == null ||
                                  value.trim().isEmpty) {
                                return 'Please enter an email address';
                              }
                              if (!regExp_Email.hasMatch(value.trim())) {
                                return 'Invalid Email Format';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            controller: _Telephone,
                            decoration: InputDecoration(
                              hintText: 'Phone Number',
                            ),
                            onChanged: (value) {
                              Telephone = value.trim();
                            },
                            validator: (value) {
                              if (value.trim() == null || value.isEmpty) {
                                return 'Please enter a phone number';
                              }

                              if (!regExp_phonenumber.hasMatch(value.trim())) {
                                return 'Invalid Phone number format';
                              }

                              if (value.trim().length > 11) {
                                return 'Number is too long';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            controller: _Postcode,
                            decoration: InputDecoration(
                              hintText: 'Vechicle Location (PostCode)',
                            ),
                            onChanged: (value) {
                              Postcode = value.trim();
                            },
                            validator: (value) {
                              if (value.trim() == null || value.isEmpty) {
                                return 'Please enter a postcode';
                              }
                              if (!regExp.hasMatch(value.trim())) {
                                return 'Invalid postcode Format';
                              }
                              if (validPostcode == false) {
                                return 'Postcode not found';
                              }
                              return null;
                            },
                          ),
                        ],
                      )),
                ));
          });
        });
  }

  Future showDialogToDelete(data, DocID) async {
    CollectionReference cars = FirebaseFirestore.instance.collection('cars');
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Delete Ad?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            actions: [
              SizedBox(
                width: 10,
              ),
              ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(FontAwesomeIcons.ban),
                  label: Text('Cancel')),
              SizedBox(
                width: 10,
              ),
              ElevatedButton.icon(
                  onPressed: () {
                    cars
                        .doc(DocID)
                        .delete()
                        .then((value) => Navigator.pop(context))
                        .catchError((error) => print(error));
                  },
                  icon: Icon(FontAwesomeIcons.check),
                  label: Text('Confirm'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.deepPurple[50],
        body: SingleChildScrollView(
            child: Column(
          children: [
            Container(
                width: 80,
                height: 80,
                alignment: Alignment.center,
                child: ElevatedButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      login();
                    },
                    child: Text('Sign out'))),
            Text(
              'Manage Ads',
              style: GoogleFonts.patrickHand(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.center,
              height: 620,
              width: 500,
              child: StreamBuilder<QuerySnapshot>(
                  stream: _adstream,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong ');
                    }
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return ListView(
                      children:
                          snapshot.data.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;
                        double price = double.parse(data['price']);
                        double mileage = double.parse(data['mileage']);
                        return Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          shadowColor: Colors.black,
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            children: [
                              ListTile(
                                  title: GestureDetector(
                                    onTap: () {},
                                    child: Text(
                                        data['make'] + ' : ' + data['model']),
                                  ),
                                  subtitle: GestureDetector(
                                    onTap: () {},
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          FontAwesomeIcons.clock,
                                          size: 18,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          timeAgo.format(
                                              DateTime.parse(data['time'])),
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
                                      GestureDetector(
                                        onTap: (() {
                                          String DocID;
                                          if (data['uId'] == userId) {
                                            DocID = document.id;
                                            showDialogForUpdate(data, DocID);
                                          }
                                        }),
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
                                          onTap: () {
                                            String DocID;
                                            if (data['uId'] == userId) {
                                              DocID = document.id;
                                              showDialogToDelete(data, DocID);
                                            }
                                          },
                                          child: Icon(
                                            FontAwesomeIcons.trashCan,
                                            size: 20,
                                            color: Colors.black54,
                                          )),
                                    ],
                                  )),
                              Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.network(
                                        data['imageURls'][0],
                                        fit: BoxFit.cover,
                                        height: 200,
                                        width: 300,
                                      ))),
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
                                              child: Text(data['year'])),
                                        ),
                                        Icon(
                                          FontAwesomeIcons.calendarAlt,
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
                                        Icon(
                                          FontAwesomeIcons.cogs,
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
                                              child:
                                                  Text(data['registration'])),
                                        ),
                                        Icon(
                                          FontAwesomeIcons.solidRegistered,
                                          color: Colors.black54,
                                          size: 20,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  }),
            )
          ],
        )));
  }
}
