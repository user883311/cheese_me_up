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
      body: RaisedButton(
        child: Text("Log out"),
        onPressed: () {
          // TODO: Log Out function
          Navigator.popUntil(context, ModalRoute.withName('/'));
        },
      ),
    );
  }
}
