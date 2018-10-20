import 'dart:async';

import 'package:cheese_me_up/app_state_container.dart';
import 'package:cheese_me_up/elements/points_scorer.dart';
import 'package:cheese_me_up/models/app_state.dart';
import 'package:cheese_me_up/models/checkin.dart';
import 'package:cheese_me_up/models/cheese.dart';
import 'package:cheese_me_up/models/rating.dart';
import 'package:cheese_me_up/models/user.dart';
import 'package:cheese_me_up/utils/database.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';

class CheeseRoute extends StatefulWidget {
  final String cheeseId;
  CheeseRoute({@required this.cheeseId}) : assert(cheeseId != null);

  @override
  CheeseRouteState createState() => CheeseRouteState(cheeseId: cheeseId);
}

class CheeseRouteState extends State<CheeseRoute> {
  AppState appState;
  String cheeseId;
  Cheese cheese;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  // Query _cheeseRef;
  // DatabaseReference _userRef;
  StreamSubscription streamSubscription;
  double rating = 0.0;

  CheeseRouteState({@required this.cheeseId});

  @override
  void initState() => super.initState();

  @override
  void dispose() {
    if (streamSubscription != null) {
      streamSubscription.cancel();
    }
    super.dispose();
  }

  // void _onEntryAdded(Event event) {
  //   setState(() {
  //     cheese = Cheese.fromSnapshot(event.snapshot);
  //   });
  // }

  /// This [Future] displays a dialog box letting [user] deciding to checkin
  /// a [cheese]. If so, the [checkin] will be saved to the server database.
  Future _checkCheckinIntent(Cheese cheese, User user) async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return new SimpleDialog(
            title: Text('Do you want to check ${cheese.name} in?'),
            children: <Widget>[
              new SimpleDialogOption(
                  onPressed: () async {
                    if (user != null) {
                      CheckIn checkin = CheckIn.fromCheeseDateTime(
                        cheese.id,
                        DateTime.now(),
                        pointsForNewCheese(cheese, user),
                      );
                      TransactionResult resultTransaction =
                          await writeNewElementToDatabase(
                              checkin.toJson(),
                              FirebaseDatabase.instance
                                  .reference()
                                  .child('users/${user.id}/checkins'));

                      Navigator.pop(context, resultTransaction.committed);
                    } else {
                      // send user to login page
                      Navigator.pop(context);
                      Navigator.pushReplacementNamed(context, "/");
                    }
                  },
                  child: const Text('Yes')),
              new SimpleDialogOption(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('No')),
            ],
          );
        })) {
      case true:
        Navigator.pop(context);
        Navigator.pushNamed(context, "/feed_route");
        break;

      case false:
        Navigator.pop(context);
        break;

      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    var container = AppStateContainer.of(context);
    appState = container.state;
    cheese = appState.cheeses[cheeseId];
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.plus_one),
        onPressed: () {
          _checkCheckinIntent(cheese, appState.user);
        },
      ),
      resizeToAvoidBottomPadding: false,
      body: ListView(children: [
        Stack(
          children: <Widget>[
            Container(
              constraints: BoxConstraints.expand(height: 200.0, width: 9999.0),
              child: Image.asset(
                "assets/media/img/cheese/" + cheese.image,
                fit: BoxFit.fitWidth,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(15.0)),
                // backgroundBlendMode: BlendMode.srcATop,
                // color: Colors.white30,
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pop(context);
                },
                splashColor: Colors.white54,
                color: Colors.white54,
              ),
            ),
          ],
        ),
        IgnorePointer(
          // TODO: add users average rating for that cheese in NoLogIn mode
          ignoring: (appState.user == null),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: new StarRating(
              rating: rating ?? 0.0,
              color: Colors.orange,
              borderColor: Colors.grey,
              size: 50.0,
              starCount: 5,
              onRatingChanged: (rating) => setState(
                    () {
                      this.rating = rating;

                      if (appState.user != null) {
                        writeNewElementToDatabase(
                            Rating.fromCheeseDateTime(
                                    cheeseId, DateTime.now(), rating)
                                .toJson(),
                            FirebaseDatabase.instance.reference().child(
                                'users/${appState.user.id}/ratings/r$cheeseId'),
                            randomKey: false);
                      }
                    },
                  ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("\nCHEESE ID\n"),
            Text("Name: ${cheese.name}"),
            Text("Country: ${cheese.country}"),
            Text(
                "Region: ${(cheese.region == "null") ? "Unknown" : cheese.region}"),
            Text("\nPAIRINGS\n"),
            Text("Wine: merlot, bourgogne dry."),
            Text("Meats: red meat, lamb."),
            Text("\nLOCATION\n"),
          ]),
        ),
      ]),
    );
  }
}
