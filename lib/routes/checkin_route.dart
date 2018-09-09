import 'dart:async';
import 'package:cheese_me_up/elements/cheese_tile.dart';
import 'package:cheese_me_up/models/checkin.dart';
import 'package:cheese_me_up/models/cheese.dart';
import 'package:cheese_me_up/models/user.dart';
import 'package:cheese_me_up/utils/database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

String userIdCopy;
User user;

class CheckinRoute extends StatefulWidget {
  CheckinRoute({this.userId});
  final String userId;

  @override
  _CheckinRoute createState() {
    userIdCopy = userId;
    return _CheckinRoute();
  }
}

class _CheckinRoute extends State<CheckinRoute> {
  List<Cheese> cheeses = List();
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

    _userRef = database.reference().child("users/$userIdCopy");
    streamSubscription = _userRef.onValue.listen((Event event) {
      user = new User.fromSnapshot(event.snapshot);
    });
  }

  @override
  void dispose() {
    // user=null;
    streamSubscription.cancel();
    super.dispose();
  }

  void _onEntryAdded(Event event) {
    setState(() {
      cheeses.add(Cheese.fromSnapshot(event.snapshot));
      _cheesesShortlist.add(Cheese.fromSnapshot(event.snapshot));
    });
  }

  Future _checkCheeseInIntent(CheckIn checkin) async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return new SimpleDialog(
            title: Text('Do you want to check ${checkin.cheese.name} in?'),
            children: <Widget>[
              new SimpleDialogOption(
                  onPressed: () async {
                    TransactionResult resultTransaction =
                        await _checkin(checkin);
                    Navigator.pop(context, resultTransaction.committed);
                  },
                  child: const Text('Yes')),
              new SimpleDialogOption(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('No')),
            ],
          );
        })) {
      case true:
        Navigator.pop(context);
        Navigator.pushNamed(context, "/feed_route/$userIdCopy");
        break;

      case false:
        Navigator.pop(context);
        break;

      default:
        break;
    }
  }

  Future<TransactionResult> _checkin(CheckIn checkin) async {
    DatabaseReference _oldUserCheckinsRef = FirebaseDatabase.instance
        .reference()
        .child('users/$userIdCopy/checkins');

    TransactionResult result =
        await writeNewElementToDatabase(checkin.toJson(), _oldUserCheckinsRef);
    return result;
  }

  void refreshSearch(String string) {
    setState(() {
      print(string);
      _cheesesShortlist = [];
      for (Cheese cheese in cheeses) {
        if (cheese.fullSearch.toLowerCase().contains(string.toLowerCase())) {
          _cheesesShortlist.add(cheese);
        }
      }
      print(cheeses);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                    user, _cheesesShortlist[index], _checkCheeseInIntent);
              },
            ),
          ),
        ],
      ),
    );
  }
}
