import 'dart:async';

import 'package:cheese_me_up/elements/cards/all_time_card.dart';
import 'package:cheese_me_up/elements/cards/remember_card.dart';
import 'package:cheese_me_up/elements/cards/this_period_card.dart';
import 'package:cheese_me_up/models/user.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

User user;
String userIdCopy;

// TODO: add ability to pull body and release to refresh State

class FeedRoute extends StatefulWidget {
  FeedRoute({this.userId});
  final String userId;

  @override
  _FeedRoute createState() {
    userIdCopy = userId;
    return new _FeedRoute();
  }
}

class _FeedRoute extends State<FeedRoute> {
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference _userRef;
  StreamSubscription streamSubscription;

  @override
  void initState() {
    super.initState();
    // user=null;
    _userRef = database.reference().child("users/$userIdCopy");

    streamSubscription = _userRef.onValue.listen((Event event) {
      setState(() {
        user = new User.fromSnapshot(event.snapshot);
      });
    });
    // .onError((error) {
    //   print(error);
    //   Navigator.popUntil(context, ModalRoute.withName('/'));
    // });
  }

  @override
  void dispose() {
    user = null;
    streamSubscription.cancel();
    super.dispose();
  }

  void _goCheckinRoute() {
    Navigator.pushReplacementNamed(context, '/checkin_route/$userIdCopy');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Text(""),
        title: Text("Home"),
      ),
      body: ListView(
        // TODO: add cards, take inspiration from Wikipedia app:
        // All time best, Today's cheese, Country Focus, etc.
        children: user == null
            ? [Text("Loading...")]
            : <Widget>[
                (user == null)
                    ? null
                    : new AllTimeCard(
                        user: user,
                      ),
                // new AllTimeCard(),
                (user.checkins.isEmpty)
                    ? new Icon(Icons.arrow_downward)
                    : new RememberCard(
                        user: user,
                      ),
                (user.checkins.isEmpty)
                    ? null
                    : new ThisPeriodCard(
                        user: user,
                        periodName: "week",
                      ),
              ],
      ),
      bottomNavigationBar: Container(
        color: Colors.brown,
        child: ButtonBar(
          alignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Image.asset("assets/media/icons/history.png"),
              onPressed: () {
                Navigator.pushNamed(context, '/history_route/$userIdCopy');
              },
            ),
            Container(
              padding: EdgeInsets.all(5.0),
              decoration: new BoxDecoration(
                boxShadow: [
                  BoxShadow(color: Colors.brown[900], offset: Offset(2.0, 2.0))
                ],
                color: Colors.brown[800],
                borderRadius: BorderRadius.all(
                  Radius.circular(20.0),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Image.asset("assets/media/icons/cheese_color.png"),
                    onPressed: _goCheckinRoute,
                  ),
                  Text(
                    "+1",
                    style: TextStyle(color: Colors.orange[200]),
                  )
                ],
              ),
            ),
            IconButton(
              icon: Image.asset("assets/media/icons/settings.png"),
              onPressed: () {
                Navigator.pushNamed(context, '/settings_route/$userIdCopy');
              },
            ),
          ],
        ),
      ),
    );
  }
}
