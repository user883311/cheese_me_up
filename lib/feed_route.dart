//
//
//
import 'dart:async';

import 'package:cheese_me_up/models/cheese.dart';
import 'package:cheese_me_up/models/user.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'dart:convert' show json, utf8;

var user;
var test2;
List<Cheese> cheeses = List();

class FeedRoute extends StatefulWidget {
  FeedRoute();

  @override
  _FeedRoute createState() => new _FeedRoute();
}

class _FeedRoute extends State<FeedRoute> {
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference _userRef, _cheesesRef;

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

    // Cheeses:
    _cheesesRef = database.reference().child("cheeses");
    _cheesesRef.once().then((DataSnapshot snapshot) {
      setState(() {
        test2 = "test2";
        cheeses.add(Cheese.fromSnapshot(snapshot));
      });
      print('Connected to the CHEESES database and read ${snapshot.value}');
    });
  }

  // void _onEntryAdded(Event event) {
  //   setState(() {
  //     cheeses.add(Cheese.fromSnapshot(event.snapshot));
  //   });
  //   print(cheeses);
  //   print("all cheeses " + cheeses.toString());
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Feed / Home"),
      ),
      body: ListView(
        children: <Widget>[
          user == null ? Text("loading...") : AllTimeCard(),
          RaisedButton(
            child: Text("check-in"),
            onPressed: _goCheckinRoute,
            color: Colors.blue,
          ),
          RandomCheeseCard(),
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

class RandomCheeseCard extends StatefulWidget {
  @override
  _RandomCheeseCard createState() => new _RandomCheeseCard();
}

class _RandomCheeseCard extends State<RandomCheeseCard> {
  @override
  void initState() {
    super.initState();
  }

  var test = cheeses == null ? "null" : cheeses.toString();
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Text("cheeses value is: $test and $test2"),
    );
  }
}
