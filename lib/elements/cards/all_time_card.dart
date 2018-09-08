import 'package:cheese_me_up/elements/sentence.dart';
import 'package:cheese_me_up/models/user.dart';
import 'package:flutter/material.dart';

class AllTimeCard extends StatefulWidget {
  final User user;
  const AllTimeCard({Key key,  this.user}) : assert(user != null);

  @override
  AllTimeCardState createState() => new AllTimeCardState(user: user);
}

class AllTimeCardState extends State<AllTimeCard> {
  User user;
  
  AllTimeCardState({this.user}) : assert(user != null);
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
                : Text("\n${sentence.uniqueCheesesListSentence}"),
          ],
        ),
      ),
    );
  }
}