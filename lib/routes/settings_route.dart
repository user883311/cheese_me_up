import 'package:cheese_me_up/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

String userIdCopy;
User user;

class SettingsRoute extends StatefulWidget {
  SettingsRoute({this.userId});
  final String userId;

  @override
  _SettingsRoute createState() {
    // print("userIdCopy $userIdCopy");
    userIdCopy = userId;
    return _SettingsRoute();
  }
}

class _SettingsRoute extends State<SettingsRoute> {
  // TODO: add dropdown form to change user's profile fields:
  // display name, isEmailVerified

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
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RaisedButton(
              child: Text("Log out"),
              onPressed: () {
                userIdCopy = null;
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
            ),
            // RaisedButton(
            //   child: Text("Delete my account"),
            //   onPressed: () {},
            // ),
          ],
        ),
      ),
    );
  }
}
