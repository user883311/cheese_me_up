//
//
//
import 'dart:async';
import 'package:cheese_me_up/models/user_cheese.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

String userIdCopy;

class CheckinRoute extends StatefulWidget {
  CheckinRoute({this.userId});
  final String userId;

  @override
  _CheckinRoute createState() {
    print("userIdCopy $userIdCopy");
    userIdCopy = userId;
    return _CheckinRoute();
  }
}

class _CheckinRoute extends State<CheckinRoute> {
  List<Cheese> cheeses = List();
  Cheese cheese;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  Query _cheesesRef;
  TextEditingController searchText;

  @override
  void initState() {
    super.initState();
    _cheesesRef = database.reference().child("cheeses").orderByChild("name");
    _cheesesRef.onChildAdded.listen(_onEntryAdded);
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
            title: Text('Do you want to check $checkin in?'),
            children: <Widget>[
              new SimpleDialogOption(
                onPressed: () {
                  // go back to Feed Route
                  Navigator.pop(context, true);
                  Navigator.pop(context, true);
                },
                child: const Text('Yes'),
              ),
              new SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text('No'),
              ),
            ],
          );
        })) {
      case true:
        _checkin(checkin);
        // TODO: create AlertBox to notify checkin successful
        print("$checkin was checked in, congrats!");
        break;
      case false:
        print("$checkin was NOT checked in, too bad!");
        break;
    }
  }

  Future<Null> _checkin(CheckIn checkin) async {
    DatabaseReference _userCheckinsRef = FirebaseDatabase.instance
        .reference()
        .child('users/$userIdCopy/checkins');
    print(userIdCopy);
    final TransactionResult transactionResult =
        await _userCheckinsRef.runTransaction((MutableData mutableData) async {
      print(mutableData.value);
      _userCheckinsRef.push(checkin.toJson()).set(checkin.toJson());
      return mutableData;
    });

    if (transactionResult.committed) {
      print("transactionResult.committed");
    } else {
      print('Transaction not committed.');
      if (transactionResult.error != null) {
        print(transactionResult.error.message);
      }
    }
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
      onTap: () {
        print("Tapped dat ${cheese.name}!");
        onTap(CheckIn.fromCheeseDateTime(cheese, DateTime.now()));
      },
    ),
  );
}
