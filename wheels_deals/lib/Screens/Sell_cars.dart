import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wheels_deals/API/CarModels.dart';
import 'package:wheels_deals/API/fetchedCar.dart';
import 'package:wheels_deals/API/firebase_api.dart';
import 'package:wheels_deals/Googlemaps_requests/geocodeRequest.dart';
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
import 'package:wheels_deals/imageSelection/car_image.dart';
import 'package:wheels_deals/imageSelection/user_image.dart';
import 'package:path/path.dart' as p;
import 'package:wheels_deals/DialogBox/loadingDialog.dart';
import 'package:wheels_deals/Widgets/loadingWidget.dart';

class sellCars extends StatefulWidget {
  sellCars({Key key}) : super(key: key);

  @override
  State<sellCars> createState() => _sellCarsState();
}

class _sellCarsState extends State<sellCars> {
  final GlobalKey<FormState> _formKeySell2 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyCarSell2 = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  final _Name = TextEditingController();
  final _Telephone = TextEditingController();
  final _Email = TextEditingController();
  String _reg;
  String Name, Telephone, Email, Postcode;
  double Price, mileage;
  bool CAT = false;
  bool visibility = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  List<String> imageUrlList = [];
  RegExp regExp = new RegExp(
    r'^[a-z]{1,2}\d[a-z\d]?\s*\d[a-z]{2}',
    caseSensitive: false,
  );
  RegExp regExp_Name = new RegExp(r'^([^0-9]*)$', caseSensitive: false);
  RegExp regExp_Email =
      new RegExp(r'^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$', caseSensitive: false);
  RegExp regExp_phonenumber = new RegExp(r'^[0-9]*$', caseSensitive: false);

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
      Description,
      userCreatedTime;
  QuerySnapshot cars;
  //File _image;
  ImagePicker picker = ImagePicker();
  String imageUrl1 = '', imageUrl2 = '', imageUrl3 = '';
  // File image1, image2, image3, nullimage;

