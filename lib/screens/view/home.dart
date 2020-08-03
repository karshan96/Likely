import 'package:flutter/material.dart';
import '../authenticate/signin.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/title.jpg',
                fit: BoxFit.cover, height: 32),
            Text("Likely", style: TextStyle(color: Colors.green))
          ],
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FlatButton(
              child: Text('Login'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignIn()),
                );
              },
              textColor: Colors.black),
          FlatButton(
              child: Text('Register'),
              onPressed: () {},
              textColor: Colors.black),
          FlatButton(
              child: Text('Post Your Ad'),
              onPressed: () {},
              color: Colors.orange,
              textColor: Colors.white)
        ],
      ),
    );
  }
}
