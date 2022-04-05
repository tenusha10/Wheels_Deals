import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:wheels_deals/DialogBox/errorDialogbox.dart';
import 'package:wheels_deals/DialogBox/loadingDialog.dart';
import 'package:wheels_deals/Screens/HomeScreen.dart';
import 'package:wheels_deals/Screens/forgotPassword.dart';
import 'package:wheels_deals/Widgets/customTextField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class login extends StatefulWidget {
  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
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
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  CustomTextField(
                    data: Icons.person,
                    controller: _emailController,
                    hintText: 'Email',
                    isObsecure: false,
                  ),
                  CustomTextField(
                    data: Icons.lock,
                    controller: _passwordController,
                    hintText: 'Password',
                    isObsecure: true,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.05,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.deepPurple),
                onPressed: () {
                  if (_emailController.text.isNotEmpty &&
                      _passwordController.text.isNotEmpty) {
                    _login();
                  } else {
                    showDialog(
                        context: context,
                        builder: (con) {
                          return ErrorAlertDialog(
                            message: 'Email or Password cannot be empty!',
                          );
                        });
                  }
                },
                child: Text(
                  'Sign-in',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            GestureDetector(
              child: Text(
                'Forgot Password ?',
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.deepPurple,
                    fontSize: 18),
              ),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ForgotPassword()));
              },
            )
          ],
        ),
      ),
    );
  }

  void _login() async {
    showDialog(
        context: context,
        builder: (con) {
          return loadingAlertDialog(
            message: 'Please Wait!',
          );
        });
    User currentUser;

    await _auth
        .signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    )
        .then((auth) {
      currentUser = auth.user;
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
      Navigator.pop(context);
      Route newRoute = MaterialPageRoute(builder: (context) => HomeScreen());
      Navigator.pushReplacement(context, newRoute);
    } else {
      print('Error Occured !');
    }
  }
}
