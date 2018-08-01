//
//
//

import './models/cheese.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class CheckinRoute extends StatefulWidget {
  CheckinRoute();
  @override
  _CheckinRoute createState() => new _CheckinRoute();
}

class _CheckinRoute extends State<CheckinRoute> {
  List<Cheese> cheeseList = List();
  Cheese cheese;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReference;

  @override
  void initState() {
    super.initState();
    databaseReference = database.reference().child("cheeses");
    databaseReference.onChildAdded.listen(_onEntryAdded);
  }

  void _onEntryAdded(Event event) {
    setState(() {
      cheeseList.add(Cheese.fromSnapshot(event.snapshot));
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
          TextField(),
          Flexible(
            child: FirebaseAnimatedList(
              query: databaseReference,
              itemBuilder: (_, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                return new Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.red,
                    ),
                    title: new Text(cheeseList[index].name),
                    subtitle: new Text(cheeseList[index].region +
                        ", " +
                        cheeseList[index].country),
                    onTap: _tappedTile,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _tappedTile() {
    print("tapp dat cheese!");
  }
}
