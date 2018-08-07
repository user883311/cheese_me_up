//
//
//
import 'package:cheese_me_up/models/user.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

var user;

class FeedRoute extends StatefulWidget {
  FeedRoute();

  @override
  _FeedRoute createState() => new _FeedRoute();
}

class _FeedRoute extends State<FeedRoute> {
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference _userRef;

  final int userId = 0;

  @override
  void initState() {
    super.initState();
    // I need 2 things: the current user,
    // and repository of all cheeses.

    // User:
    _userRef = database.reference().child("users/$userId");
    _userRef.once().then((DataSnapshot snapshot) {
      setState(() {
        user = new User.fromSnapshot(snapshot);
      });
      print('Connected to the user database and read ${snapshot.value}');
      print('Howdy, ${user.username}, user ID ${user.id}!');
      print('We sent the verification link to ${user.email}.');
      print('Your pw is ${user.password}.');
      print('Your list of cheeses is ${user.cheeses}.');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Feed / Home"),
      ),
      body: ListView(
        children: <Widget>[
          user == null ? Text("loading...") : AllTimeCard(),
        ],
      ),
      bottomNavigationBar: ButtonBar(
        alignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
            icon: new Icon(Icons.history),
            onPressed: () => null,
          ),
          IconButton(
            icon: new Icon(Icons.playlist_add_check),
            onPressed: _goCheckinRoute,
          ),
          IconButton(
            icon: new Icon(Icons.settings),
            onPressed: () => null,
          ),
        ],
      ),
    );
  }

  void _goCheckinRoute() {
    Navigator.pushNamed(context, '/checkin_route');
  }
}

class AllTimeCard extends StatefulWidget {
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
      child: Text(
          "Howdy, ${user.username}, To this day, you have scored ${user.cheeses.length} cheeses, and the first one was id# ${user.cheeses[0]["id"]}"),
    );
  }
}
