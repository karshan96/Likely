import 'package:flutter/material.dart';

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('AddProduct'),
        backgroundColor: Colors.green,
        elevation: 0.0,
        actions: <Widget>[
          FlatButton.icon(
              onPressed: () async {
                await _auth.signOut();
                Navigator.pop(context);
              },
              icon: Icon(Icons.person),
              label: Text('Log Out'))
        ],
      ),
    );
  }
}
