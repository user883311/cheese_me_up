import 'package:cheese_me_up/elements/sentence.dart';
import 'package:cheese_me_up/models/user.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

User user;
String userIdCopy;

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

  @override
  void initState() {
    super.initState();
    print("initState()...");
    _userRef = database.reference().child("users/$userIdCopy");
    _userRef.onValue.listen((Event event) {
      setState(() {
        user = new User.fromSnapshot(event.snapshot);
      });
    });
  }

  void _goCheckinRoute() {
    Navigator.pushNamed(context, '/checkin_route/$userIdCopy');
  }

  @override
  Widget build(BuildContext context) {
    // setState(() {});
    return Scaffold(
      appBar: AppBar(
        leading: Text(""),
        title: Text("Home"),
      ),
      body: ListView(
        // TODO: add cards, take inspiration from Wikipedia app:
        // All time best, Today's cheese, Country Focus, etc.
        children: <Widget>[
          user == null ? Text("Loading...") : new AllTimeCard(),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.orange,
        child: ButtonBar(
          alignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: new Icon(Icons.history),
              onPressed: () {
                Navigator.pushNamed(context, '/history_route/$userIdCopy');
              },
            ),
            IconButton(
              icon: new Icon(Icons.playlist_add_check),
              onPressed: _goCheckinRoute,
            ),
            IconButton(
              icon: new Icon(Icons.settings),
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

class AllTimeCard extends StatefulWidget {
  const AllTimeCard({Key key});

  @override
  _AllTimeCard createState() => new _AllTimeCard();
}

class _AllTimeCard extends State<AllTimeCard> {
  var sentence;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    sentence = new Sentence(user: user);

    return Card(
      margin: EdgeInsets.all(10.0),
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Text(
            "${sentence.greetings} \n\n${sentence.recapTotalPointsToDate}.\n ${user.checkins.length} cheeses ever, and ${user.uniqueCheeses.length} unique cheeses: ${sentence.uniqueCheesesListSentence}"),
      ),
    );
  }
}
