import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wheels_deals/loginScreen.dart';

class splashScreen extends StatefulWidget {
  //const splashScreen({Key? key}) : super(key: key);
  @override
  _splashScreenState createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  startTimer() {
    Timer(Duration(seconds: 4), () async {
      Route newRoute = MaterialPageRoute(builder: (context) => loginScreen());
      Navigator.pushReplacement(context, newRoute);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
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
            ],
          ),
        ),
      ),
    );
  }
}
