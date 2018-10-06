import 'dart:async';
import 'package:cheese_me_up/elements/cheese_tile.dart';
import 'package:cheese_me_up/models/cheese.dart';
import 'package:cheese_me_up/models/user.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

String userIdCopy;
User user;

class CheckinRoute extends StatefulWidget {
  CheckinRoute({this.userId});
  final String userId;

  @override
  CheckinRouteState createState() {
    userIdCopy = userId;
    return CheckinRouteState();
  }
}

class CheckinRouteState extends State<CheckinRoute> {
  Map<String, Cheese> cheeses = new Map();
  List<Cheese> _cheesesShortlist = List();
  Cheese cheese;

  final FirebaseDatabase database = FirebaseDatabase.instance;
  Query _cheesesRef;
  DatabaseReference _userRef;
  TextEditingController _searchStringController;
  StreamSubscription streamSubscription;

  @override
  void initState() {
    super.initState();
    _cheesesRef = database.reference().child("cheeses").orderByChild("name");
    _cheesesRef.onChildAdded.listen(_onEntryAdded);

    if (userIdCopy != null && userIdCopy != "") {
      _userRef = database.reference().child("users/$userIdCopy");
      streamSubscription = _userRef.onValue.listen((Event event) {
        user = new User.fromSnapshot(event.snapshot);
      });
    }
  }

  @override
  void dispose() {
    // TODO: replace user=null by disconnecting from Firebase 
    // & checking on connection status
    user=null;
    if (streamSubscription != null) {
      streamSubscription.cancel();
    }
    super.dispose();
  }

  void _onEntryAdded(Event event) {
    setState(() {
      var cheese = Cheese.fromSnapshot(event.snapshot);
      cheeses[cheese.id.toString()] = cheese;
      _cheesesShortlist.add(cheese);
    });
  }

  void refreshSearch(String string) {
    setState(() {
      print(string);
      _cheesesShortlist = [];
      for (Cheese cheese in cheeses.values) {
        if (cheese.fullSearch.toLowerCase().contains(string.toLowerCase())) {
          _cheesesShortlist.add(cheese);
        }
      }
      print(cheeses);
    });
  }

  void tappedCheeseTile(Cheese cheese, [User user]) {
    // open the Cheese bottom sheet
    Navigator.pushNamed(context, "/cheese_route/${cheese.id}/$userIdCopy");

    // showModalBottomSheet(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return CheeseRoute(cheeseId: cheese.name);
    //     });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              if (userIdCopy != null && userIdCopy != "") {
                print("pressed back button");
                Navigator.pushReplacementNamed(
                    context, '/feed_route/$userIdCopy');
              } else {
                Navigator.pushNamedAndRemoveUntil(
                    context, "/", ModalRoute.withName('/'));
              }
            }),
        title: TextField(
          autofocus: false,
          controller: _searchStringController,
          onChanged: refreshSearch,
          decoration: InputDecoration(
            hintStyle: TextStyle(color: Colors.white70),
            hintText: "Search cheese...",
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              itemCount: _cheesesShortlist.length,
              itemBuilder: (context, index) {
                return cheeseTile(
                    _cheesesShortlist[index], user, tappedCheeseTile, false);
              },
            ),
          ),
        ],
      ),
    );
  }
}
