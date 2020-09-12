import 'package:Likely/screens/view/signin.dart';
import 'package:flutter/material.dart';
import 'package:Likely/services/auth.dart';
import 'package:Likely/screens/custom_widgets/menu_widget.dart';
import 'package:flutter/services.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();

  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          child: new Form(
            key: _formKey,
            child: new ListView(
              shrinkWrap: true,
              children: <Widget>[
                Stack(
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
                              }),
                        ],
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 45),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 240,
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                            child: Container(
                          child: Align(
                            child: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.grey),
                              width: 150,
                              height: 150,
                            ),
                            alignment: Alignment.center,
                          ),
                          height: 154,
                        )),
                        Positioned(
                          child: Container(
                              height: 154,
                              width: MediaQuery.of(context).size.width,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "LIKELY",
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              )),
                        ),
                        Positioned(
                          width: 60,
                          height: 60,
                          top: 140,
                          left: 260,
                          child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.grey),
                          ),
                        ),
                        Positioned(
                          width: 30,
                          height: 30,
                          top: 200,
                          left: 230,
                          child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                  child: new TextFormField(
                    maxLines: 1,
                    keyboardType: TextInputType.emailAddress,
                    autofocus: false,
                    decoration: new InputDecoration(
                        labelText: 'Email',
                        icon: new Icon(
                          Icons.mail,
                          color: Colors.grey,
                        )),
                    validator: (value) =>
                        value.isEmpty ? 'Email can\'t be empty' : null,
                    onChanged: (value) => _email = value.trim(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  child: new TextFormField(
                    maxLines: 1,
                    obscureText: true,
                    autofocus: false,
                    decoration: new InputDecoration(
                        labelText: 'Password',
                        icon: new Icon(
                          Icons.lock,
                          color: Colors.grey,
                        )),
                    validator: (value) =>
                        value.isEmpty ? 'Password can\'t be empty' : null,
                    onChanged: (value) => _password = value.trim(),
                  ),
                ),
                SizedBox(
                  height: 12.0,
                ),
                Text(
                  _error,
                  style: TextStyle(color: Colors.red, fontSize: 14.0),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
                    child: SizedBox(
                      height: 40.0,
                      child: new RaisedButton(
                          elevation: 5.0,
                          // shape: new RoundedRectangleBorder(
                          //     borderRadius: new BorderRadius.circular(30.0)),
                          color: Colors.grey,
                          child: new Text('Create an account',
                              // _isLoginForm ? 'Login' : 'Create account',
                              style: new TextStyle(
                                  fontSize: 20.0, color: Colors.white)),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              dynamic result = await _auth
                                  .registerWithEmailPassword(_email, _password);
                              Navigator.of(context).pop(false);
                              if (result == null) {
                                setState(
                                    () => _error = 'Please add valid Email');
                              }
                            }
                          }
                          // validateAndSubmit,
                          ),
                    )),
                FlatButton(
                    child: new Text(
                      'LogIn',
                      // _isLoginForm ? 'Create an account' : 'Have an account? Sign in',
                      // style: new TextStyle(
                      // fontSize: 18.0, fontWeight: FontWeight.w300)
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignIn()),
                      );
                    }),
              ],
            ),
          )),
    );
  }
}
