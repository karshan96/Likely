import 'package:Likely/screens/view/home.dart';
import 'package:flutter/material.dart';
import 'package:Likely/screens/custom_widgets/menu_widget.dart';

import '../../services/auth.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 25, bottom: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
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
                        iconColor: Colors.grey,
                        conBackColor: Colors.transparent,
                        onbtnTap: () {
                          Navigator.of(context).pop(false);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Home(),
                            ),
                          );
                          Navigator.of(context).pop(false);
                        }),
                    MenuWidget(
                        iconImg: Icons.person,
                        iconColor: Colors.grey,
                        conBackColor: Colors.transparent,
                        onbtnTap: () async {
                          await _auth.signOut();
                          Navigator.of(context).pop(false);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Home()),
                          );
                          Navigator.of(context).pop(false);
                        })
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
