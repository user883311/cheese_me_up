import 'package:cheese_me_up/models/user_cheese.dart';
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
    print("userId is: $userIdCopy");
    _userRef = database.reference().child("users/$userIdCopy");
    _userRef.onValue.listen((Event event) {
      setState(() {
        user = new User.fromSnapshot(event.snapshot);
      });
    });
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
              : AllTimeCard(
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

  void _goCheckinRoute() {
    Navigator.pushNamed(context, '/checkin_route/$userIdCopy');
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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Text(
            "Howdy, ${user.username}!\n\nTo this day, you have scored ${user.checkins.length} checkins, and the first one was... ${(user.checkins.length == 0) ? "NONE" : user.checkins.values.first.cheese.name}.\nThe latest one was... ${(user.checkins.length == 0) ? "NONE" : user.checkins.values.last.cheese.name}."),
      ),
    );
  }
}
