import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wheels_deals/Screens/AccountScreen.dart';
import 'package:wheels_deals/Screens/AdPage.dart';
import 'package:wheels_deals/Screens/Search_cars.dart';
import 'package:wheels_deals/Screens/Sell_cars.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final screens = [
    AdPage(),
    SearchCars(),
    sellCars(),
    Center(
      child: Text('Saved'),
    ),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          style: GoogleFonts.patrickHand(
            fontSize: 30,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: 'Home',
              backgroundColor: Colors.deepPurple),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.search_rounded,
              ),
              label: 'Search',
              backgroundColor: Colors.orangeAccent),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.car_rental,
              ),
              label: 'Sell',
              backgroundColor: Colors.green),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite_rounded,
              ),
              label: 'Saved',
              backgroundColor: Colors.red),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person_rounded,
              ),
              label: 'Account',
              backgroundColor: Colors.purple),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        iconSize: 30,
        showUnselectedLabels: true,
        selectedFontSize: 18,
        unselectedFontSize: 16,
        selectedItemColor: Colors.white,
      ),
    );
  }
}
