import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wheels_deals/API/CarModels.dart';
import 'package:wheels_deals/API/fetchedCar.dart';
import 'package:wheels_deals/API/firebase_api.dart';
import 'package:wheels_deals/Screens/HomeScreen.dart';
import 'package:wheels_deals/Widgets/customTextField.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wheels_deals/car_methods.dart';
import 'package:wheels_deals/DialogBox/errorDialogbox.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:wheels_deals/globalVariables.dart';
import 'package:wheels_deals/imageSelection/user_image.dart';
import 'package:path/path.dart' as p;

class sellCars extends StatefulWidget {
  sellCars({Key key}) : super(key: key);

  @override
  State<sellCars> createState() => _sellCarsState();
}

class _sellCarsState extends State<sellCars> {
  final GlobalKey<FormState> _formKeySell = GlobalKey<FormState>();
  String _reg;
  String Name, Telephone, Email, Postcode;
  double Price, mileage;
  bool CAT = false;
  bool visibility = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  List<String> imageUrlList = [];

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
  //File _image;
  ImagePicker picker = ImagePicker();
  // String imageUrl = '';
  File image1, image2, image3, image4, image5, image6, nullimage;

  bool isLoggedIn() {
    if (FirebaseAuth.instance.currentUser != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> addData(carData) async {
    if (isLoggedIn()) {
      FirebaseFirestore.instance
          .collection('cars')
          .add(carData)
          .catchError((e) {
        print(e);
      });
    } else {
      print('Please Sign-in');
    }
  }

  Future uploadFile(File image) async {
    final String empty = "Failed to Upload";
    firebase_storage.UploadTask task;
    if (image == null) {
      return empty;
    }
    final fileName = p.basename(image.path);
    final destination = 'files/$fileName';
    task = FirebaseApi.uploadFile(destination, image);

    if (task == null) {
      return empty;
    }
    final snapshot = await task.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    print(urlDownload);
    imageUrlList.add(urlDownload);
  }

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
                  ),
                  ElevatedButton(
                    child: Text('Post Ad'),
                    onPressed: () {
                      uploadFile(image1);
                      uploadFile(image2);
                      print(imageUrlList);
                      /*
                      carMethods carObj;
                      Map<String, dynamic> carData = {
                        'userName': this.Name,
                        'uId': userId,
                        'userEmail': this.Email,
                        'userPhoneNumber': this.Telephone,
                        'userPostcode': this.Postcode,
                        'registration': car.registrationNumber,
                        'make': car.make,
                        'colour': car.colour,
                        'year': car.yearOfManufacture.toString(),
                        'fuelType': car.fuelType,
                        'co2': car.co2Emissions.toString(),
                        'engineCapacity': car.engineCapacity.toString(),
                        'model': this.model,
                        'bodyType': this.bodyType,
                        'gearbox': this.gearbox,
                        'numofDoors': this.NoofDoors,
                        'mileage': this.mileage.toString(),
                        'cat': this.CAT.toString(),
                        'description': this.Description,
                        'price': this.Price.toString(),
                        'time': DateTime.now().toString(),
                      };

                      addData(carData).then((value) {
                        print('Data added');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()));
                      }).catchError((onError) {
                        print(onError);
                      }); */
                      /*carObj.addData(carData).then((value) {
                        print('Data added');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()));
                      }).catchError((onError) {
                        print(onError);
                      }); */
                    },
                  ),
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
                              this.model = val;
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
                              this.bodyType = val;
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
                              this.gearbox = val;
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
                              this.NoofDoors = val;
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
                          onChanged: (value) {
                            this.Postcode = value;
                          },
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
          SizedBox(
            height: 5,
          ),
          Text(
            'Please upload 6 photos of your vechicle',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            width: 330,
            height: 450,
            //color: Colors.purpleAccent,
            //padding: EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 5,
                      ),
                      UserImage(
                        onFileChanged: ((image1) {
                          setState(() {
                            this.image1 = image1;
                          });
                        }),
                      ),
                      SizedBox(
                        width: 100,
                      ),
                      UserImage(
                        onFileChanged: ((image2) {
                          setState(() {
                            this.image2 = image2;
                          });
                        }),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 5,
                      ),
                      UserImage(
                        onFileChanged: ((image3) {
                          setState(() {
                            this.image3 = image3;
                          });
                        }),
                      ),
                      SizedBox(
                        width: 100,
                      ),
                      UserImage(
                        onFileChanged: ((image4) {
                          setState(() {
                            this.image4 = image4;
                          });
                        }),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 5,
                      ),
                      UserImage(
                        onFileChanged: ((image5) {
                          setState(() {
                            this.image5 = image5;
                          });
                        }),
                      ),
                      SizedBox(
                        width: 100,
                      ),
                      UserImage(
                        onFileChanged: ((image6) {
                          setState(() {
                            this.image6 = image6;
                          });
                        }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.height * 0.04,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.green),
              onPressed: () {
                if (_formKeySell.currentState.validate()) {
                  /*if (image1 == nullimage ||
                      image2 == nullimage ||
                      image3 == nullimage ||
                      image4 == nullimage ||
                      image5 == nullimage ||
                      image6 == nullimage) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Missing Images"),
                            content: Text('Please, Upload 6 images'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'OK'),
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        });
                  } else {
                    showView(_reg);
                  } */
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
