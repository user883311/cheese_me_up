import 'package:flutter/material.dart';
import 'package:cheese_me_up/elements/cards/themed_card.dart';
import 'package:cheese_me_up/models/cheese.dart';
import 'package:cheese_me_up/models/user.dart';

/// Creates a tile representing a given [Cheese] object. Upon tapping
/// on the tile, a callback function [onTapped] is called, for a given [user].
class CheeseTile extends StatelessWidget {
  final Cheese cheese;
  final User user;
  final onTapped;
  final bool circleAvatar;

  CheeseTile({
    this.cheese,
    this.user,
    this.circleAvatar,
    this.onTapped,
  });

  @override
  Widget build(BuildContext context) {
    return ThemedCard(
      child: ListTile(
        // trailing: new Container(
        //   width: 100.0,
        //   height: 50.0,
        //   child: new Image.network(
        //     "https://firebasestorage.googleapis.com/v0/b/cheese-me-up.appspot.com/o/cheese_images%2FBelval-biere.jpg?alt=media&token=9c678f4e-bff1-4956-a533-72b283226abc",
        //     // Image.asset(
        //     //   "assets/media/img/cheese/" + cheese.image,
        //     fit: BoxFit.cover,
        //   ),
        // ),
        leading: circleAvatar
            ? CircleAvatar(
                backgroundColor: Colors.red[100],
                foregroundColor: Colors.black,
                // child: new Text(cheese.name.substring(0, 2).toUpperCase()),
                backgroundImage: 
                NetworkImage("https://firebasestorage.googleapis.com/v0/b/cheese-me-up.appspot.com/o/cheese_images%2FBelval-biere.jpg?alt=media&token=9c678f4e-bff1-4956-a533-72b283226abc"),
                // Image.network(
                //   "https://firebasestorage.googleapis.com/v0/b/cheese-me-up.appspot.com/o/cheese_images%2FBelval-biere.jpg?alt=media&token=9c678f4e-bff1-4956-a533-72b283226abc",
                // ),
              )
            : null,
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

class StarWidget extends StatelessWidget {
  final User user;
  final Cheese cheese;

  const StarWidget({
    Key key,
    this.user,
    this.cheese,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double rating = user.ratings[cheese.id]?.rating;
    return ConstrainedBox(
      constraints: BoxConstraints.tight(Size.fromRadius(18.0)),
      child: Row(children: [
        Text(
          rating.toString(),
          style: TextStyle(
            color: Colors.brown[_color(rating)],
          ),
        ),
        Icon(
          Icons.star,
          size: 10.0,
          color: Colors.brown[_color(rating)],
        ),
      ]),
    );
  }

  int _color(rating) {
    if (user.ratings[cheese.id] == null) {
      return 0;
    }
    return rating.toInt() * 100;
  }
}
