import 'package:flutter/material.dart';
import 'package:Likely/services/auth.dart';
import 'package:flutter/services.dart';

import 'package:Likely/screens/custom_widgets/menu_widget.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();

  String _email = '';
  String _password = '';
  String _error = '';
  final _formKey = GlobalKey<FormState>();
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
                // new Hero(
                //   tag: 'hero',
                //   child: Padding(
                //     padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                //     child: CircleAvatar(
                //       backgroundColor: Colors.transparent,
                //       radius: 84.0,
                //       child: Image.asset('assets/images/login.png'),
                //     ),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
                  child: new TextFormField(
                    maxLines: 1,
                    keyboardType: TextInputType.emailAddress,
                    autofocus: false,
                    decoration: new InputDecoration(
                        hintText: 'Email',
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
                  padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
                  child: new TextFormField(
                    maxLines: 1,
                    obscureText: true,
                    autofocus: false,
                    decoration: new InputDecoration(
                        hintText: 'Password',
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
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          color: Colors.blue,
                          child: new Text('Login',
                              // _isLoginForm ? 'Login' : 'Create account',
                              style: new TextStyle(
                                  fontSize: 20.0, color: Colors.white)),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              dynamic result = await _auth
                                  .signWithEmailPassword(_email, _password);
                              // Navigator.of(context).pop(false);
                              if (result == null) {
                                setState(() =>
                                    _error = 'Could not sign in with this');
                              }
                            }
                          }
                          // validateAndSubmit,
                          ),
                    )),
                FlatButton(
                    child: new Text(
                      'Create a Account',
                      // _isLoginForm ? 'Create an account' : 'Have an account? Sign in',
                      // style: new TextStyle(
                      // fontSize: 18.0, fontWeight: FontWeight.w300)
                    ),
                    onPressed: () => widget.toggleView().catchError((e) {
                          print(e);
                        }))
              ],
            ),
          )),
    );
  }
}

// Widget showErrorMessage() {
//   if (_errorMessage.length > 0 && _errorMessage != null) {
//     return new Text(
//       _errorMessage,
//       style: TextStyle(
//           fontSize: 13.0,
//           color: Colors.red,
//           height: 1.0,
//           fontWeight: FontWeight.w300),
//     );
//   } else {
//     return new Container(
//       height: 0.0,
//     );
//   }
// }
