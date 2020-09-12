import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:Likely/screens/custom_widgets/floating_widget.dart';
import 'package:Likely/screens/custom_widgets/house_widget.dart';
import 'package:Likely/screens/custom_widgets/menu_widget.dart';
import 'package:Likely/models/data_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

class PropertyDetails extends StatefulWidget {
  final House house;
  final int imgpathindex;
  PropertyDetails(
    this.house,
    this.imgpathindex,
  );
  @override
  _PropertyDetailsState createState() => _PropertyDetailsState();
}

class _PropertyDetailsState extends State<PropertyDetails> {
  Future<void> launched;
  Future<void> mackeLaunch(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  final typeArray = [
    "Squarefoot",
    "Bedrooms",
    "Bathrooms",
    "Garage",
    "Kitchen",
  ];

  @override
  Widget build(BuildContext context) {
    final today = new DateTime.now();
    final hDifference =
        today.difference(DateTime.parse(widget.house.date)).inHours;
    final dDifference =
        today.difference(DateTime.parse(widget.house.date)).inDays;
    final mDifference =
        today.difference(DateTime.parse(widget.house.date)).inMinutes;
    final sDifference =
        today.difference(DateTime.parse(widget.house.date)).inSeconds;
    String phone = widget.house.phone;
    final houseArray = [
      widget.house.squarefoot,
      widget.house.bedrooms,
      widget.house.bathrooms,
      widget.house.garages,
      widget.house.kitchen
    ];
    var screenWidth = MediaQuery.of(context).size.width;
    final oCcy = new NumberFormat("##,##,###", "en_INR");
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.white,
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        padding: EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 0,
        ),
        width: screenWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            FloatingWidget(
              leadingIcon: Icons.mail,
              txt: "Message",
              onbtnTap: () => setState(() {
                launched = mackeLaunch('sms:$phone');
              }),
            ),
            FloatingWidget(
              leadingIcon: Icons.phone,
              txt: "Call",
              onbtnTap: () => setState(() {
                // print(int.parse(widget.house.phone));
                launched = mackeLaunch('tel:$phone');
              }),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 25, bottom: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 0, bottom: 10),
                    child: SizedBox(
                      height: 200.0,
                      width: screenWidth,
                      child: new Image.network(widget.house.imageUrl,
                          fit: BoxFit.cover),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 15,
                      right: 15,
                      left: 15,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        MenuWidget(
                            iconImg: Icons.arrow_back,
                            iconColor: Colors.white,
                            conBackColor: Colors.transparent,
                            onbtnTap: () {
                              Navigator.of(context).pop(false);
                            }),
                      ],
                    ),
                  )
                ],
              ),
              Container(
                padding: EdgeInsets.only(left: 15, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '\LKR ' + "${oCcy.format(widget.house.amount)}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Text(
                            widget.house.address,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Container(
                        height: 45,
                        width: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                            color: Colors.grey[200],
                          ),
                        ),
                        child: Center(
                          child: Text(
                            sDifference >= 60
                                ? mDifference >= 60
                                    ? hDifference >= 24
                                        ? dDifference > 1
                                            ? dDifference.toString() +
                                                ' Days ago'
                                            : dDifference.toString() +
                                                ' Day ago'
                                        : hDifference > 1
                                            ? hDifference.toString() +
                                                ' Hours ago'
                                            : hDifference.toString() +
                                                ' Hour ago'
                                    : mDifference > 1
                                        ? mDifference.toString() +
                                            ' Minutes ago'
                                        : mDifference.toString() + ' Minute ago'
                                : sDifference > 1
                                    ? sDifference.toString() + ' Seconds ago'
                                    : sDifference.toString() + ' Second ago',
                            style: Theme.of(context).textTheme.caption.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 15,
                  bottom: 15,
                  left: 15,
                ),
                child: Text(
                  "House Information",
                  style: GoogleFonts.notoSans(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                height: 110,
                child: ListView.builder(
                  shrinkWrap: false,
                  scrollDirection: Axis.horizontal,
                  itemCount: typeArray.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: HouseWidget(
                        type: typeArray[index],
                        number: houseArray[index].toString(),
                      ),
                    );
                  },
                ),
              ),
              Container(
                  child: Padding(
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                  top: 20,
                  bottom: 20,
                ),
                child: Text(
                  widget.house.description.toString(),
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.notoSans(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
