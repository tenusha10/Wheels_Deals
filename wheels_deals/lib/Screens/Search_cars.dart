import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wheels_deals/API/CarModels.dart';

import 'package:wheels_deals/Screens/search_view.dart';

class SearchCars extends StatefulWidget {
  @override
  State<SearchCars> createState() => _SearchCarsState();
}

class _SearchCarsState extends State<SearchCars> {
  final GlobalKey<FormState> _formSearchCars = GlobalKey<FormState>();

  String Make;
  String Model,
      Colour,
      BodyType,
      Gearbox,
      FuelType,
      co2,
      co2CPY,
      numofDoors,
      engineCapacity,
      taxStatus,
      motStatus,
      CAT,
      ulez;

  String minYear,
      maxYear,
      minPrice,
      maxPrice,
      minMileage,
      maxMileage,
      minEngineCapacity,
      minEngineCapacityCPY,
      maxEngineCapacityCPY,
      maxEngineCapacity;
  var yearRange = RangeValues(1999, 1999);
  List<String> makeList = carModels().getMakes();
  List<String> modelList = [];
  List<String> colourList = [
    'Black',
    'White',
    'Grey',
    'Silver',
    'Blue',
    'Red',
    'Green',
    'Yellow',
    'Beige',
    'Brown',
    'Purple',
    'Gold',
    'Orange'
  ];
  List<String> engineList = ['>1L', '1L', '1.5L', '2L', '3L', '4L', '5L', '6L'];
  List<String> gearboxList = ['Automatic', 'Manual'];
  List<String> bodyTypeList = carModels().getBodyTypes();
  List<String> numofDoorsList = ['3 Doors', '5 Doors'];
  List<String> co2List = ['>99g', '>150g', '>200g'];
  List<String> fuelList = [
    'Petrol',
    'Diesel',
    'Hybrid Electric',
    'Electricity'
  ];
  List<String> taxList = [
    'Taxed',
    'Untaxed',
    'SORN',
  ];
  List<String> motList = [
    'Valid',
    'Not valid',
  ];
  List<String> catList = [
    'Declared',
    'Not Declared',
  ];
  List<String> ulezList = [
    'Compatible',
    'Not Compatible',
  ];
  List<String> priceList = [
    '500',
    '1000',
    '1500',
    '2000',
    '2500',
    '3000',
    '3500',
    '4000',
    '4500',
    '5000',
    '10000',
    '15000',
    '20000',
    '25000',
    '30000',
    '35000',
    '40000',
    '45000',
    '50000',
    '55000',
    '60000',
    '65000',
    '70000',
    '75000',
    '80000',
    '85000',
    '90000',
    '95000',
    '100000',
    '150000',
    '200000'
  ];
  List<String> mileageList = [
    '1000',
    '5000',
    '10000',
    '15000',
    '20000',
    '25000',
    '30000',
    '35000',
    '40000',
    '45000',
    '50000',
    '55000',
    '60000',
    '65000',
    '70000',
    '75000',
    '80000',
    '85000',
    '90000',
    '95000',
    '100000',
    '150000',
    '200000'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.purpleAccent,
                Colors.deepPurple,
                //Colors.amberAccent
              ],
            ),
          ),
          child: Stack(alignment: Alignment.center, children: [
            Container(
              //padding: EdgeInsets.only(top: 20, left: 15, right: 15),
              height: MediaQuery.of(context).size.height * 0.75,
              width: MediaQuery.of(context).size.width * 0.95,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  border: Border.all(color: Colors.black, width: 2),
                  color: Color.fromARGB(255, 240, 239, 240)),
              child: SingleChildScrollView(
                padding: EdgeInsets.only(top: 20, left: 15, right: 15),
                child: Form(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Search Cars for Sale',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 5, left: 5),
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  Make = null;
                                  Model = null;
                                  Colour = null;
                                  minPrice = null;
                                  maxPrice = null;
                                  minMileage = null;
                                  maxMileage = null;
                                  minEngineCapacity = null;
                                  minEngineCapacityCPY = null;
                                  maxEngineCapacityCPY = null;
                                  maxEngineCapacity = null;
                                  Gearbox = null;
                                  BodyType = null;
                                  numofDoors = null;
                                  co2 = null;
                                  co2CPY = null;
                                  FuelType = null;
                                  taxStatus = null;
                                  motStatus = null;
                                  CAT = null;
                                  ulez = null;
                                  minYear = null;
                                  maxYear = null;
                                  yearRange = RangeValues(1999, 1999);
                                });
                              },
                              tooltip: 'Reset',
                              icon: Icon(
                                FontAwesomeIcons.arrowRotateLeft,
                                color: Colors.black,
                              ),
                              iconSize: 20,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          iconSize: 25,
                          style: GoogleFonts.roboto(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          value: Make,
                          hint: Text(
                            'Manufacturer',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          isExpanded: true,
                          onChanged: (String val) {
                            setState(() {
                              this.Model = null;
                              this.Make = val;
                              modelList = carModels().getModels(val);
                            });
                          },
                          items: makeList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      )),
                      Divider(
                        color: Colors.black45,
                        thickness: 1,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: DropdownButtonFormField<String>(
                          iconSize: 25,
                          style: GoogleFonts.roboto(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          value: Model,
                          hint: Text(
                            'Model',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          isExpanded: true,
                          onChanged: (String val) {
                            setState(() {
                              this.Model = val;
                            });
                          },
                          items: modelList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        child: DropdownButtonFormField<String>(
                          iconSize: 25,
                          style: GoogleFonts.roboto(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          value: Colour,
                          hint: Text(
                            'Colour',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          isExpanded: true,
                          onChanged: (String val) {
                            setState(() {
                              this.Colour = val;
                            });
                          },
                          items: colourList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Text(
                            'Price £',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20, right: 5),
                            child: Container(
                                width: 100,
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    iconSize: 25,
                                    style: GoogleFonts.roboto(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                    value: minPrice,
                                    hint: Text(
                                      'Min',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    isExpanded: false,
                                    onChanged: (String val) {
                                      setState(() {
                                        this.minPrice = val;
                                      });
                                    },
                                    items: priceList
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                )),
                          ),
                          Padding(
                              padding: EdgeInsets.only(left: 30, right: 5),
                              child: Container(
                                width: 100,
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    iconSize: 25,
                                    style: GoogleFonts.roboto(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                    value: maxPrice,
                                    hint: Text(
                                      'Max',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    isExpanded: true,
                                    onChanged: (String val) {
                                      setState(() {
                                        this.maxPrice = val;
                                      });
                                    },
                                    items: priceList
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ))
                        ],
                      ),
                      Divider(
                        color: Colors.black45,
                        thickness: 1,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Text(
                            'Mileage',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 13, right: 5),
                            child: Container(
                                width: 100,
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    iconSize: 25,
                                    style: GoogleFonts.roboto(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                    value: minMileage,
                                    hint: Text(
                                      'Min',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    isExpanded: false,
                                    onChanged: (String val) {
                                      setState(() {
                                        this.minMileage = val;
                                      });
                                    },
                                    items: mileageList
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                )),
                          ),
                          Padding(
                              padding: EdgeInsets.only(left: 30, right: 5),
                              child: Container(
                                width: 100,
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    iconSize: 25,
                                    style: GoogleFonts.roboto(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                    value: maxMileage,
                                    hint: Text(
                                      'Max',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    isExpanded: true,
                                    onChanged: (String val) {
                                      setState(() {
                                        this.maxMileage = val;
                                      });
                                    },
                                    items: mileageList
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ))
                        ],
                      ),
                      Divider(
                        color: Colors.black45,
                        thickness: 1,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Text(
                            'Engine',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 23, right: 5),
                            child: Container(
                                width: 100,
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    iconSize: 25,
                                    style: GoogleFonts.roboto(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                    value: minEngineCapacity,
                                    hint: Text(
                                      'Min',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    isExpanded: false,
                                    onChanged: (String val) {
                                      setState(() {
                                        this.minEngineCapacity = val;
                                      });
                                    },
                                    items: engineList
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                )),
                          ),
                          Padding(
                              padding: EdgeInsets.only(left: 30, right: 5),
                              child: Container(
                                width: 100,
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    iconSize: 25,
                                    style: GoogleFonts.roboto(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                    value: maxEngineCapacity,
                                    hint: Text(
                                      'Max',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    isExpanded: true,
                                    onChanged: (String val) {
                                      setState(() {
                                        this.maxEngineCapacity = val;
                                      });
                                    },
                                    items: engineList
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ))
                        ],
                      ),
                      Divider(
                        color: Colors.black45,
                        thickness: 1,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Text(
                            'Year Range',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width * 0.62,
                            child: RangeSlider(
                              values: yearRange,
                              onChanged: (RangeValues newRange) {
                                setState(() {
                                  yearRange = newRange;
                                  this.minYear =
                                      yearRange.start.round().toString();
                                  this.maxYear =
                                      yearRange.end.round().toString();
                                });
                              },
                              min: 1999,
                              max: 2022,
                              divisions: 23,
                              labels: RangeLabels(
                                  yearRange.start.round().toString(),
                                  yearRange.end.round().toString()),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        color: Colors.black45,
                        thickness: 1,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        child: DropdownButtonFormField<String>(
                          iconSize: 25,
                          style: GoogleFonts.roboto(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          value: Gearbox,
                          hint: Text(
                            'Gearbox',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          isExpanded: true,
                          onChanged: (String val) {
                            setState(() {
                              this.Gearbox = val;
                            });
                          },
                          items: gearboxList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        child: DropdownButtonFormField<String>(
                          iconSize: 25,
                          style: GoogleFonts.roboto(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          value: BodyType,
                          hint: Text(
                            'Body Type',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          isExpanded: true,
                          onChanged: (String val) {
                            setState(() {
                              this.BodyType = val;
                            });
                          },
                          items: bodyTypeList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        child: DropdownButtonFormField<String>(
                          iconSize: 25,
                          style: GoogleFonts.roboto(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          value: numofDoors,
                          hint: Text(
                            'Number of Doors',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          isExpanded: true,
                          onChanged: (String val) {
                            setState(() {
                              this.numofDoors = val;
                            });
                          },
                          items: numofDoorsList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        child: DropdownButtonFormField<String>(
                          iconSize: 25,
                          style: GoogleFonts.roboto(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          value: co2,
                          hint: Text(
                            'C02',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          isExpanded: true,
                          onChanged: (String val) {
                            setState(() {
                              this.co2 = val;
                            });
                          },
                          items: co2List
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        child: DropdownButtonFormField<String>(
                          iconSize: 25,
                          style: GoogleFonts.roboto(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          value: FuelType,
                          hint: Text(
                            'Fuel Type',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          isExpanded: true,
                          onChanged: (String val) {
                            setState(() {
                              this.FuelType = val;
                            });
                          },
                          items: fuelList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        child: DropdownButtonFormField<String>(
                          iconSize: 25,
                          style: GoogleFonts.roboto(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          value: taxStatus,
                          hint: Text(
                            'Tax Status',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          isExpanded: true,
                          onChanged: (String val) {
                            setState(() {
                              this.taxStatus = val;
                            });
                          },
                          items: taxList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        child: DropdownButtonFormField<String>(
                          iconSize: 25,
                          style: GoogleFonts.roboto(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          value: motStatus,
                          hint: Text(
                            'MOT Status',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          isExpanded: true,
                          onChanged: (String val) {
                            setState(() {
                              this.motStatus = val;
                            });
                          },
                          items: motList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        child: DropdownButtonFormField<String>(
                          iconSize: 25,
                          style: GoogleFonts.roboto(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          value: CAT,
                          hint: Text(
                            'CAT (S/N) Status',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          isExpanded: true,
                          onChanged: (String val) {
                            setState(() {
                              this.CAT = val;
                            });
                          },
                          items: catList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        child: DropdownButtonFormField<String>(
                          iconSize: 25,
                          style: GoogleFonts.roboto(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          value: ulez,
                          hint: Text(
                            'Ultra Low Emission Zone Compliant',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          isExpanded: true,
                          onChanged: (String val) {
                            setState(() {
                              this.ulez = val;
                            });
                          },
                          items: ulezList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.indigo),
                                onPressed: () {
                                  bool pValid = false,
                                      mValid = false,
                                      eValid = false;
                                  //validation goes here
                                  if ((minPrice != null && maxPrice == null) ||
                                      (minPrice == null && maxPrice != null)) {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                              title: Text(" Error"),
                                              content: Text(
                                                  'Both Min and Max Required for Price'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, 'OK'),
                                                  child: const Text('OK'),
                                                )
                                              ]);
                                        });
                                  } else if (minPrice != null &&
                                      maxPrice != null) {
                                    if (int.parse(minPrice) >=
                                        int.parse(maxPrice)) {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                                title: Text("Validation Error"),
                                                content: Text(
                                                    'Min and Max cannot be equal ! \nMin cannot be higher than Max'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context, 'OK'),
                                                    child: const Text('OK'),
                                                  )
                                                ]);
                                          });
                                    } else {
                                      pValid = true;
                                    }
                                  } else {
                                    pValid = true;
                                  }

                                  if ((minMileage != null &&
                                          maxMileage == null) ||
                                      (minMileage == null &&
                                          maxMileage != null)) {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                              title: Text(" Error"),
                                              content: Text(
                                                  'Both Min and Max Required for Mileage'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, 'OK'),
                                                  child: const Text('OK'),
                                                )
                                              ]);
                                        });
                                  } else if (minMileage != null &&
                                      maxMileage != null) {
                                    if (int.parse(minMileage) >=
                                        int.parse(maxMileage)) {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                                title: Text("Validation Error"),
                                                content: Text(
                                                    'Min and Max cannot be equal ! \nMin cannot be higher than Max'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context, 'OK'),
                                                    child: const Text('OK'),
                                                  )
                                                ]);
                                          });
                                    } else {
                                      mValid = true;
                                    }
                                  } else {
                                    mValid = true;
                                  }

                                  if ((minEngineCapacity != null &&
                                          maxEngineCapacity == null) ||
                                      (minEngineCapacity == null &&
                                          maxEngineCapacity != null)) {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                              title: Text(" Error"),
                                              content: Text(
                                                  'Both Min and Max Required for Engine Capacity'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, 'OK'),
                                                  child: const Text('OK'),
                                                )
                                              ]);
                                        });
                                  } else if (minEngineCapacity != null &&
                                      maxEngineCapacity != null) {
                                    minEngineCapacityCPY = carModels()
                                        .getEngineCapacity(minEngineCapacity)
                                        .toString();

                                    maxEngineCapacityCPY = carModels()
                                        .getEngineCapacity(maxEngineCapacity)
                                        .toString();

                                    if (int.parse(minEngineCapacityCPY) >=
                                        int.parse(maxEngineCapacityCPY)) {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                                title: Text("Validation Error"),
                                                content: Text(
                                                    'Min and Max cannot be equal ! \nMin cannot be higher than Max'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context, 'OK'),
                                                    child: const Text('OK'),
                                                  )
                                                ]);
                                          });
                                    } else {
                                      eValid = true;
                                    }
                                  } else {
                                    eValid = true;
                                  }

                                  if (pValid == true &&
                                      mValid == true &&
                                      eValid == true) {
                                    Stream<QuerySnapshot> res =
                                        buildsearchQuery(
                                            Make,
                                            Model,
                                            Colour,
                                            minPrice,
                                            maxPrice,
                                            minMileage,
                                            maxMileage,
                                            minEngineCapacity,
                                            maxEngineCapacity,
                                            minYear,
                                            maxYear,
                                            Gearbox,
                                            BodyType,
                                            numofDoors,
                                            FuelType,
                                            co2,
                                            taxStatus,
                                            motStatus,
                                            CAT,
                                            ulez);

                                    if (co2 != null) {
                                      if (co2 == '>99g') {
                                        co2CPY = '99';
                                      } else if (co2 == '>150g') {
                                        co2CPY = '150';
                                      } else {
                                        co2CPY = '200';
                                      }
                                    }

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => searchView(
                                                  queryCars: res,
                                                  minPrice: minPrice,
                                                  maxPrice: maxPrice,
                                                  minMileage: minMileage,
                                                  maxMileage: maxMileage,
                                                  minEngine:
                                                      minEngineCapacityCPY,
                                                  maxEngine:
                                                      maxEngineCapacityCPY,
                                                  minYear: minYear,
                                                  maxYear: maxYear,
                                                  co2: co2CPY,
                                                )));
                                  }
                                  /*
                                  if (int.parse(minPrice) >=
                                          int.parse(maxPrice) ||
                                      int.parse(minMileage) >=
                                          int.parse(maxMileage) ||
                                      int.parse(minEngineCapacity) >=
                                          int.parse(maxEngineCapacity)) {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                              title: Text("Validation Error"),
                                              content: Text(
                                                  'Min and Max cannot be equal ! \nMin cannot be higher than Max'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, 'OK'),
                                                  child: const Text('OK'),
                                                )
                                              ]);
                                        });
                                  } else {
                                    print('Good');
                                  }

                                  Stream<QuerySnapshot> res = buildsearchQuery(
                                      Make,
                                      Model,
                                      Colour,
                                      minPrice,
                                      maxPrice,
                                      minMileage,
                                      maxMileage,
                                      minEngineCapacity,
                                      maxEngineCapacity,
                                      minYear,
                                      maxYear,
                                      Gearbox,
                                      BodyType,
                                      numofDoors,
                                      FuelType,
                                      co2,
                                      taxStatus,
                                      motStatus,
                                      CAT,
                                      ulez);

                                  if (minEngineCapacity != null) {
                                    minEngineCapacityCPY = carModels()
                                        .getEngineCapacity(minEngineCapacity)
                                        .toString();
                                  }
                                  if (maxEngineCapacity != null) {
                                    maxEngineCapacityCPY = carModels()
                                        .getEngineCapacity(maxEngineCapacity)
                                        .toString();
                                  }
                                  if (co2 != null) {
                                    if (co2 == '>99g') {
                                      co2CPY = '99';
                                    } else if (co2 == '>150g') {
                                      co2CPY = '150';
                                    } else {
                                      co2CPY = '200';
                                    }
                                  }

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => searchView(
                                                queryCars: res,
                                                minPrice: minPrice,
                                                maxPrice: maxPrice,
                                                minMileage: minMileage,
                                                maxMileage: maxMileage,
                                                minEngine: minEngineCapacityCPY,
                                                maxEngine: maxEngineCapacityCPY,
                                                minYear: minYear,
                                                maxYear: maxYear,
                                                co2: co2CPY,
                                              ))); */
                                },
                                child: Text(
                                  'Search Cars',
                                  style: TextStyle(fontSize: 18),
                                ))),
                      )
                    ],
                  ),
                ),
              ),
            )
          ])),
    );
  }

  Stream<QuerySnapshot> buildsearchQuery(
      String make,
      String model,
      String colour,
      String minPrice,
      String maxPrice,
      String minMileage,
      String maxMileage,
      String minEngine,
      String maxEngine,
      String minYear,
      String maxYear,
      String gearbox,
      String bodyType,
      String numofdoors,
      String fueltype,
      String co2,
      String tax,
      String mot,
      String cat,
      String ulez) {
    Stream<QuerySnapshot> result;
    Query<Object> query;
    CollectionReference _carRef = FirebaseFirestore.instance.collection('cars');
    query = _carRef;

    if (co2 != null) {
      if (co2 == '>99g') {
        query = query.where('co2', isLessThanOrEqualTo: 99);
      } else if (co2 == '>150g') {
        query = query.where('co2', isLessThanOrEqualTo: 150);
      } else if (co2 == '>200g') {
        query = query.where('co2', isLessThanOrEqualTo: 200);
      }
    }
    if (make != null) {
      query = query.where('make', isEqualTo: make.toUpperCase());
    }
    if (model != null) {
      query = query.where('model', isEqualTo: model);
    }
    if (colour != null) {
      query = query.where('colour', isEqualTo: colour.toUpperCase());
    }
    if (gearbox != null) {
      query = query.where('gearbox', isEqualTo: gearbox);
    }
    if (bodyType != null) {
      query = query.where('bodyType', isEqualTo: bodyType);
    }
    if (numofdoors != null) {
      query = query.where('numofDoors', isEqualTo: numofdoors);
    }
    if (fueltype != null) {
      query = query.where('fuelType', isEqualTo: fueltype.toUpperCase());
    }
    if (tax != null) {
      query = query.where('taxStatus', isEqualTo: tax);
    }
    if (mot != null) {
      if (mot == 'Not valid') {
        query = query.where('motStatus', isEqualTo: mot);
      }
    }
    if (cat != null) {
      if (cat == 'Declared') {
        query = query.where('cat', isEqualTo: 'true');
      } else {
        query = query.where('cat', isEqualTo: 'false');
      }
    }
    if (ulez != null) {
      if (ulez == 'Compatible') {
        query = query.where('ulez', isEqualTo: 'true');
      } else {
        query = query.where('ulez', isEqualTo: 'false');
      }
    }

    result = query.where('sold', isEqualTo: false).snapshots();
    return result;
  }
}
