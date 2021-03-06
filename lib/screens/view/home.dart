import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:Likely/screens/custom_widgets/filter_widget.dart';
import 'package:Likely/screens/custom_widgets/image_widget.dart';
import 'package:provider/provider.dart';
import 'package:Likely/models/user.dart';
import 'package:Likely/screens/view/addproduct.dart';
import 'package:Likely/models/data_model.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:Likely/screens/view/register.dart';
import 'package:Likely/screens/view/signin.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static List<House> houseList = List();
  House house;
  List<House> filteredHouses = List();
  final debouncer = Debouncer(milliseconds: 500);
  DatabaseReference db;
  FirebaseDatabase database;
  final firestoreInstance = Firestore.instance;

  @override
  void initState() {
    super.initState();
    try {
      houseList.clear();
      firestoreInstance
          .collection("houses")
          .getDocuments()
          .then((querySnapshot) {
        setState(() {
          querySnapshot.documents.forEach((result) {
            house = new House(
                amount: result['amount'],
                address: result['address'],
                bedrooms: result['bedrooms'],
                bathrooms: result['bathrooms'],
                squarefoot: result['squarefoot'],
                garages: result['garages'],
                kitchen: result['kitchen'],
                date: result['date'],
                imageUrl: result['imageUrl'],
                description: result['description'],
                phone: result['phone']);
            // print(key);
            houseList.add(house);
            filteredHouses = houseList;
          });
        });
      });
      // db = FirebaseDatabase.instance.reference().child("houses");
      // db.keepSynced(true);
      // db.once().then((DataSnapshot snapshot) {
      //   setState(() {
      //     Map<dynamic, dynamic> values = snapshot.value;
      //     houseList.clear();
      //     values.forEach((key, values) {
      //       house = new House(
      //           amount: values['amount'],
      //           address: values['address'],
      //           bedrooms: values['bedrooms'],
      //           bathrooms: values['bathrooms'],
      //           squarefoot: values['squarefoot'],
      //           garages: values['garages'],
      //           kitchen: values['kitchen'],
      //           date: values['date'],
      //           imageUrl: values['imageUrl'],
      //           description: values['description'],
      //           phone: values['phone']);
      //       // print(key);
      //       houseList.add(house);
      //       filteredHouses = houseList;
      //     });
      //   });
      // });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    // var screenWidth = MediaQuery.of(context).size.width;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.white,
      ),
    );
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 72,
        title: Row(
          children: <Widget>[
            FlatButton.icon(
              padding: const EdgeInsets.only(
                right: 0.01,
              ),
              onPressed: () {
                // Navigator.of(context).pop(false);
                Navigator.pushReplacementNamed(context, "/home");
              },
              icon: Image.asset('assets/images/title1.jpg',
                  fit: BoxFit.cover,
                  height: 39,
                  alignment: Alignment.centerRight),
              label: Text(
                "Likely",
                style: TextStyle(color: Colors.black, fontSize: 14.5),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          FlatButton(
              child: Text('Login'),
              padding: EdgeInsets.all(2.0),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignIn(),
                  ),
                );
              },
              textColor: Colors.grey),
          FlatButton(
              child: Text('Register'),
              padding: EdgeInsets.all(2.0),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Register()),
                );
              },
              textColor: Colors.grey),
          FlatButton(
              child: Text('Post Your Ad'),
              padding: EdgeInsets.all(10.0),
              onPressed: () {
                if (user == null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignIn()),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddProduct()),
                  );
                }
              },
              color: Colors.grey,
              textColor: Colors.white)
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 15,
            right: 15,
            top: 15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "City",
                style: GoogleFonts.notoSans(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              TextField(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  hintText: 'Colombo',
                  hintStyle: GoogleFonts.notoSans(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: TextStyle(fontSize: 24),
                onChanged: (area) {
                  debouncer.run(() {
                    setState(() {
                      filteredHouses = houseList
                          .where((u) => (u.address
                              .toLowerCase()
                              .contains(area.toLowerCase())))
                          .toList();
                    });
                  });
                },
              ),
              Divider(
                color: Colors.grey,
                thickness: .2,
              ),
              Container(
                height: 50,
                child: ListView(
                    shrinkWrap: false,
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      Container(
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 5,
                              right: 5,
                            ),
                            child: new FlatButton(
                              child: new Text(
                                '<LKR 5,000,000',
                                style: GoogleFonts.notoSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              onPressed: () {
                                debouncer.run(() {
                                  setState(() {
                                    filteredHouses = houseList
                                        .where((u) => u.amount <= 5000000)
                                        .toList();
                                  });
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 5,
                              right: 5,
                            ),
                            child: new FlatButton(
                              child: new Text(
                                'Bedrooms 3-4',
                                style: GoogleFonts.notoSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              onPressed: () {
                                debouncer.run(() {
                                  setState(() {
                                    filteredHouses = houseList
                                        .where((u) =>
                                            u.bedrooms >= 3 && u.bedrooms <= 4)
                                        .toList();
                                  });
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 5,
                              right: 5,
                            ),
                            child: new FlatButton(
                              child: new Text(
                                'Garage',
                                style: GoogleFonts.notoSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              onPressed: () {
                                debouncer.run(() {
                                  setState(() {
                                    filteredHouses = houseList
                                        .where((u) => u.garages > 0)
                                        .toList();
                                  });
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ]),
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                children: List.generate(
                  filteredHouses.length,
                  (index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: ImageWidget(
                        filteredHouses[index],
                        index,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
