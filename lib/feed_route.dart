//
//
//
import 'dart:async';

import 'package:cheese_me_up/models/cheese.dart';
import 'package:cheese_me_up/models/user.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:convert' show json, utf8;

class FeedRoute extends StatefulWidget {
  FeedRoute();
  @override
  _FeedRoute createState() => new _FeedRoute();
}

class _FeedRoute extends State<FeedRoute> {
  var user;
  List<Cheese> cheesesList;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference _userRef, _cheesesRef;

  final int userId = 0;
  String str = "initial value";
  List tempList = List();

  @override
  void initState() {
    super.initState();

    // Create the 2 required references to the current user
    // and repository of cheeses.
    _userRef = database.reference().child("users/$userId");
    _cheesesRef = database.reference().child("cheeses");

    _userRef.once().then((DataSnapshot snapshot) {
      setState(() {
        print('Connected to the user database and read ${snapshot.value}');
        str = snapshot.value.toString();
        user = new User.fromSnapshot(snapshot);
        print('Howdy, ${user.username}, user ID ${user.id}!');
        print('We sent the verification link to ${user.email}.');
        print('Your pw is ${user.password}.');
        print('Your list of cheeses is ${user.cheeses}.');
      });
    });

    _cheesesRef.once().then((DataSnapshot snapshot) {
      setState(() {
        print('Connected to the cheese database and read ${snapshot.value[2]}');
      });
    });
  }

  Future<Cheese> getCheeseFromId(int id) async {
    _cheesesRef.once().then((DataSnapshot snapshot) {
      DatabaseReference _uniqueCheeseRef =
          database.reference().child("cheeses/$id");

      _uniqueCheeseRef.once().then((DataSnapshot snapshot) {
        setState(() {
          return Cheese.fromSnapshot(snapshot);
        });
      });
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
          user == null
              ? Text("loading...")
              : Text(
                  "Howdy, ${user.username}, user ID ${user.id}. You have tried ${user.cheeses.length} cheeses, and the first one was id# ${user.cheeses[0]["id"]}"),
          RaisedButton(
            child: Text("check-in"),
            onPressed: _goCheckIn,
            color: Colors.blue,
          ),
        ],
      ),
    );
  }

  void _goCheckIn() {
    Navigator.pushNamed(context, '/checkin_route');
  }
}
