//
//
//
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

import './models/cheese.dart';

class CheckinRoute extends StatefulWidget {
  CheckinRoute();
  @override
  _CheckinRoute createState() => new _CheckinRoute();
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
    // print(cheeses);
  }

  Future _checkCheeseInIntent(Cheese cheese) async {
    print("onTap(${cheese.name}).. _checkCheeseInIntent --");
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return new SimpleDialog(
            title: Text('Do you want to check ${cheese.name} in?'),
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
        // save as new cheese in user cheeses repo
        _saveNewCheese(cheese);
        print("${cheese.name} was checked in, congrats!");
        break;
      case false:
        // go back to search results
        print("${cheese.name} was checked NOT in, too bad!");
        break;
    }
  }

  Future<Null> _saveNewCheese(Cheese cheese) async {
    final int userId = 0;
    DatabaseReference _userCheesesRef =
        FirebaseDatabase.instance.reference().child('users/$userId/cheeses');
    final TransactionResult transactionResult =
        await _userCheesesRef.runTransaction((MutableData mutableData) async {
      print(mutableData.value);
      _userCheesesRef.push(cheese.toJson()).set(cheese.toJson());
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
        onTap(cheese);
      },
    ),
  );
}
