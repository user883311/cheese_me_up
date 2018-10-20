import 'package:cheese_me_up/app_state_container.dart';
import 'package:cheese_me_up/models/app_state.dart';
import 'package:cheese_me_up/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsRoute extends StatefulWidget {
  SettingsRoute({this.userId});
  final String userId;

  @override
  SettingsRouteState createState() => SettingsRouteState();
}

class SettingsRouteState extends State<SettingsRoute> {
  AppState appState;
  // TODO: add dropdown form to change user's profile fields:
  // display name, isEmailVerified
  @override
  void initState() => super.initState();

  @override
  Widget build(BuildContext context) {
    var container = AppStateContainer.of(context);

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
          children: [
            Spacer(),
            Flexible(
              child: RaisedButton(
                  child: Text("Log out"),
                  onPressed: () async {
                    // await container.googleSignIn.signOut();
                    await container.googleSignIn.disconnect();
                    container.googleUser=null;
                    container.state.user = null;
                    print("signed out...");
                    Navigator.pushNamedAndRemoveUntil(
                        context, "/", ModalRoute.withName('/'));
                  }),
            ),
            Expanded(
              child: Divider(),
            ),
            Text(
              "We do not own your data. You can delete it forever from our servers, anytime you want to.",
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
              "Heartfelt thanks from the Cheese Heads team!",
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
