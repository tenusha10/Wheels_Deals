import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wheels_deals/Screens/HomeScreen.dart';
import 'package:wheels_deals/Screens/loginScreen.dart';

import '../API/LocalAuthApi.dart';

class auth_screen extends StatefulWidget {
  @override
  State<auth_screen> createState() => _auth_screenState();
}

class _auth_screenState extends State<auth_screen> {
  Future<bool> showView() async {
    final isAuthenticated = await LocalAuthApi.authenticate();
    return isAuthenticated;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
              colors: [
                Colors.deepPurpleAccent,
                Colors.indigoAccent,
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('images/mainLogo.png'),
              SizedBox(
                height: 20.0,
              ),
              ElevatedButton.icon(
                  onPressed: () async {
                    final auth = await showView();
                    if (auth == true) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    } else {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => loginScreen()),
                      );
                    }
                  },
                  icon: Icon(FontAwesomeIcons.fingerprint),
                  label: Text('Authenticate')),
            ],
          ),
        ),
      ),
    );
  }
}
