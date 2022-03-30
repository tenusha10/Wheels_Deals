import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  String Model, BodyType, Gearbox, FuelType, co2, numofDoors, engineCapacity;
  bool CAT = false, ulez = false, taxStatus = false, motStatus = false;
  String minYear,
      maxYear,
      minPrice,
      maxPrice,
      minMileage,
      maxMileage,
      minEngineCapacity,
      maxEngineCapacity;
  var yearRange = RangeValues(1999, 1999);
  List<String> makeList = carModels().getMakes();
  List<String> modelList = [];
  List<String> engineList = ['1L', '1L-2L'];
  List<String> gearboxList = ['Automatic', 'Manual'];
  List<String> bodyTypeList = carModels().getBodyTypes();
  List<String> numofDoorsList = ['3 Doors', '5 Doors'];
  List<String> co2List = ['>99g', '>150g', '>200g', '200g+'];
  List<String> fuelList = ['Petrol', 'Diesel', 'Hybrid', 'Electricity'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: 500,
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
                      Text(
                        'Search Cars for Sale',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: DropdownButtonFormField<String>(
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
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please select a Make';
                            }
                            return null;
                          },
                        ),
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
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please select a model';
                            }
                            return null;
                          },
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
                          SizedBox(
                            width: 8,
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left: 30, right: 5, top: 10, bottom: 10),
                            height: 50,
                            width: 100,
                            child: TextFormField(
                              decoration: InputDecoration(hintText: 'Min £'),
                              onChanged: (value) {
                                this.minPrice = value.trim();
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
                          ),
                          SizedBox(
                            width: 50,
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left: 30, right: 5, top: 10, bottom: 10),
                            height: 50,
                            width: 100,
                            child: TextFormField(
                              decoration: InputDecoration(hintText: 'Max £'),
                              onChanged: (value) {
                                this.maxPrice = value.trim();
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
                          ),
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
                      Row(
                        children: [
                          Text(
                            'Mileage',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left: 30, right: 5, top: 10, bottom: 10),
                            height: 50,
                            width: 100,
                            child: TextFormField(
                              decoration: InputDecoration(hintText: 'Min'),
                              onChanged: (value) {
                                this.minMileage = value.trim();
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
                          ),
                          SizedBox(
                            width: 50,
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left: 30, right: 5, top: 10, bottom: 10),
                            height: 50,
                            width: 100,
                            child: TextFormField(
                              decoration: InputDecoration(hintText: 'Max'),
                              onChanged: (value) {
                                this.maxMileage = value.trim();
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
                          ),
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
                      Row(
                        children: [
                          Text(
                            'Engine',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left: 30, right: 5, top: 10, bottom: 10),
                            height: 50,
                            width: 100,
                            child: TextFormField(
                              decoration: InputDecoration(hintText: 'Min'),
                              onChanged: (value) {
                                this.minEngineCapacity = value.trim();
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
                          ),
                          SizedBox(
                            width: 50,
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left: 30, right: 5, top: 10, bottom: 10),
                            height: 50,
                            width: 100,
                            child: TextFormField(
                              decoration: InputDecoration(hintText: 'Max'),
                              onChanged: (value) {
                                this.maxEngineCapacity = value.trim();
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
                          ),
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
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please select a model';
                            }
                            return null;
                          },
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
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please select a model';
                            }
                            return null;
                          },
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
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please select a model';
                            }
                            return null;
                          },
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
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please select a model';
                            }
                            return null;
                          },
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
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please select a model';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Text(
                            'Tax Status',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.48,
                                right: 5),
                            child: CupertinoSwitch(
                                value: taxStatus,
                                activeColor: Colors.deepPurple,
                                onChanged: (bool value) {
                                  setState((() {
                                    taxStatus = value;
                                  }));
                                }),
                          )
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
                            'Mot Status',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.47,
                                right: 5),
                            child: CupertinoSwitch(
                                value: motStatus,
                                activeColor: Colors.deepPurple,
                                onChanged: (bool value) {
                                  setState((() {
                                    motStatus = value;
                                  }));
                                }),
                          )
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
                            'CAT(S/N)',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.492,
                                right: 5),
                            child: CupertinoSwitch(
                                value: CAT,
                                activeColor: Colors.deepPurple,
                                onChanged: (bool value) {
                                  setState((() {
                                    CAT = value;
                                  }));
                                }),
                          )
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
                            'Ultra Low Emission Zone',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.24,
                                right: 5),
                            child: CupertinoSwitch(
                                value: ulez,
                                activeColor: Colors.deepPurple,
                                onChanged: (bool value) {
                                  setState((() {
                                    ulez = value;
                                  }));
                                }),
                          )
                        ],
                      ),
                      Divider(
                        color: Colors.black45,
                        thickness: 1,
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
                                  Stream<QuerySnapshot> res = buildsearchQuery(
                                      Make,
                                      Model,
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

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => searchView(
                                                queryCars: res,
                                              )));
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
      bool tax,
      bool mot,
      bool cat,
      bool ulez) {
    Stream<QuerySnapshot> result;
    CollectionReference _carRef = FirebaseFirestore.instance.collection('cars');
    if (make != null) {
      if (model != null) {
        return _carRef
            .where('make', isEqualTo: make.toUpperCase())
            .where('model', isEqualTo: model)
            .snapshots();
      } else {
        return _carRef.where('make', isEqualTo: make.toUpperCase()).snapshots();
      }
    }
    if (maxPrice != null) {
      if (model != null) {
        return _carRef
            .where('make', isEqualTo: make.toUpperCase())
            .where('model', isEqualTo: model)
            .snapshots();
      } else {
        return _carRef
            .where('price', isLessThan: int.tryParse(maxPrice))
            .snapshots();
      }
    }
    if (fueltype != null) {
      return _carRef
          .where('fuelType', isEqualTo: fueltype.toUpperCase())
          .snapshots();
    }
    if (tax == true) {
      return _carRef.where('taxStatus', isEqualTo: "Taxed").snapshots();
    }
    if (mot == true) {
      return _carRef.where('motStatus', isEqualTo: "Valid").snapshots();
    }

    //return _carRef.orderBy("time", descending: true).snapshots();
  }
}
