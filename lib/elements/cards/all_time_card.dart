import 'package:cheese_me_up/elements/cards/themed_card.dart';
import 'package:cheese_me_up/elements/sentence.dart';
import 'package:cheese_me_up/models/cheese.dart';
import 'package:cheese_me_up/models/user.dart';
import 'package:flutter/material.dart';

class AllTimeCard extends StatefulWidget {
  final User user;
  final Map<String, Cheese> cheeses;
  
  const AllTimeCard({
    Key key,
    this.user,
    this.cheeses,
  }) : assert(user != null);

  @override
  AllTimeCardState createState() => new AllTimeCardState(user: user, cheeses:cheeses);
}

class AllTimeCardState extends State<AllTimeCard> {
  User user;
  Map<String, Cheese> cheeses;

  AllTimeCardState({this.user, this.cheeses}) : assert(user != null);
  var sentence;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    sentence = new Sentence(user: user, cheeses: cheeses);

    return ThemedCard(
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
            Text("${sentence.recapTotalPointsToDate}"),
            (sentence.uniqueCheeseIdsListSentence == null)
                ? Text("")
                : Text("\n${sentence.uniqueCheeseIdsListSentence}."),
          ],
        ),
      ),
    );
  }
}
