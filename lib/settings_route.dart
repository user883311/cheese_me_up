import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

String userIdCopy;

class SettingsRoute extends StatefulWidget {
  SettingsRoute({this.userId});
  final String userId;

  @override
  _SettingsRoute createState() {
    print("userIdCopy $userIdCopy");
    userIdCopy = userId;
    return _SettingsRoute();
  }
}

class _SettingsRoute extends State<SettingsRoute> {
  // TODO: add dropdown form to change user's profile fields: 
  // gender, first name, country of origin, country of residence, 
  // 
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Column(
        children: [
          RaisedButton(
            child: Text("Log out"),
            onPressed: () {
              userIdCopy=null;
              Navigator.popUntil(context, ModalRoute.withName('/'));
            },
          ),
          RaisedButton(
            child: Text("Delete my account"),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
