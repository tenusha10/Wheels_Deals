import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:wheels_deals/API/fetchedCar.dart';
import 'package:wheels_deals/Widgets/customTextField.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wheels_deals/car_methods.dart';
import 'package:wheels_deals/DialogBox/errorDialogbox.dart';

class sellCars extends StatefulWidget {
  sellCars({Key key}) : super(key: key);

  @override
  State<sellCars> createState() => _sellCarsState();
}

class _sellCarsState extends State<sellCars> {
  final GlobalKey<FormState> _formKeySell = GlobalKey<FormState>();
  String _reg;
  String _mileage;
  String registrationNumber = "nothing";
  String Name, Telephone, Email;
  int engineCapacity = 0;
  String fuelType = '';
  FirebaseAuth auth = FirebaseAuth.instance;
  String make = '';
  String vehicle_colour = '';
  QuerySnapshot cars;
  carMethods carObj = new carMethods();
  TextEditingController _makeController = TextEditingController();
  DVLACar fetchedCar = new DVLACar();

  Future<bool> showDialogEditAdd(regPlate) async {
    var car = await getcarsdvla(regPlate);
    print(car.make);
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "We found Your Car ! ",
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Contact Details',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                TextField(
                  decoration: InputDecoration(hintText: 'Enter Your Name'),
                  onChanged: (value) {
                    this.Name = value;
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                TextField(
                  decoration:
                      InputDecoration(hintText: 'Enter Your Telephone Number'),
                  onChanged: (value) {
                    this.Telephone = value;
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                TextField(
                  decoration: InputDecoration(hintText: 'Manufacturer'),
                ),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  Future<DVLACar> getcarsdvla(reg) async {
    var data = {"registrationNumber": "$reg"};
    final response = await http.post(
        Uri.parse(
            'https://driver-vehicle-licensing.api.gov.uk/vehicle-enquiry/v1/vehicles'),
        headers: {
          'x-api-key': 'q7eOaPr0A65sIpmBT3DJA6gW9oSW9EvaPZAO1gQ1',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(data));

    if (response.statusCode == 200) {
      return DVLACar.fromJson(jsonDecode(response.body));
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Unable to Find your Car !"),
              content: Text('Invalid vehicle registration number'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('OK'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancel'),
                ),
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          Text(
            'Post an Advert',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            'Start by entering the Registration Number and current Mileage',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
          ),
          SizedBox(
            height: 50,
          ),
          Form(
              key: _formKeySell,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    decoration:
                        InputDecoration(labelText: 'Registration Plate'),
                    onChanged: (String value) {
                      _reg = value.toUpperCase().trim();
                    },
                    style: TextStyle(fontSize: 20),
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length > 7) {
                        return 'Please enter a valid Registration Number';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration:
                        InputDecoration(labelText: 'Enter Current Mileage'),
                    onChanged: (String value) {
                      _mileage = value.trim();
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the current Mileage';
                      }
                      return null;
                    },
                    style: TextStyle(fontSize: 20),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(primary: Colors.deepPurple),
                      onPressed: () {
                        if (_formKeySell.currentState.validate()) {
                          showDialogEditAdd(_reg);
                        }
                      },
                      child: Text(
                        'Find Car',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
