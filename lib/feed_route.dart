//
//
//
import 'package:cheese_me_up/models/user.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';


class FeedRoute extends StatefulWidget {
  FeedRoute();
  @override
  _FeedRoute createState() => new _FeedRoute();
}

class _FeedRoute extends State<FeedRoute> {
  List<User> userCheesesList = List();
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReference;
  final int userId = 0;

  @override
  void initState() {
    
    super.initState();
    databaseReference =
        database.reference().child("users").child(userId.toString());
    databaseReference.onChildAdded.listen(_onEntryAdded);
  }

  void _onEntryAdded(Event event) {
    setState(() {
      userCheesesList.add(User.fromSnapshot(event.snapshot));
      print(userCheesesList);
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
          RaisedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("back to login")),
          AllTimeContainer(),
        ],
      ),
      persistentFooterButtons: <Widget>[
        Center(
          child: FlatButton(
            child: Text("check-in"),
            onPressed: _goCheckIn,
          ),
        ),
      ],
    );
  }

  void _goCheckIn() {
    Navigator.pushNamed(context, '/checkin_route');
  }
}

class AllTimeContainer extends StatefulWidget {
  AllTimeContainer();
  @override
  _AllTimeContainer createState() => new _AllTimeContainer();
}

class _AllTimeContainer extends State<AllTimeContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("All time cheeses tried"),
    );
  }
}
