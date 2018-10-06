import 'package:cheese_me_up/elements/time.dart';
import 'package:cheese_me_up/models/cheese.dart';
import 'package:cheese_me_up/models/rating.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class StarredCard extends StatelessWidget {
  final Rating rating;
  final Cheese cheese;
  final String userId;

  StarredCard({
    this.rating,
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
              "${relevantTimeSince(rating.time)["durationInt"]} ${relevantTimeSince(rating.time)["unit"]} ago",
              textScaleFactor: 1.2,
            ),
            RawMaterialButton(
              child: Text("\n${cheese.name}"),
              onPressed: () => Navigator.pushNamed(context, "/cheese_route/${cheese.id}/$userId"),
            ),
            Row(children: [
              Text("${rating.rating}"),
              Icon(Icons.star, color: Colors.brown,),
            ]),
          ],
        ),
      ),
    );
  }
}
