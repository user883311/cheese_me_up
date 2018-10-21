import 'package:cheese_me_up/app_state_container.dart';
import 'package:cheese_me_up/elements/time.dart';
import 'package:cheese_me_up/models/app_state.dart';
import 'package:cheese_me_up/models/cheese.dart';
import 'package:cheese_me_up/models/rating.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class StarredCard extends StatelessWidget {
  final Rating rating;
  final Cheese cheese;
  // final String userId;

  StarredCard({
    this.rating,
    // this.userId,
    @required this.cheese,
  });

    _deleteRating(String userId, String cheeseId) {
    final FirebaseDatabase database = FirebaseDatabase.instance;
    DatabaseReference _userRef =
        database.reference().child("users/$userId/ratings/r$cheeseId");
    _userRef.remove();
  }

  @override
  // TODO: add 2 separate tabs: CHECKINS and RATINGS
  Widget build(BuildContext context) {
    var container = AppStateContainer.of(context);
    AppState appState = container.state;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "${relevantTimeSince(rating.time)["durationInt"]} ${relevantTimeSince(rating.time)["unit"]} ago",
                  textScaleFactor: 1.2,
                ),
                GestureDetector(
                  onTap: () async {
                    switch (await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return new SimpleDialog(
                            title: Text('Do you want to delete this rating?'),
                            children: <Widget>[
                              new SimpleDialogOption(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Yes')),
                              new SimpleDialogOption(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text('No')),
                            ],
                          );
                        })) {
                      case true:
                        _deleteRating(appState.user.id, rating.cheeseId);
                        break;

                      case false:
                        break;

                      default:
                        break;
                    }
                  },
                  child: Icon(
                    Icons.delete_outline,
                    color: Colors.black26,
                  ),
                ),
              ],
            ),
            RawMaterialButton(
              child: Text("\n${cheese.name}"),
              onPressed: () => Navigator.pushNamed(context, "/cheese_route/${cheese.id}"),
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
