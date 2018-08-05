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
  List<Cheese> cheeses = List();
  Cheese cheese;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference _cheesesRef;

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
    print(cheeses);
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
              query: _cheesesRef,
              itemBuilder: (_, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                return new Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.red,
                    ),
                    title: new Text(cheeses[index].name),
                    subtitle: new Text(cheeses[index].region +
                        ", " +
                        cheeses[index].country),
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
