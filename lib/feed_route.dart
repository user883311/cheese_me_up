//
//
//
import 'package:flutter/material.dart';

class FeedRoute extends StatefulWidget {
  FeedRoute();
  @override
  _FeedRoute createState() => new _FeedRoute();
}

class _FeedRoute extends State<FeedRoute> {
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
