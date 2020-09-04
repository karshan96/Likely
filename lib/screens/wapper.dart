import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Likely/models/user.dart';

import 'view/home.dart';

class Wapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    print(user);

    //return either home or authenticate
    if (user == null) {
      return Home();
    } else {
      return Home();
    }
  }
}
