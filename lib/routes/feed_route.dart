import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cheese_me_up/models/cheese.dart';
import 'package:cheese_me_up/models/user.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cheese_me_up/elements/cards/all_time_card.dart';
import 'package:cheese_me_up/elements/cards/remember_card.dart';
import 'package:cheese_me_up/elements/cards/this_period_card.dart';

User user;
String userIdCopy;

// TODO: add ability to pull body and release to refresh State

// TODO: use FutureBuilder to build widget once db response received

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
  Query _cheesesRef;
  Map<String, Cheese> cheeses = new Map();
  DatabaseReference _userRef;
  StreamSubscription streamSubscription;

  @override
  void initState() {
    super.initState();
    _cheesesRef = database.reference().child("cheeses").orderByChild("name");
    _cheesesRef.onChildAdded.listen(_onEntryAdded);

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

  void _onEntryAdded(Event event) {
    setState(() {
      var cheese = Cheese.fromSnapshot(event.snapshot);
      cheeses[cheese.id.toString()] = cheese;
    });
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
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IgnorePointer(
              child: IconButton(
                icon: Image.asset(
                  "assets/media/icons/settings.png",
                  color: Colors.transparent,
                ),
                onPressed: () {},
              ),
            ),
            Text("Brie"),
            IconButton(
              icon: Image.asset("assets/media/icons/settings.png"),
              onPressed: () {
                Navigator.pushNamed(context, '/settings_route/$userIdCopy');
              },
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
      ),
      body: ListView(
        children: user == null
            ? [Text("Loading...")]
            : <Widget>[
                (user == null)
                    ? null
                    : new AllTimeCard(
                        user: user,
                        cheeses: cheeses,
                      ),
                (user.checkins.isEmpty)
                    ? new Icon(Icons.arrow_downward)
                    : new RememberCard(
                        user: user,
                        cheeses: cheeses,
                      ),
                (user.checkins.isEmpty)
                    ? null
                    : new ThisPeriodCard(
                        user: user,
                        periodName: "week",
                        cheeses: cheeses,
                      ),
                (user.checkins.isEmpty)
                    ? null
                    : new ThisPeriodCard(
                        user: user,
                        periodName: "month",
                        cheeses: cheeses,
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
            IconButton(
                icon: Image.asset("assets/media/icons/map.png"),
                onPressed: () {
                  return showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: Text(
                            "The Map functionnality is in preparation. Stay tuned!"),
                      );
                    },
                  );
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Colors.orange[200],
                width: 2.0,
              ),
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          backgroundColor: Colors.brown[800],
          onPressed: _goCheckinRoute,
          child: Padding(
            child: Image.asset("assets/media/icons/cheese_color.png"),
            padding: EdgeInsets.all(10.0),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
