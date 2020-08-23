import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Likely/common/constants.dart';
import 'package:Likely/screens/custom_widgets/filter_widget.dart';
import 'package:Likely/screens/custom_widgets/floating_widget.dart';
import 'package:Likely/screens/custom_widgets/image_widget.dart';
import 'package:provider/provider.dart';
import 'package:Likely/models/user.dart';
import 'package:Likely/screens/view/addproduct.dart';

import 'package:Likely/screens/authenticate/register.dart';
import 'package:Likely/screens/authenticate/signin.dart';

class Home extends StatelessWidget {
  final filterArray = [
    "<\$220.000",
    "For sale",
    "3-4 beds",
    "Kitchen",
  ];

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    var screenWidth = MediaQuery.of(context).size.width;
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
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/title.jpg',
                fit: BoxFit.cover, height: 32),
            Text("Likely", style: TextStyle(color: Colors.green)),
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
                textColor: Colors.black),
            FlatButton(
                child: Text('Register'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Register()),
                  );
                },
                textColor: Colors.black),
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
                color: Colors.orange,
                textColor: Colors.white)
          ],
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 15,
            right: 15,
            top: 35,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "City",
                style: GoogleFonts.notoSans(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Colombo",
                style: GoogleFonts.notoSans(
                  fontSize: 36,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
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
                  Constants.houseList.length,
                  (index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: ImageWidget(
                        Constants.houseList[index],
                        index,
                        Constants.imageList,
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
