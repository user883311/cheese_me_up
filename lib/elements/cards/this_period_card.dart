import 'package:cheese_me_up/elements/cards/themed_card.dart';
import 'package:cheese_me_up/elements/sentence.dart';
import 'package:cheese_me_up/models/checkin.dart';
import 'package:cheese_me_up/models/cheese.dart';
import 'package:cheese_me_up/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ThisPeriodCard extends StatefulWidget {
  final String periodName;
  final User user;
  final Map<String, Cheese> cheeses;

  const ThisPeriodCard({
    Key key,
    this.periodName,
    this.user,
    this.cheeses,
  })  : assert(periodName != null),
        assert(user != null);

  @override
  ThisPeriodCardState createState() => new ThisPeriodCardState(
      user: user, periodName: periodName, cheeses: cheeses);
}

class ThisPeriodCardState extends State<ThisPeriodCard> {
  String periodName;
  User user;
  Map<String, Cheese> cheeses;

  ThisPeriodCardState({
    this.periodName,
    this.user,
    this.cheeses,
  })  : assert(periodName != null),
        assert(user != null);

  DateTime from;
  DateTime to;
  Iterable<Cheese> cheeseList;
  Sentence sentence;

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
        from = to.subtract(Duration(days: 30));
        break;

      case "year":
        to = DateTime.now();
        from = to.subtract(Duration(days: 365));
        break;

      default:
    }

    cheeseList = user.getCheckinsFromPeriod(from, to).map((CheckIn checkin) {
      return cheeses[checkin.cheeseId]; //checkin.cheese
    });

    sentence = new Sentence(user: user, cheeses: cheeses);
  }

  @override
  Widget build(BuildContext context) {
    return ThemedCard(
      margin: EdgeInsets.all(10.0),
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "This past $periodName\n",
              textScaleFactor: 1.2,
            ),
            (from == null && to == null)
                ? null
                : Text(
                    "${(cheeseList.length > 8) ? "Oh my God! You've already had " : "You've had "}${cheeseList.length} cheeses! ${sentence.listOfCheeseNames(cheeseList)}."),
          ],
        ),
      ),
    );
  }
}
