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

import '../imageSelection/profile_update_image.dart';
import 'package:wheels_deals/Screens/loginScreen.dart';
import '../presentation/my_flutter_app_icons.dart';

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
  final GlobalKey<FormState> _formKeyUpdateUser = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyDeleteUser = GlobalKey<FormState>();
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
    int mileage = DBdata['mileage'], Price = DBdata['price'];
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

    bool Sold = DBdata['sold'];

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
                          'mileage': mileage,
                          'cat': CAT.toString(),
                          'description': Description,
                          'price': Price,
                          'location': location,
                          'latlng': latlng,
                          'sold': Sold
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
                              mileage = int.parse(value.trim());
                            },
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value.trim() == null || value.isEmpty) {
                                return 'Mileage cannot be empty';
                              }

                              if (int.parse(value.trim()) > 200000) {
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
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                'Sold ?     ',
                              ),
                              CupertinoSwitch(
                                  value: Sold,
                                  activeColor: Colors.deepPurple,
                                  onChanged: (bool value) {
                                    setState((() {
                                      Sold = value;
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
                              Price = int.parse(value.trim());
                            },
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value.trim() == null || value.isEmpty) {
                                return 'Please enter a price £';
                              }

                              if (int.parse(value.trim()) <= 99) {
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

  Future showDialogForUpdateUser(data, docID) async {
    String imgUrl = data['imgPro'];
    final _name = TextEditingController();
    _name.text = data['userName'];
    final _phoneNumber = TextEditingController();
    _phoneNumber.text = data['userNumber'];

    final _email = TextEditingController();
    _email.text = FirebaseAuth.instance.currentUser.email;
    String email = '';
    String password = '', newPassword;

    String userName = data['userName'], userNumber = data['userNumber'];
    String newEmail = userEmail;

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Edit Your Account Details",
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
                child: Text('Update Details'),
                onPressed: () async {
                  CollectionReference users =
                      FirebaseFirestore.instance.collection('users');
                  if (_formKeyUpdateUser.currentState.validate()) {
                    AuthCredential credential = EmailAuthProvider.credential(
                        email: email, password: password);
                    await FirebaseAuth.instance.currentUser
                        .reauthenticateWithCredential(credential)
                        .catchError((e) {
                      print(e);
                    });
                    Map<String, dynamic> userData = {
                      'userName': userName,
                      'userNumber': userNumber,
                      'imgPro': imgUrl
                    };
                    users.doc(userId).update(userData).then((value) {
                      print('users updated');
                      Navigator.pop(context);
                    }).catchError((e) {
                      print(e);
                    });
                    await FirebaseAuth.instance.currentUser
                        .updateEmail(newEmail)
                        .then((value) => print('Email changed'))
                        .catchError((e) {
                      print(e);
                    });

                    await FirebaseAuth.instance.currentUser
                        .updatePassword(newPassword)
                        .then((value) => print('Password updated'))
                        .catchError((e) => print(e));
                  }
                },
              ),
            ],
            content: SingleChildScrollView(
              child: Form(
                  key: _formKeyUpdateUser,
                  child: Column(
                    children: [
                      ProfileUpdateImage(
                        initialUrl: imgUrl,
                        onFileChanged: ((imageUrl) {
                          setState(() {
                            imgUrl = imageUrl;
                          });
                        }),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _name,
                        decoration: InputDecoration(hintText: 'Your Name'),
                        onChanged: (value) {
                          userName = value.trim();
                        },
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value.trim() == null || value.isEmpty) {
                            return 'Name cannot be empty';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _phoneNumber,
                        decoration:
                            InputDecoration(hintText: 'Your Phone Number'),
                        onChanged: (value) {
                          userNumber = value.trim();
                        },
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value.trim() == null || value.isEmpty) {
                            return 'Number cannot be empty';
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
                        height: 10,
                      ),
                      TextFormField(
                        controller: _email,
                        decoration: InputDecoration(hintText: 'Email Address'),
                        onChanged: (value) {
                          newEmail = value.trim();
                        },
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value.trim() == null || value.isEmpty) {
                            return 'Email cannot be empty';
                          }
                          if (!regExp_Email.hasMatch(value.trim())) {
                            return 'Invalid Email format';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration: InputDecoration(hintText: 'New Password'),
                        onChanged: (value) {
                          newPassword = value.trim();
                        },
                        obscureText: true,
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                          'Changes require you to reauthenticate, please enter your email and password below'),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration:
                            InputDecoration(hintText: 'Previous Email Address'),
                        onChanged: (value) {
                          email = value.trim();
                        },
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value.trim() == null || value.isEmpty) {
                            return 'Email cannot be empty';
                          }
                          if (!regExp_Email.hasMatch(value.trim())) {
                            return 'Invalid Email format';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration:
                            InputDecoration(hintText: 'Previous Password'),
                        onChanged: (value) {
                          password = value.trim();
                        },
                        obscureText: true,
                        validator: (value) {
                          if (value.trim() == null || value.isEmpty) {
                            return 'Password cannot be empty';
                          }
                          return null;
                        },
                      ),
                    ],
                  )),
            ),
          );
        });
  }

  Future showDialogToDelete(data, DocID) async {
    CollectionReference cars = FirebaseFirestore.instance.collection('cars');
    CollectionReference users = FirebaseFirestore.instance.collection('users');
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
                  onPressed: () async {
                    await users.get().then((value) {
                      value.docs.forEach((doc) async {
                        await users
                            .doc(doc.id)
                            .collection('Saved')
                            .doc(DocID)
                            .delete()
                            .then((value) => print('deleted'));
                      });
                    });
                    await cars
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

  Future showDialogToDeleteUser(data, DocID) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    CollectionReference cars = FirebaseFirestore.instance.collection('cars');
    String email = userEmail;
    String password = '';

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Delete Account?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            content: Form(
                key: _formKeyDeleteUser,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Please Enter your login details below'),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      decoration: InputDecoration(hintText: 'Login Email'),
                      onChanged: (value) {
                        email = value;
                      },
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value.trim() == null || value.isEmpty) {
                          return 'Email cannot be empty';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(hintText: 'Password'),
                      onChanged: (value) {
                        password = value;
                      },
                      obscureText: true,
                      validator: (value) {
                        if (value.trim() == null || value.isEmpty) {
                          return 'Password cannot be empty';
                        }
                        return null;
                      },
                    ),
                  ],
                )),
            actions: [
              SizedBox(
                width: 10,
              ),
              ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(FontAwesomeIcons.faceSmileBeam),
                  label: Text('Cancel')),
              SizedBox(
                width: 10,
              ),
              ElevatedButton.icon(
                  onPressed: () async {
                    if (_formKeyDeleteUser.currentState.validate()) {
                      AuthCredential credential = EmailAuthProvider.credential(
                          email: email, password: password);
                      await FirebaseAuth.instance.currentUser
                          .reauthenticateWithCredential(credential)
                          .then((value) => print('Re authenticated'))
                          .catchError((e) {
                        print(e);
                      });
                      try {
                        await FirebaseAuth.instance.currentUser.delete();
                        cars
                            .where('uId', isEqualTo: userId)
                            .get()
                            .then((value) async {
                          for (DocumentSnapshot docsnap in value.docs) {
                            await docsnap.reference.delete();
                          }
                        });
                        users.doc(userId).delete().then((value) async {
                          Navigator.pop(context);
                          await FirebaseAuth.instance.signOut();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => loginScreen()));
                        }).catchError((error) => print(error));
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'requires-recent-login') {
                          print(
                              'The user must reauthenticate before this operation can be executed.');
                        }
                      }
                    }
                  },
                  icon: Icon(FontAwesomeIcons.faceSadTear),
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
                height: 40,
                alignment: Alignment.center,
                child: ElevatedButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut().then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => loginScreen()));
                        //loginScreen();
                      });
                    },
                    child: Text('Sign out'))),
            Padding(
              padding: EdgeInsets.only(left: 5, right: 5),
              child: Text(
                'Account Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                child: FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(userId)
                        .get(),
                    builder: (con, snap) {
                      if (snap.hasData) {
                        Map<String, dynamic> data = snap.data.data();

                        return Padding(
                          padding: EdgeInsets.only(top: 10, left: 10, right: 5),
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
                                    onTap: () {},
                                    child: Container(
                                      width: 50,
                                      height: 50,
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
                                      onTap: () {},
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
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
                                                data['userNumber']
                                                    .toString()
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                    color: Colors.black
                                                        .withOpacity(0.6)),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Icon(
                                                FontAwesomeIcons.envelope,
                                                size: 20,
                                                color: Colors.black54,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                userEmail,
                                                style: TextStyle(
                                                    color: Colors.black
                                                        .withOpacity(0.6)),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              IconButton(
                                                  onPressed: () async {
                                                    showDialogForUpdateUser(
                                                        data, userId);
                                                  },
                                                  icon: Icon(
                                                    FontAwesomeIcons.userPen,
                                                    size: 20,
                                                    color: Colors.deepPurple,
                                                  )),
                                              /*Padding(
                                                padding:
                                                    EdgeInsets.only(left: 3),
                                                child: Text('Edit Details'),
                                              ), */
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 15),
                                                child: IconButton(
                                                  onPressed: () async {
                                                    showDialogToDeleteUser(
                                                        data, userId);
                                                  },
                                                  icon: Icon(
                                                    FontAwesomeIcons.userXmark,
                                                    size: 20,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                              /*Padding(
                                                padding:
                                                    EdgeInsets.only(left: 3),
                                                child: Text('Delete Account'),
                                              ), */
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
                        );
                      }
                      return Center(child: CircularProgressIndicator());
                    })),
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
              height: MediaQuery.of(context).size.height * 0.45,
              width: MediaQuery.of(context).size.width * 0.9,
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
                        int price = data['price'];
                        int mileage = data['mileage'];
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
                                          FontAwesomeIcons.penToSquare,
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
                                      SizedBox(
                                        width: 20,
                                      ),
                                      data['sold']
                                          ? Icon(MyFlutterApp.sold_solid,
                                              size: 30, color: Colors.red)
                                          : Icon(
                                              FontAwesomeIcons.rectangleAd,
                                              color: Colors.deepPurple,
                                            )
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
                                              child: Text(
                                                  data['year'].toString())),
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
