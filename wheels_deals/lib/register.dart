import 'package:flutter/material.dart';
import 'package:wheels_deals/DialogBox/errorDialogbox.dart';
import 'package:wheels_deals/Screens/HomeScreen.dart';
import 'package:wheels_deals/Widgets/customTextField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wheels_deals/globalVariables.dart';
import 'package:wheels_deals/imageSelection/profile_image.dart';
import 'package:wheels_deals/imageSelection/user_image.dart';
import 'dart:io';

class register extends StatefulWidget {
  @override
  State<register> createState() => _registerState();
}

class _registerState extends State<register> {
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _phoneConfirmController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String imageUrl = '';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset(
                  'images/mainLogo.png',
                  height: 180.0,
                ),
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ProfileImage(
                  onFileChanged: ((imageUrl) {
                    setState(() {
                      this.imageUrl = imageUrl;
                    });
                  }),
                ),
              ),
            ),
            SizedBox(height: 8),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  CustomTextField(
                    data: Icons.person,
                    controller: _nameController,
                    hintText: 'Name',
                    isObsecure: false,
                  ),
                  CustomTextField(
                    data: Icons.email,
                    controller: _emailController,
                    hintText: 'Email',
                    isObsecure: false,
                  ),
                  CustomTextField(
                    data: Icons.phone_android,
                    controller: _phoneConfirmController,
                    hintText: 'Phone number',
                    isObsecure: false,
                  ),
                  CustomTextField(
                    data: Icons.lock_outline_rounded,
                    controller: _passwordController,
                    hintText: 'Password',
                    isObsecure: true,
                  ),
                  CustomTextField(
                    data: Icons.lock,
                    controller: _confirmPasswordController,
                    hintText: 'Re-enter Password',
                    isObsecure: true,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.05,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.deepPurple),
                onPressed: () {
                  _register();
                },
                child: Text(
                  'Sign Up',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  void saveUserData() {
    Map<String, dynamic> userData = {
      'userName': _nameController.text.trim(),
      'uId': userId,
      'userNumber': _phoneConfirmController.text.trim(),
      'imgPro': imageUrl,
      'time': DateTime.now()
    };

    FirebaseFirestore.instance.collection('users').doc(userId).set(userData);
  }

  void _register() async {
    User currentUser;
    await _auth
        .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _confirmPasswordController.text.trim())
        .then((auth) {
      currentUser = auth.user;
      userId = currentUser.uid;
      userEmail = currentUser.email;
      getUserName = _nameController.text.trim();
      saveUserData();
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (con) {
            return ErrorAlertDialog(
              message: error.message.toString(),
            );
          });
    });

    if (currentUser != null) {
      Route newRoute = MaterialPageRoute(builder: (context) => HomeScreen());
      Navigator.pushReplacement(context, newRoute);
    }
  }
}
