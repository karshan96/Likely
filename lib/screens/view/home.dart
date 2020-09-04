import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Likely/screens/custom_widgets/filter_widget.dart';
import 'package:Likely/screens/custom_widgets/floating_widget.dart';
import 'package:Likely/screens/custom_widgets/image_widget.dart';
import 'package:provider/provider.dart';
import 'package:Likely/models/user.dart';
import 'package:Likely/screens/view/addproduct.dart';
import 'package:Likely/models/data_model.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:Likely/screens/view/register.dart';
import 'package:Likely/screens/view/signin.dart';
import 'dart:async';

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
  final filterArray = [
    "<\$220.000",
    "For sale",
    "3-4 beds",
    "Kitchen",
  ];
  static List<House> houseList = List();
  House house;
  List<House> filteredHouses = List();
  final debouncer = Debouncer(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    try {
      DatabaseReference db =
          FirebaseDatabase.instance.reference().child("houses");
      db.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> values = snapshot.value;
        houseList.clear();
        values.forEach((key, values) {
          house = new House(
              amount: values['amount'],
              address: values['address'],
              bedrooms: values['bedrooms'],
              bathrooms: values['bathrooms'],
              squarefoot: values['squarefoot'],
              garages: values['garages'],
              kitchen: values['kitchen'],
              date: values['date'],
              imageUrl: values['imageUrl'],
              description: values['description'],
              phone: values['phone']);
          // print(key);
          houseList.add(house);
          // filteredHouses = houseList;
        });
      });
      setState(() {
        // print(houseList.length);
        filteredHouses = houseList;
      });
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
      floatingActionButton: FloatingWidget(
        leadingIcon: Icons.explore,
        txt: "Map view",
      ),
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Image.asset('assets/images/title1.jpg',
                fit: BoxFit.cover, height: 32),
            Text("Likely", style: TextStyle(color: Colors.black)),
          ],
        ),
        actions: <Widget>[
          FlatButton(
              child: Text('Login'),
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Register()),
                );
              },
              textColor: Colors.grey),
          FlatButton(
              child: Text('Post Your Ad'),
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
                  fontSize: 13,
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
                onChanged: (string) {
                  debouncer.run(() {
                    setState(() {
                      filteredHouses = houseList
                          .where((u) => (u.address
                              .toLowerCase()
                              .contains(string.toLowerCase())))
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
                child: ListView.builder(
                  shrinkWrap: false,
                  scrollDirection: Axis.horizontal,
                  itemCount: filterArray.length,
                  itemBuilder: (context, index) {
                    return FilterWidget(
                      filterTxt: filterArray[index],
                    );
                  },
                ),
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
