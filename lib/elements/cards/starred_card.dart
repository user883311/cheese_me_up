import 'package:cheese_me_up/elements/cards/themed_card.dart';
import 'package:cheese_me_up/elements/cheese_tile.dart';
import 'package:cheese_me_up/models/cheese.dart';
import 'package:cheese_me_up/models/user.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class StarredCard extends StatefulWidget {
  final Cheese cheese;
  final User user;
  final onTapped;
  final bool circleAvatar;

  StarredCard({
    @required this.cheese,
    this.user,
    this.circleAvatar,
    this.onTapped,
  }) : assert(cheese != null);

  @override
  StarredCardState createState() => new StarredCardState(
      cheese: cheese,
      user: user,
      onTapped: onTapped,
      circleAvatar: circleAvatar);
}

class StarredCardState extends State<StarredCard> {
  final Cheese cheese;
  final User user;
  final onTapped;
  final bool circleAvatar;

  StarredCardState({
    @required this.cheese,
    this.user,
    this.onTapped,
    this.circleAvatar,
  });

  @override
  void initState() {
    super.initState();
  }

  _deleteRating(String userId, String cheeseId) {
    final FirebaseDatabase database = FirebaseDatabase.instance;
    DatabaseReference _userRef =
        database.reference().child("users/$userId/ratings/r$cheeseId");
    _userRef.remove();
  }

  Widget build(BuildContext context) {
    return ThemedCard(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: ClipOval(
            child: FadeInImage.assetNetwork(
              fadeInDuration: Duration(seconds: 2),
              fadeInCurve: Curves.bounceIn,
              placeholder: "assets/media/icons/cheese_color.png",
              image:
                  "https://via.placeholder.com/350x150",
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
                child: Text(
              cheese.name,
              overflow: TextOverflow.ellipsis,
            )),
            user == null || user.ratings[cheese.id] == null
                ? Text("")
                : new StarWidget(
                    user: user,
                    cheese: cheese,
                  ),
          ],
        ),
        subtitle: new Text(cheese.region + ", " + cheese.country),
        onTap: () async {
          if (onTapped != null) {
            onTapped();
          }
        },
      ),
    );
  }
}
