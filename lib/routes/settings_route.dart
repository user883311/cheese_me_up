import 'package:cheese_me_up/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

String userIdCopy;
User user;

class SettingsRoute extends StatefulWidget {
  SettingsRoute({this.userId});
  final String userId;

  @override
  _SettingsRoute createState() {
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
        decoration: new BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/media/img/wallpapers/wp_cows_001.png"),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Spacer(),
            Flexible(
              // flex: 4,
              // fit: FlexFit.loose,
              child: RaisedButton(
                child: Text("Log out"),
                onPressed: () {
                  userIdCopy = null;
                  // Navigator.popUntil(context, ModalRoute.withName('/'));
                  Navigator.pushReplacementNamed(context, "/");
                  // _auth.signOut();
                },
              ),
            ),
            Expanded(
                child: Divider(
              color: Colors.white70,
            )),
            Text(
              "You do not own your data. You can delete it forever from our servers.",
              style: TextStyle(
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
            RaisedButton(
              child: Text("Delete my account forever"),
              onPressed: () {},
            ),
            Spacer(),
            Text(
              "Credits: Cassandra, my first beta tester, for her merciless bug reports.",
              style: TextStyle(
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
            Spacer(),
            Text(
              "Heartfelt thanks from the Cheese Head team!",
              style: TextStyle(
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
