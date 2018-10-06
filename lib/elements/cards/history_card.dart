import 'package:cheese_me_up/elements/time.dart';
import 'package:cheese_me_up/models/checkin.dart';
import 'package:cheese_me_up/models/cheese.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HistoryCard extends StatelessWidget {
  final CheckIn checkin;
  final Cheese cheese;
  final String userId;

  HistoryCard({
    this.checkin,
    this.userId,
    @required this.cheese,
  });

  @override
  // TODO: add 2 separate tabs: CHECKINS and RATINGS
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${relevantTimeSince(checkin.time)["durationInt"]} ${relevantTimeSince(checkin.time)["unit"]} ago",
              textScaleFactor: 1.2,
            ),
            RawMaterialButton(
              child: Text("\n${cheese.name}"),
              onPressed: () => Navigator.pushNamed(
                  context, "/cheese_route/${cheese.id}/$userId"),
            ),
            Row(children: [
              IconButton(
                iconSize: 3.0,
                icon: new Image.asset('assets/media/icons/trophy.png'),
                onPressed: () {},
              ),
              Text("+ ${checkin.points} points"),
            ]),
          ],
        ),
      ),
    );
  }
}
