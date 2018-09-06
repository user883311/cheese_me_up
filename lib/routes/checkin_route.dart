import 'dart:async';
import 'package:cheese_me_up/elements/cheese_tile.dart';
import 'package:cheese_me_up/models/checkin.dart';
import 'package:cheese_me_up/models/cheese.dart';
import 'package:cheese_me_up/models/user.dart';
import 'package:cheese_me_up/utils/database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

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
  Cheese cheese;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  Query _cheesesRef;
  DatabaseReference _userRef;
  TextEditingController searchText;

  @override
  void initState() {
    super.initState();
    _cheesesRef = database.reference().child("cheeses").orderByChild("name");
    _cheesesRef.onChildAdded.listen(_onEntryAdded);

    _userRef = database.reference().child("users/$userIdCopy");
    _userRef.onValue.listen((Event event) {
      // setState(() {
        user = new User.fromSnapshot(event.snapshot);
      // });
    });
  }

  void _onEntryAdded(Event event) {
    setState(() {
      cheeses.add(Cheese.fromSnapshot(event.snapshot));
    });
  }

  Future _checkCheeseInIntent(CheckIn checkin) async {
    // print("onTap($checkin).. _checkCheeseInIntent --");
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

        Navigator.pushReplacementNamed(context, "/feed_route/$userIdCopy");
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
    string = string.replaceAll("  ", " ");
    string = string.trim();
    print("the search string is : $string");

    setState(() {
      if (string.isEmpty) {
        for (Cheese cheese in cheeses) {
          cheese.show = true;
        }
        print("done");
      } else {
        // do the search in local, removing unmatching entries
        for (Cheese cheese in cheeses) {
          // RegExp r = new RegExp(string, caseSensitive: false);
          if (cheese.fullSearch.toLowerCase().contains(string.toLowerCase())) {
            cheese.show = true;
          } else {
            cheese.show = false;
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: false,
          controller: searchText,
          onChanged: refreshSearch,
          decoration: InputDecoration(
            hintStyle: TextStyle(color:Colors.white70),
            hintText: "Search cheese...",
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: FirebaseAnimatedList(
              query: _cheesesRef,
              itemBuilder: (context, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                if (cheeses[index].show) {
                  return cheeseTile(user, cheeses[index], _checkCheeseInIntent);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