  getUserData() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((results) {
      setState(() {
        userImageUrl = results.data()['imgPro'];
        getUserName = results.data()['userName'];
        userCreatedTime = results.data()['time'];
        _Name.text = results.data()['userName'].toString();
        Name = _Name.text;
        _Telephone.text = results.data()['userNumber'].toString();
        Telephone = _Telephone.text;
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

  Future<bool> checkPostcode(String postcode) async {
    final response = await http.get(
        Uri.parse('https://api.postcodes.io/postcodes/$postcode/validate'));
    final data = jsonDecode(response.body);
    bool check = data['result'];
    return check;
  }

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
    imageUrlList.add(urlDownload);
  }

  Future<bool> showView(regPlate) async {
    var car = await getcarsdvla(regPlate);
    List<String> carmodels = carModels().getModels(car.make);
    List<String> body_types = carModels().getBodyTypes();
    List<String> gearbox_types = ['GearBox', 'Automatic', 'Manual'];
    List<String> seat_options = ['Number of Doors', '3 Door', '5 Door'];
    bool validPostcode = true;
    String location = "";
    List latlng;
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                backgroundColor: Color.fromARGB(255, 240, 240, 240),
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
                      imageUrlList = [];
                    },
                  ),
                  ElevatedButton(
                    child: Text('Post Ad'),
                    onPressed: () async {
                      validPostcode = await checkPostcode(this.Postcode);

                      String eurostatus = "", taxdue = "", motExpiry = "";

                      if (car.euroStatus != null) {
                        eurostatus = car.euroStatus;
                      } else if (car.fuelType == 'ELECTRICITY') {
                        eurostatus = "Elec";
                      } else {
                        eurostatus = "";
                      }
                      if (car.motExpiry != null) {
                        motExpiry = car.motExpiry;
                      } else {
                        motExpiry = "No Records";
                      }

                      if (car.taxStatus == 'SORN') {
                        taxdue = "";
                      } else {
                        taxdue = car.taxDueDate;
                      }
                      if (_formKeyCarSell2.currentState.validate()) {
                        location = await geocodeRequest
                            .geolocationPostcodetoCity(this.Postcode);
                        latlng = await geocodeRequest
                            .geolocationPostcodetolatlng(this.Postcode);
                        print('Validation complete');
                        Map<String, dynamic> carData = {
                          'userName': this.Name,
                          'uId': userId,
                          'imgPro': userImageUrl,
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
                          'imageURls': imageUrlList,
                          'taxStatus': car.taxStatus,
                          'taxDueDate': taxdue,
                          'motStatus': car.motStatus,
                          'motExpiry': motExpiry,
                          'euroStatus': eurostatus,
                          'time': DateTime.now().toString(),
                          'userCreatedTime': userCreatedTime,
                          'location': location,
                          'latlng': latlng
                        };

                        addData(carData).then((value) {
                          print('Data added');
                          imageUrlList = [];
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()));
                        }).catchError((onError) {
                          print(onError);
                        });
                      }
                    },
                  ),
                ],
                content: SingleChildScrollView(
                  child: Form(
                      key: _formKeyCarSell2,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
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
                          car.taxStatus == 'SORN'
                              ? Text(
                                  'Tax Due Date: ' + 'N/A',
                                  textAlign: TextAlign.left,
                                )
                              : Text(
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
                          DropdownButtonFormField<String>(
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
                            decoration:
                                InputDecoration(hintText: 'Mileage (Miles)'),
                            onChanged: (value) {
                              this.mileage = double.parse(value.trim());
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
                            decoration:
                                InputDecoration(hintText: 'Description of Ad'),
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            onChanged: (value) {
                              this.Description = value;
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
                            decoration:
                                InputDecoration(hintText: 'Asking Price £'),
                            onChanged: (value) {
                              this.Price = double.parse(value.trim());
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
                            controller: _Name,
                            decoration: InputDecoration(hintText: 'Name'),
                            onChanged: (value) {
                              this.Name = value.trim();
                            },
                            validator: (value) {
                              if (value.trim() == null || value.isEmpty) {
                                return 'Please enter a name';
                              }
                              if (!regExp_Name.hasMatch(value.trim())) {
                                return 'Invalid Name Format';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.name,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            controller: _Email,
                            decoration:
                                InputDecoration(hintText: 'Email Address'),
                            onChanged: (value) {
                              this.Email = value.trim();
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
                              this.Telephone = value.trim();
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
                            decoration: InputDecoration(
                              hintText: 'Vechicle Location (PostCode)',
                            ),
                            onChanged: (value) {
                              this.Postcode = value.trim();
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

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser.uid;
    userEmail = FirebaseAuth.instance.currentUser.email;
    _Email.text = userEmail.toString();
    Email = _Email.text;
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
            child: Container(
              alignment: Alignment.center,
              height: 250,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: Color.fromARGB(255, 239, 207, 243)),
              child: Column(
                children: [
                  SizedBox(
                    height: 5,
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
                    height: 25,
                  ),
                  Container(
                    width: 200,
                    height: 90,
                    child: Form(
                        key: _formKeySell2,
                        child: Column(
                          //mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextFormField(
                              decoration: InputDecoration(
                                  labelText: 'Registration Plate'),
                              onChanged: (String value) {
                                _reg = value.toUpperCase().trim();
                              },
                              style: TextStyle(fontSize: 20),
                              validator: (value) {
                                if (value.trim() == null ||
                                    value.trim().isEmpty ||
                                    value.trim().length > 7) {
                                  return 'Please enter a valid Registration Number';
                                }
                                return null;
                              },
                            ),
                          ],
                        )),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                    width: 150,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKeySell2.currentState.validate()) {
                          if (!imageUrl1.isEmpty) {
                            imageUrlList.add(imageUrl1);
                          } else if (!imageUrl2.isEmpty) {
                            imageUrlList.add(imageUrl2);
                          } else if (!imageUrl3.isEmpty) {
                            imageUrlList.add(imageUrl3);
                          } else {
                            print('no images');
                          }
                          if (imageUrlList.isNotEmpty) {
                            showView(_reg);
                          } else {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                      title: Text("Missing Images"),
                                      content: Text(
                                          'Please, Upload at least 1 image'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'OK'),
                                          child: const Text('OK'),
                                        )
                                      ]);
                                });
                          }
                        }
                      },
                      child: Text(
                        'Find Car',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: Color.fromARGB(255, 240, 239, 240)),
              child: Column(
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Please upload upto 3 photos of your vechicle',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width * 5,
                      height: 300,
                      child: Scrollbar(
                        controller: _scrollController,
                        thickness: 8,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          controller: _scrollController,
                          children: [
                            Container(
                              height: 200,
                              width: 200,
                              child: carImage(
                                onFileChanged: ((image) {
                                  setState(() {
                                    this.imageUrl1 = image;
                                  });
                                }),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              height: 200,
                              width: 200,
                              child: carImage(
                                onFileChanged: ((image2) {
                                  setState(() {
                                    this.imageUrl2 = image2;
                                  });
                                }),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              height: 200,
                              width: 200,
                              child: carImage(
                                onFileChanged: ((image3) {
                                  setState(() {
                                    this.imageUrl3 = image3;
                                  });
                                }),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
