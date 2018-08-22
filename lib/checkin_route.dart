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
  DatabaseReference _cheesesRef;
  TextEditingController searchText;

  @override
  void initState() {
    super.initState();
    _cheesesRef = database.reference().child("cheeses");
    _cheesesRef.onChildAdded.listen(_onEntryAdded);
  }

  void _onEntryAdded(Event event) {
    setState(() {
      cheeses.add(Cheese.fromSnapshot(event.snapshot));
    });
  }

  Future _checkCheeseInIntent(CheckIn checkin) async {
    print("onTap($checkin).. _checkCheeseInIntent --");
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return new SimpleDialog(
            title: Text('Do you want to check $checkin in?'),
            children: <Widget>[
              new SimpleDialogOption(
                onPressed: () {
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
    print("the search string is : $string");
    setState(() {
      _cheesesRef =
          database.reference().child("cheeses").orderByKey().equalTo(string);
      _cheesesRef.onChildAdded.listen(_onEntryAdded);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Check in a new cheese!"),
      ),
      body: Column(
        children: <Widget>[
          TextField(
            controller: searchText,
            onChanged: refreshSearch,
          ),
          Flexible(
            child: FirebaseAnimatedList(
              query: _cheesesRef,
              itemBuilder: (context, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                return cheeseTile(cheeses[index], _checkCheeseInIntent);
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
      leading: CircleAvatar(
        backgroundColor: Colors.red,
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
