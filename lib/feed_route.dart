import 'package:cheese_me_up/models/user_cheese.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

User user;
String userIdCopy;

// class FeedRouteStateless extends StatelessWidget {
//   final String userIdBis;

//   @override
//   Widget build(BuildContext context) {
//     return null;
//   }
// }

class FeedRoute extends StatefulWidget {
  FeedRoute({this.userId});
  final String userId;

  @override
  _FeedRoute createState() {
    userIdCopy = userId;
    return new _FeedRoute();
  }
}

class _FeedRoute extends State<FeedRoute> {
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference _userRef;

  @override
  void initState() {
    super.initState();
    print("userId is: $userIdCopy");
    _userRef = database.reference().child("users/$userIdCopy");
    _userRef.onValue.listen((Event event) {
      setState(() {
        user = new User.fromSnapshot(event.snapshot);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Feed / Home"),
      ),
      body: ListView(
        children: <Widget>[
          user == null
              ? Text("Loading...")
              : AllTimeCard(
                  user: user,
                ),
        ],
      ),
      bottomNavigationBar: ButtonBar(
        alignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
            icon: new Icon(Icons.history),
            onPressed: () => null,
          ),
          IconButton(
            icon: new Icon(Icons.playlist_add_check),
            onPressed: _goCheckinRoute,
          ),
          IconButton(
            icon: new Icon(Icons.settings),
            onPressed: () => null,
          ),
        ],
      ),
      drawer: (user == null) ? null : HistoryDrawer(),
    );
  }

  void _goCheckinRoute() {
    Navigator.pushNamed(context, '/checkin_route/$userIdCopy');
  }
}

class AllTimeCard extends StatefulWidget {
  // TODO: do I really need to require this parameter,
  // if only one user is ever going to be using the
  // app at one given time?
  final User user;
  const AllTimeCard({Key key, @required this.user})
      : assert(user != null),
        super(key: key);

  @override
  _AllTimeCard createState() => new _AllTimeCard();
}

class _AllTimeCard extends State<AllTimeCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Text(
          "Howdy, ${user.username}!\n\nTo this day, you have scored ${user.checkins.length} checkins, and the first one was... ${(user.checkins.length == 0) ? "NONE" : user.checkins.values.first.cheese.name}.\nThe latest one was... ${(user.checkins.length == 0) ? "NONE" : user.checkins.values.last.cheese.name}."),
    );
  }
}

class HistoryDrawer extends StatefulWidget {
  final String drawerTitle = "History";
  HistoryDrawer({Key key}) : super(key: key);

  @override
  _HistoryDrawerState createState() => new _HistoryDrawerState();
}

class _HistoryDrawerState extends State<HistoryDrawer> {
  // Use a list to be able to sort checkins.
  List<CheckIn> checkins = [];

  @override
  void initState() {
    super.initState();
    for (CheckIn item in user.checkins.values) {
      checkins.add(item);
    }
    checkins.sort((a, b) => b.time.compareTo(a.time));
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

  Widget _builder(context, index) {
    return Text(
        "cheese # $index: ${checkins[index].cheese.name}, ${relevantTimeSince(checkins[index].time)["durationInt"]} ${relevantTimeSince(checkins[index].time)["unit"]} ago}");
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Scaffold(
        appBar: AppBar(
          title: Text("History"),
        ),
        body: ListView.builder(
          itemCount: user.checkins.length,
          itemBuilder: _builder,
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
