import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:wheels_deals/login.dart';
import 'package:wheels_deals/register.dart';

class loginScreen extends StatefulWidget {
  @override
  _loginScreenState createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              flexibleSpace: Container(
                decoration: new BoxDecoration(
                    gradient: new LinearGradient(
                        colors: [Colors.deepPurpleAccent, Colors.purple],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(1.0, 0.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp)),
              ),
              title: Text(
                "Wheels and Deals",
                style: TextStyle(
                    fontSize: 25, color: Colors.white, fontFamily: "Gugi"),
              ),
              centerTitle: true,
              bottom: TabBar(
                tabs: [
                  Tab(
                    icon: Icon(
                      Icons.lock,
                      color: Colors.white,
                    ),
                    text: "Login",
                  ),
                  Tab(
                    icon: Icon(Icons.person, color: Colors.white),
                    text: "Sign up",
                  ),
                ],
                indicatorColor: Colors.white38,
                indicatorWeight: 5,
              ),
            ),
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.deepPurple[50], Colors.purple[100]],
                ),
              ),
              child: TabBarView(
                children: <Widget>[login(), register()],
              ),
            )));
  }
}
