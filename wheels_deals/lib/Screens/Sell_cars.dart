import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wheels_deals/API/CarModels.dart';
import 'package:wheels_deals/API/fetchedCar.dart';
import 'package:wheels_deals/Widgets/customTextField.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wheels_deals/car_methods.dart';
import 'package:wheels_deals/DialogBox/errorDialogbox.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:wheels_deals/imageSelection/user_image.dart';

class sellCars extends StatefulWidget {
  sellCars({Key key}) : super(key: key);

  @override
  State<sellCars> createState() => _sellCarsState();
}

class _sellCarsState extends State<sellCars> {
  final GlobalKey<FormState> _formKeySell = GlobalKey<FormState>();
  String _reg;
  String Name, Telephone, Email;
  double Price, mileage;
  bool CAT = false;
  bool visibility = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  String make,
      model = "Model",
      colour,
      fuelType,
      regNumber,
      yearOfManufacture,
      taxStatus,
      TaxDueDate,
      co2Emissions,
      enginecapacity,
      dateofV5,
      motStatus,
      firstRegistrationDate,
      bodyType = "Body Type",
      gearbox = 'GearBox',
      NoofDoors = 'Number of Doors',
      Description;
  QuerySnapshot cars;
  File _image;
  ImagePicker picker = ImagePicker();
  // String imageUrl = '';
  File image, image2;
  //carMethods carObj = new carMethods();
  //DVLACar fetchedCar = new DVLACar();

  /*Future<bool> showDialogEditAdd(regPlate) async {
    var car = await getcarsdvla(regPlate);
    //print(car.make);
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "We found Your Car ! ",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            content: SingleChildScrollView(
                child: Column(
              mainAxisSize: MainAxisSize.max,
              //mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Car details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Registration: ' + car.registrationNumber,
                  //style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Manufacturer: ' + car.make,
                  //style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Colour: ' + car.colour,
                  //style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Mileage (Miles) : ' + _mileage,
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Model Year: ' + car.yearOfManufacture.toString(),
                  //style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'First Registration Date: ' +
                      car.monthOfFirstRegistration.toString(),
                  //style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Fuel Type: ' + car.fuelType,
                  //style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Co2 Emmisions: ' + car.co2Emissions.toString(),
                  //style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Engine Capacity: ' + car.engineCapacity.toString(),
                  //style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'MOT Status: ' + car.motStatus,
                  //style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Tax Status: ' + car.taxStatus,
                  //style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Tax Due Date: ' + car.taxDueDate,
                  //style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Date Last v5 Issued: ' + car.dateOfLastV5CIssued,
                  //style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                TextField(
                  decoration: InputDecoration(hintText: 'Asking Price £'),
                  onChanged: (value) {
                    this.Price = double.parse(value);
                  },
                  keyboardType: TextInputType.number,
                ),
                SizedBox(
                  height: 15,
                ),
                DropdownButton<String>(
                  value: model,
                  onChanged: (String val) {
                    setState(() {
                      model = val;
                    });
                  },
                  items: Sitems.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Contact Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextField(
                  decoration: InputDecoration(hintText: 'Name'),
                  onChanged: (value) {
                    this.Name = value;
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                TextField(
                  decoration: InputDecoration(hintText: 'Email Address'),
                  onChanged: (value) {
                    this.Email = value;
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Phone Number',
                  ),
                  onChanged: (value) {
                    this.Telephone = value;
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Vechicle Location (PostCode)',
                  ),
                ),
              ],
            )),
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
  } */

  Future<bool> showView(regPlate) async {
    var car = await getcarsdvla(regPlate);
    List<String> carmodels = carModels().getModels(car.make);
    List<String> body_types = carModels().getBodyTypes();
    List<String> gearbox_types = ['GearBox', 'Automatic', 'Manual'];
    List<String> seat_options = ['Number of Doors', '3 Door', '5 Door'];
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                title: Text(
                  "We found Your Car ! ",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                actions: [
                  ElevatedButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.pop(context);
                      model = 'Model';
                      bodyType = "Body Type";
                      gearbox = 'GearBox';
                      NoofDoors = 'Number of Doors';
                    },
                  )
                ],
                content: SingleChildScrollView(
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                          'Car details',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Registration: ' + car.registrationNumber,
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Manufacturer: ' + car.make,
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Colour: ' + car.colour,
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Model Year: ' + car.yearOfManufacture.toString(),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'First Registration Date: ' +
                              car.monthOfFirstRegistration.toString(),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Fuel Type: ' + car.fuelType,
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Co2 Emmisions: ' + car.co2Emissions.toString(),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Engine Capacity: ' + car.engineCapacity.toString(),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'MOT Status: ' + car.motStatus,
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Tax Status: ' + car.taxStatus,
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Tax Due Date: ' + car.taxDueDate,
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Date Last v5 Issued: ' + car.dateOfLastV5CIssued,
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Additional Car details',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        DropdownButton<String>(
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
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        DropdownButton<String>(
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
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        DropdownButton<String>(
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
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        DropdownButton<String>(
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
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          decoration:
                              InputDecoration(hintText: 'Mileage (Miles)'),
                          onChanged: (value) {
                            this.mileage = double.parse(value);
                          },
                          keyboardType: TextInputType.number,
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
                            'Enter below all the additional features of your vehicle and a breif description for the listing'),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          decoration:
                              InputDecoration(hintText: 'Description of Ad'),
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          onChanged: (value) {
                            this.Description = value;
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
                        TextField(
                          decoration:
                              InputDecoration(hintText: 'Asking Price £'),
                          onChanged: (value) {
                            this.Price = double.parse(value);
                          },
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Contact Details',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        TextField(
                          decoration: InputDecoration(hintText: 'Name'),
                          onChanged: (value) {
                            this.Name = value;
                          },
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextField(
                          decoration:
                              InputDecoration(hintText: 'Email Address'),
                          onChanged: (value) {
                            this.Email = value;
                          },
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Phone Number',
                          ),
                          onChanged: (value) {
                            this.Telephone = value;
                          },
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Vechicle Location (PostCode)',
                          ),
                        ),
                      ]),
                ));
          });
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

  Future pickImage(ImageSource source) async {
    try {
      XFile image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imageTemp = File(image.path);

      setState(() {
        this._image = imageTemp;
      });
    } on PlatformException catch (e) {
      print('Failed to pick Image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Text(
            'Post an Advert',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Please enter your car Registration Number',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
          ),
          SizedBox(
            height: 10,
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
                  SizedBox(
                    height: 10,
                  ),
                ],
              )),
          /*ElevatedButton(
              onPressed: () {
                pickImage(ImageSource.gallery);
              },
              child: Text('Take photo')), //Image.file(_image), */
          /*Row(
            children: _image == null
                ? [Text('Image is not loaded ')]
                : [
                    Image.file(
                      _image,
                      height: 200,
                      width: 400,
                    )
                  ],
          ),
           */
          Row(
            children: [
              UserImage(
                onFileChanged: ((image) {
                  setState(() {
                    this.image = image;
                  });
                }),
              ),
              UserImage(
                onFileChanged: ((image2) {
                  setState(() {
                    this.image2 = image2;
                  });
                }),
              )
            ],
          ),
          SizedBox(
            height: 50,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.height * 0.04,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.deepPurple),
              onPressed: () {
                if (_formKeySell.currentState.validate()) {
                  //showDialogEditAdd(_reg);
                  showView(_reg);
                }
              },
              child: Text(
                'Find Car',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
