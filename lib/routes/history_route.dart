import 'dart:async';

import 'package:cheese_me_up/app_state_container.dart';
import 'package:cheese_me_up/elements/cards/history_card.dart';
import 'package:cheese_me_up/elements/cards/starred_card.dart';
import 'package:cheese_me_up/models/app_state.dart';
import 'package:cheese_me_up/models/checkin.dart';
import 'package:cheese_me_up/models/cheese.dart';
import 'package:cheese_me_up/models/rating.dart';
import 'package:cheese_me_up/models/user.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

// User user;
// String userIdCopy;
// List<CheckIn> checkinsCopy = [];
// List<Rating> ratesCopy = [];

class HistoryRoute extends StatefulWidget {
  HistoryRoute({Key key});

  @override
  _HistoryRouteState createState() => new _HistoryRouteState();
}

class _HistoryRouteState extends State<HistoryRoute> {
  AppState appState;
  // final FirebaseDatabase database = FirebaseDatabase.instance;
  // DatabaseReference _userRef;
  // StreamSubscription streamSubscription;
  // Query _cheesesRef;
  // Map<String, Cheese> cheeses = new Map();

  @override
  void initState() {
    super.initState();

    // _cheesesRef = database.reference().child("cheeses").orderByChild("name");
    // _cheesesRef.onChildAdded.listen(_onEntryAdded);
    // _cheesesRef.onChildRemoved.listen(_onEntryRemoved);

    // _userRef = database.reference().child("users/$userIdCopy");
    // streamSubscription = _userRef.onValue.listen((Event event) {
    //   setState(() {
    //     user = new User.fromSnapshot(event.snapshot);
    //     checkinsCopy = user.checkins.values.toList();
    //     ratesCopy = user.ratings.values.toList();
    //     checkinsCopy.sort((a, b) => b.time.compareTo(a.time));
    //     // user.checkins.sort((a, b) => b.time.compareTo(a.time));

    //     ratesCopy.sort((a, b) => b.time.compareTo(a.time));
    //   });
    // });
  }

  // void _onEntryAdded(Event event) {
  //   setState(() {
  //     var cheese = Cheese.fromSnapshot(event.snapshot);
  //     cheeses[cheese.id.toString()] = cheese;
  //   });
  // }

  void _onEntryRemoved(Event event) {
    setState(() {});
  }

  @override
  void dispose() {
    // user = null;
    // streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var container = AppStateContainer.of(context);
    appState = container.state;
    Map<String, Cheese> cheeses = appState.cheeses;
    User user = appState.user;
    List<CheckIn> checkins = user.checkins.values.toList();
    List<Rating> ratings = user.ratings.values.toList();
    checkins.sort((a, b) => b.time.compareTo(a.time));
    ratings.sort((a, b) => b.time.compareTo(a.time));

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.history),
              ),
              Tab(
                icon: Icon(Icons.star),
              ),
            ],
          ),
          title: Text("History"),
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                print("pressed back button");
                // Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(
                    context, "/", ModalRoute.withName('/'));
              }),
        ),
        body: TabBarView(
          children: <Widget>[
            (user.checkins.isEmpty)
                ? Card(
                    child: Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                          "Your history section is empty. Go check out some new cheeses! "),
                    ),
                  )
                : ListView.builder(
                    itemCount: checkins.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.all(5.0),
                        child: HistoryCard(
                          checkin: checkins[index],
                          cheese: cheeses[checkins[index].cheeseId],
                          // userId: userIdCopy,
                        ),
                      );
                    },
                  ),
            (user.ratings.isEmpty)
                ? Card(
                    child: Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                          "Your starred section is empty. Go rate some new cheeses! "),
                    ),
                  )
                : ListView.builder(
                    itemCount: ratings.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.all(5.0),
                        child: StarredCard(
                          rating: ratings[index],
                          cheese: cheeses[ratings[index].cheeseId],
                          // userId: userIdCopy,
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
