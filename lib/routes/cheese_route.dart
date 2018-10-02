import 'dart:async';

import 'package:cheese_me_up/elements/points_scorer.dart';
import 'package:cheese_me_up/models/checkin.dart';
import 'package:cheese_me_up/models/cheese.dart';
import 'package:cheese_me_up/models/rating.dart';
import 'package:cheese_me_up/models/user.dart';
import 'package:cheese_me_up/utils/database.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';

String userIdCopy;
User user;

class CheeseRoute extends StatefulWidget {
  final String cheeseId;
  final String userId;
  CheeseRoute({@required this.cheeseId, this.userId})
      : assert(cheeseId != null);

  @override
  CheeseRouteState createState() =>
      CheeseRouteState(cheeseId: cheeseId, userId: userId);
}

class CheeseRouteState extends State<CheeseRoute> {
  String cheeseId;
  Cheese cheese;
  String userId;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  Query _cheeseRef;
  DatabaseReference _userRef;
  StreamSubscription streamSubscription;
  double rating = 0.0;

  CheeseRouteState({@required this.cheeseId, this.userId});

  @override
  void initState() {
    super.initState();
    _cheeseRef = database
        .reference()
        .child("cheeses")
        .orderByChild("id")
        .equalTo("$cheeseId");
    _cheeseRef.onChildAdded.listen(_onEntryAdded);

    if (userId != null && userId != "") {
      userIdCopy = userId;
      _userRef = database.reference().child("users/$userIdCopy");
      streamSubscription = _userRef.onValue.listen((Event event) {
        user = new User.fromSnapshot(event.snapshot);
        rating = user.ratings[cheese.id].rating;
      });
    }
  }

  @override
  void dispose() {
    if (streamSubscription != null) {
      streamSubscription.cancel();
      super.dispose();
    }
  }

  void _onEntryAdded(Event event) {
    setState(() {
      cheese = Cheese.fromSnapshot(event.snapshot);
    });
  }

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
                    // TODO: add check if user is logged in. If not,
                    // send user back to login page
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
                                  .child('users/$userIdCopy/checkins'));

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
        Navigator.pushReplacementNamed(context, "/feed_route/$userIdCopy");
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
    return (cheese == null)
        ? Text("loading...")
        : new Scaffold(
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.plus_one),
              onPressed: () {
                _checkCheckinIntent(cheese, user);
              },
            ),
            resizeToAvoidBottomPadding: false,
            body: ListView(children: [
              Stack(
                children: <Widget>[
                  Container(
                    constraints:
                        BoxConstraints.expand(height: 200.0, width: 9999.0),
                    child: Image.asset(
                      "assets/media/img/cheese/" + cheese.image,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    splashColor: Colors.white54,
                    color: Colors.white54,
                  ),
                ],
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     IconButton(
              //         icon: Icon(Icons.star),
              //         onPressed: () {
              //           if (user != null) {
              //             writeNewElementToDatabase(
              //                 Rating.fromCheeseDateTime(
              //                         cheeseId, DateTime.now(), 1.0)
              //                     .toJson(),
              //                 FirebaseDatabase.instance
              //                     .reference()
              //                     .child('users/$userIdCopy/ratings/$cheeseId'),
              //                 randomKey: false);
              //           }
              //         }),
              //     IconButton(icon: Icon(Icons.star), onPressed: () {}),
              //     IconButton(icon: Icon(Icons.star), onPressed: () {}),
              //     IconButton(icon: Icon(Icons.star), onPressed: () {}),
              //     IconButton(icon: Icon(Icons.star), onPressed: () {}),
              //   ],
              // ),
              new StarRating(
                rating: rating,
                color: Colors.orange,
                borderColor: Colors.grey,
                size: 50.0,
                starCount: 5,
                onRatingChanged: (rating) => setState(
                      () {
                        this.rating = rating;

                        if (user != null) {
                          writeNewElementToDatabase(
                              Rating.fromCheeseDateTime(
                                      cheeseId, DateTime.now(), rating)
                                  .toJson(),
                              FirebaseDatabase.instance
                                  .reference()
                                  .child('users/$userIdCopy/ratings/r$cheeseId'),
                              randomKey: false);
                        }
                      },
                    ),
              ),
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
          );
  }
}
