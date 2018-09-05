import 'package:cheese_me_up/elements/cheese_tile.dart';
import 'package:cheese_me_up/elements/sentence.dart';
import 'package:cheese_me_up/elements/vertical_divider.dart';
import 'package:cheese_me_up/models/checkin.dart';
import 'package:cheese_me_up/models/cheese.dart';
import 'package:cheese_me_up/models/user.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

User user;
String userIdCopy;

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
    print("initState()...");
    _userRef = database.reference().child("users/$userIdCopy");
    _userRef.onValue.listen((Event event) {
      setState(() {
        user = new User.fromSnapshot(event.snapshot);
      });
    });
  }

  void _goCheckinRoute() {
    Navigator.pushNamed(context, '/checkin_route/$userIdCopy');
  }

  @override
  Widget build(BuildContext context) {
    // setState(() {});
    return Scaffold(
      appBar: AppBar(
        leading: Text(""),
        title: Text("Home"),
      ),
      body: ListView(
        // TODO: add cards, take inspiration from Wikipedia app:
        // All time best, Today's cheese, Country Focus, etc.
        children: user == null
            ? [Text("Loading...")]
            : <Widget>[
                new AllTimeCard(),
                (user.checkins.isEmpty)
                    ? new Icon(Icons.arrow_downward)
                    : new RememberCard(),
                (user.checkins.isEmpty)
                    ? null
                    : new ThisPeriodCard(
                        user: user,
                        periodName: "week",
                      ),
              ],
      ),
      bottomNavigationBar: Container(
        color: Colors.brown,
        child: ButtonBar(
          alignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Image.asset("assets/media/icons/history.png"),
              onPressed: () {
                Navigator.pushNamed(context, '/history_route/$userIdCopy');
              },
            ),
            Container(
              padding: EdgeInsets.all(5.0),
              decoration: new BoxDecoration(
                boxShadow: [
                  BoxShadow(color: Colors.brown[900], offset: Offset(2.0, 2.0))
                ],
                color: Colors.brown[800],
                borderRadius: BorderRadius.all(
                  Radius.circular(20.0),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Image.asset("assets/media/icons/cheese_color.png"),
                    onPressed: _goCheckinRoute,
                  ),
                  Text(
                    "+1",
                    style: TextStyle(color: Colors.orange[200]),
                  )
                ],
              ),
            ),
            IconButton(
              icon: Image.asset("assets/media/icons/settings.png"),
              onPressed: () {
                Navigator.pushNamed(context, '/settings_route/$userIdCopy');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AllTimeCard extends StatefulWidget {
  const AllTimeCard({Key key});

  @override
  _AllTimeCard createState() => new _AllTimeCard();
}

class _AllTimeCard extends State<AllTimeCard> {
  var sentence;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    sentence = new Sentence(user: user);

    return Card(
      margin: EdgeInsets.all(10.0),
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${sentence.greetings}\n",
              textScaleFactor: 1.2,
            ),
            Text("${sentence.recapTotalPointsToDate}."),
            (sentence.uniqueCheesesListSentence == null)
                ? Text("")
                : Text("\n${sentence.uniqueCheesesListSentence}."),
          ],
        ),
      ),
    );
  }
}

class RememberCard extends StatefulWidget {
  const RememberCard({Key key});

  @override
  RememberCardState createState() => new RememberCardState();
}

class RememberCardState extends State<RememberCard> {
  var sentence;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    sentence = new Sentence(user: user);
    CheckIn randomCheckin = user.randomCheckin;
    return Card(
      margin: EdgeInsets.all(10.0),
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Remember?\n",
              textScaleFactor: 1.2,
            ),
            Text("${sentence.rememberCheckin(randomCheckin)}."),
            cheeseTile(user, randomCheckin.cheese, () {}, false),
          ],
        ),
      ),
    );
  }
}

class ThisPeriodCard extends StatefulWidget {
  final String periodName;
  final User user;

  const ThisPeriodCard({
    Key key,
    this.periodName,
    this.user,
  })  : assert(periodName != null),
        assert(user != null);

  @override
  ThisPeriodCardState createState() =>
      new ThisPeriodCardState(user: user, periodName: periodName);
}

class ThisPeriodCardState extends State<ThisPeriodCard> {
  final String periodName;
  final User user;

  ThisPeriodCardState({
    this.periodName,
    this.user,
  });

  DateTime from;
  DateTime to;
  Iterable<Cheese> cheeseList;
  Sentence sentence ;

  @override
  void initState() {
    super.initState();
    switch (periodName) {
      case "week":
        to = DateTime.now();
        from = to.subtract(Duration(days: 7));
        break;

      case "month":
        to = DateTime.now();
        from = DateTime(to.year, to.month, 1);
        break;

      case "year":
        to = DateTime.now();
        from = DateTime(to.year, 1, 1);
        break;

      default:
    }

    cheeseList = user.getCheckinsFromPeriod(from, to).map((CheckIn checkin) {
      return checkin.cheese;
    });

    sentence = new Sentence(user: user);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "This $periodName\n",
              textScaleFactor: 1.2,
            ),
            (from == null && to == null)
                ? null
                : Text("This $periodName: ${cheeseList.length} cheeses! ${sentence.listOfCheeseNames(cheeseList)}."),
          ],
        ),
      ),
    );
  }
}
