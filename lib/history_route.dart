import 'package:cheese_me_up/models/user_cheese.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

User user;
String userIdCopy;
List<CheckIn> checkinsCopy = [];

class HistoryRoute extends StatefulWidget {
  final String userId;
  final String drawerTitle = "History";

  HistoryRoute({
    Key key,
    this.userId,
  });

  @override
  _HistoryRouteState createState() {
    userIdCopy = userId;
    return new _HistoryRouteState();
  }
}

class _HistoryRouteState extends State<HistoryRoute> {
  // Use a list to be able to sort checkins.
  // List<CheckIn> checkins = [];

  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference _userRef;

  @override
  void initState() {
    super.initState();
    _userRef = database.reference().child("users/$userIdCopy");
    _userRef.onValue.listen((Event event) {
      setState(() {
        user = new User.fromSnapshot(event.snapshot);
      });
    });

    checkinsCopy.sort((a, b) => b.time.compareTo(a.time));
  }

  Map<String, dynamic> relevantTimeSince(DateTime from) {
    return relevantTime(DateTime.now().difference(from));
  }

  Map<String, dynamic> relevantTime(Duration duration) {
    int seconds = duration.inSeconds;
    int durationInt;
    String unit;

    if (seconds < 60) {
      durationInt = duration.inSeconds;
      unit = "seconds";
    } else if (seconds < 60 * 60) {
      durationInt = duration.inMinutes;
      unit = "minutes";
    } else if (seconds < 60 * 60 * 24) {
      durationInt = duration.inHours;
      unit = "hours";
    } else {
      durationInt = duration.inDays;
      unit = "days";
    }

    return {"durationInt": durationInt, "unit": unit};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("History"),
      ),
      body: ListView.builder(
        itemCount: user.checkins.length,
        itemBuilder: (context, index) {
          return Text(
              "cheese # $index: ${user.checkins.values.elementAt(index).cheese.name}, ${relevantTimeSince(user.checkins.values.elementAt(index).time)["durationInt"]} ${relevantTimeSince(user.checkins.values.elementAt(index).time)["unit"]} ago");
        },
        padding: EdgeInsets.zero,
      ),
    );
  }
}
