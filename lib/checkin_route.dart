//
//
//
import 'dart:async';
import 'package:cheese_me_up/models/user_cheese.dart';
import 'package:cheese_me_up/utils/database.dart';
import 'package:cheese_me_up/utils/points_scorer.dart';
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

    // We need to know the user to attribute points.
    _userRef = database.reference().child("users/$userIdCopy");
    _userRef.onValue.listen((Event event) {
      user = new User.fromSnapshot(event.snapshot);
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
        // TODO: create AlertBox to notify checkin successful
        
        // go back to Feed Route
        Navigator.pop(context);
        // push replacement to reinitialized the feed automatically
        Navigator.pushReplacementNamed(context, "/feed_route");
        break;

      case false:
        // TODO: create AlertBox to notify checkin UNsuccessful

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
    // TODO: create responsive results, based on string
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
          controller: searchText,
          onChanged: refreshSearch,
          decoration: InputDecoration(
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
                  return cheeseTile(cheeses[index], _checkCheeseInIntent);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget cheeseTile(Cheese cheese, onTap) {
  return Card(
    child: ListTile(
      trailing: new Container(
        width: 100.0,
        height: 50.0,
        child: Container(
          child: new Image.asset(
            "assets/media/img/cheese/" + cheese.image,
            fit: BoxFit.cover,
          ),
        ),
      ),
      leading: CircleAvatar(
        backgroundColor: Colors.orange[100],
        foregroundColor: Colors.black,
        child: new Text(cheese.name.substring(0, 2).toUpperCase()),
      ),
      title: new Text(cheese.name),
      subtitle: new Text(cheese.region + ", " + cheese.country),
      onTap: () async {
        print("Tapped dat ${cheese.name}!");
        onTap(CheckIn.fromCheeseDateTime(
          cheese,
          DateTime.now(),
          pointsForNewCheese(cheese, user),
        ));
      },
    ),
  );
}
