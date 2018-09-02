import 'package:cheese_me_up/models/checkin.dart';
import 'package:cheese_me_up/models/user.dart';
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
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference _userRef;

  @override
  void initState() {
    super.initState();
    _userRef = database.reference().child("users/$userIdCopy");
    _userRef.onValue.listen((Event event) {
      setState(() {
        user = new User.fromSnapshot(event.snapshot);
        checkinsCopy = user.checkins.values.toList();
        checkinsCopy.sort((a, b) => b.time.compareTo(a.time));
      });
    });
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
      body: user == null
          ? null
          : ListView.builder(
              itemCount: checkinsCopy.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.all(5.0),
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${checkinsCopy.length - index}, ${checkinsCopy[index].cheese.name} ",
                            textScaleFactor: 1.2,
                          ),
                          Text(
                              "${relevantTimeSince(checkinsCopy[index].time)["durationInt"]} ${relevantTimeSince(checkinsCopy[index].time)["unit"]} ago"),
                          Row(children: [
                            IconButton(
                              iconSize: 3.0,
                              icon: new Image.asset(
                                  'assets/media/icons/trophy.png'),
                              onPressed: () {},
                            ),
                            Text("+ ${checkinsCopy[index].points} points"),
                          ]),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
