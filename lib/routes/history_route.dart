import 'dart:async';

import 'package:cheese_me_up/elements/cards/history_card.dart';
import 'package:cheese_me_up/models/checkin.dart';
import 'package:cheese_me_up/models/cheese.dart';
import 'package:cheese_me_up/models/user.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

User user;
String userIdCopy;
List<CheckIn> checkinsCopy = [];

class HistoryRoute extends StatefulWidget {
  final String userId;
  final String drawerTitle = "History";

  HistoryRoute({Key key, this.userId});

  @override
  _HistoryRouteState createState() {
    userIdCopy = userId;
    return new _HistoryRouteState();
  }
}

class _HistoryRouteState extends State<HistoryRoute> {
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference _userRef;
  StreamSubscription streamSubscription;
  Query _cheesesRef;
  Map<String, Cheese> cheeses = new Map();

  @override
  void initState() {
    super.initState();

    _cheesesRef = database.reference().child("cheeses").orderByChild("name");
    _cheesesRef.onChildAdded.listen(_onEntryAdded);

    _userRef = database.reference().child("users/$userIdCopy");
    streamSubscription = _userRef.onValue.listen((Event event) {
      setState(() {
        user = new User.fromSnapshot(event.snapshot);
        checkinsCopy = user.checkins.values.toList();
        checkinsCopy.sort((a, b) => b.time.compareTo(a.time));
      });
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("History"),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              print("pressed back button");
              Navigator.pushReplacementNamed(
                  context, '/feed_route/$userIdCopy');
            }),
      ),
      body: (user == null || user.checkins.isEmpty)
          ? Card(
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                    "Your history section is empty. Go check out some new cheeses! "),
              ),
            )
          : ListView.builder(
              itemCount: checkinsCopy.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.all(5.0),
                  child: HistoryCard(
                    checkin: checkinsCopy[index],
                    cheese: cheeses[checkinsCopy[index].cheeseId],
                  ),
                );
              },
            ),
    );
  }
}
