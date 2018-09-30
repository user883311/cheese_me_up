import 'package:cheese_me_up/elements/cheese_tile.dart';
import 'package:cheese_me_up/elements/sentence.dart';
import 'package:cheese_me_up/models/checkin.dart';
import 'package:cheese_me_up/models/cheese.dart';
import 'package:cheese_me_up/models/user.dart';
import 'package:flutter/material.dart';

class RememberCard extends StatefulWidget {
  final User user;
  final Map<String, Cheese> cheeses;
  const RememberCard({Key key, @required this.user, this.cheeses})
      : assert(user != null);

  @override
  RememberCardState createState() => new RememberCardState(user: user, cheeses:cheeses);
}

class RememberCardState extends State<RememberCard> {
  User user;
  var sentence;
  Map<String, Cheese> cheeses;

  RememberCardState({
    this.user,
    this.cheeses,
  }) : assert(user != null);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    sentence = new Sentence(user: user, cheeses: cheeses);
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
            cheeseTile(cheeses[randomCheckin.cheeseId], user, () {}, false),
          ],
        ),
      ),
    );
  }
}
