import 'package:cheese_me_up/models/user_cheese.dart';
import 'package:cheese_me_up/sentence.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

User user;
String userIdCopy;

void updateCheckins() async {
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference _userRef, _checkinRef;
  _checkinRef = database.reference().child("users/$userIdCopy/checkins");
  _checkinRef.onChildAdded.listen((_) {
    _userRef = database.reference().child("users/$userIdCopy");
    _userRef.onValue.listen((Event event) {
      user = new User.fromSnapshot(event.snapshot);
    });
  });
}

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
      user = new User.fromSnapshot(event.snapshot);
    });
  }

  void _goCheckinRoute() {
    Navigator.pushNamed(context, '/checkin_route/$userIdCopy');
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
        children: <Widget>[
          user == null
              ? Text("Loading...")
              : new AllTimeCard(
                  user: user,
                ),
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
  // TODO: do I really need to require this parameter,
  // if only one user is ever going to be using the
  // app at one given time?
  final User user;

  const AllTimeCard({Key key, @required this.user})
      : assert(user != null),
        super(key: key);

  @override
  _AllTimeCard createState() => new _AllTimeCard();
}

class _AllTimeCard extends State<AllTimeCard> {
  var sentence;

  @override
  void initState() {
    super.initState();
    sentence = new Sentence(user: user);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Text(
            "${sentence.greetings} \n\n${sentence.recapTotalPointsToDate}.\n ${user.checkins.length} cheeses ever, and ${user.uniqueCheeses.length} unique cheeses: ${user.uniqueCheeses.toString()}"),
      ),
    );
  }
}
