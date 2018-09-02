import 'package:cheese_me_up/elements/cheese_tile.dart';
import 'package:cheese_me_up/elements/sentence.dart';
import 'package:cheese_me_up/models/checkin.dart';
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
          (user == null || user.checkins.isEmpty)
              ? Text("")
              : new RememberCard(),
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
                  Text("+1")
                ],
              ),
            ),
            // IconButton(
            //   icon: Image.asset("assets/media/icons/cheese_color.png"),
            //   onPressed: _goCheckinRoute,
            // ),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${sentence.greetings}\n",
              textScaleFactor: 1.2,
            ),
            Text("${sentence.recapTotalPointsToDate}."),
            (sentence.uniqueCheesesListSentence == null)
                ? Text("")
                : Text("\n${sentence.uniqueCheesesListSentence}."),
          ],
        ),
      ),
    );
  }
}

class RememberCard extends StatefulWidget {
  const RememberCard({Key key});

  @override
  RememberCardState createState() => new RememberCardState();
}

class RememberCardState extends State<RememberCard> {
  var sentence;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    sentence = new Sentence(user: user);
    CheckIn randomCheckin = user.randomCheckin;
    return Card(
      margin: EdgeInsets.all(10.0),
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Remember?\n",
              textScaleFactor: 1.2,
            ),
            Text("${sentence.rememberCheckin(randomCheckin)}.\n "),
            cheeseTile(user, randomCheckin.cheese, () {}, false),
          ],
        ),
      ),
    );
  }
}
