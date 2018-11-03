import 'dart:async';
import 'package:cheese_me_up/elements/modified_smooth_star_rating.dart';
import 'package:cheese_me_up/elements/themed_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:cheese_me_up/app_state_container.dart';
import 'package:cheese_me_up/elements/points_scorer.dart';
import 'package:cheese_me_up/models/app_state.dart';
import 'package:cheese_me_up/models/checkin.dart';
import 'package:cheese_me_up/models/cheese.dart';
import 'package:cheese_me_up/models/rating.dart';
import 'package:cheese_me_up/models/user.dart';
import 'package:cheese_me_up/utils/database.dart';
import 'package:firebase_database/firebase_database.dart';

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
  StreamSubscription streamSubscription;
  double rating;

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

  /// This [Future] displays a dialog box letting [user] deciding to checkin
  /// a [cheese]. If so, the [checkin] will be saved to the server database.
  Future<String> _checkCheckinIntent(
      Cheese cheese, User user, BuildContext scaffoldContext) async {
    switch (await showDialog(
      context: context,
      builder: (context) => new SimpleDialog(
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
                      Navigator.popUntil(context, ModalRoute.withName('/'));
                    }
                  },
                  child: const Text('Yes')),
              new SimpleDialogOption(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('No')),
            ],
          ),
    )) {
      case true:
        return "Your checkin was saved. ";
        break;

      case false:
        return "Oops, something went wrong. Your checkin was not saved.";
        break;

      default:
        // nothing to pop
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    var container = AppStateContainer.of(context);
    appState = container.state;
    cheese = appState.cheeses[cheeseId];
    if (appState.user != null) {
      rating = appState.user.ratings[cheese.id]?.rating;
    }

    return Scaffold(
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
              child: Icon(Icons.plus_one),
              onPressed: () async {
                String response =
                    await _checkCheckinIntent(cheese, appState.user, context);
                Scaffold.of(context).showSnackBar(ThemedSnackBar(
                  content: Text(response),
                  backgroundColor: Colors.red[100],
                ));
              },
            ),
      ),
      resizeToAvoidBottomPadding: false,
      body: CustomScrollView(slivers: <Widget>[
        SliverAppBar(
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.brown[200],
              ),
              onPressed: () => Navigator.pop(context)),
          expandedHeight: 200.0,
          pinned: true,
          title: Container(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            child: Text(cheese.name),
            decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: Image.network(
              "https://firebasestorage.googleapis.com/v0/b/cheese-me-up.appspot.com/o/cheese_images%2FBelval-biere.jpg?alt=media&token=9c678f4e-bff1-4956-a533-72b283226abc",
              // Image.asset(
              //   "assets/media/img/cheese/" + cheese.image,
              fit: BoxFit.cover,
            ),
          ),
        ),

        // TODO: add users average rating for that cheese in NoLogIn mode
        SliverList(
          delegate: SliverChildListDelegate([
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Builder(
                  builder: (context) => Column(
                        children: <Widget>[
                          ModifiedSmoothStarRating(
                            allowHalfRating: false,
                            onRatingChanged: (rating) async {
                              if (appState.user != null) {
                                TransactionResult result =
                                    await writeNewElementToDatabase(
                                        Rating.fromCheeseDateTime(
                                          cheeseId,
                                          DateTime.now(),
                                          rating,
                                        ).toJson(),
                                        FirebaseDatabase.instance.reference().child(
                                            'users/${appState.user.id}/ratings/r$cheeseId'),
                                        randomKey: false);
                                if (result.committed) {
                                  Scaffold.of(context)
                                      .showSnackBar(ThemedSnackBar(
                                    content: Text('Added to your ratings.'),
                                    backgroundColor: Colors.red[100],
                                  ));
                                  setState(() {
                                    this.rating = rating;
                                  });
                                } else {
                                  Scaffold.of(context)
                                      .showSnackBar(ThemedSnackBar(
                                    content: Text(
                                        'Oops. It was not added to your ratings.'),
                                    backgroundColor: Colors.red[100],
                                  ));
                                }
                              } else {
                                Navigator.pop(context, false);
                                Navigator.pushReplacementNamed(context, "/");
                              }
                            },
                            starCount: 5,
                            rating: rating ?? 0.0,
                            size: 40.0,
                            color: Colors.orange,
                            borderColor: Colors.orange,
                          ),
                          // StarRating(
                          //   rating: rating ?? 0.0,
                          //   color: Colors.orange,
                          //   borderColor: Colors.grey,
                          //   size: 50.0,
                          //   starCount: 5,
                          //   onRatingChanged: (rating) async => setState(
                          //         () {
                          //           if (appState.user != null) {
                          //             this.rating = rating;
                          //             if (appState.user != null) {
                          //               setState(() async {
                          //                 TransactionResult result =
                          //                     await writeNewElementToDatabase(
                          //                         Rating.fromCheeseDateTime(
                          //                           cheeseId,
                          //                           DateTime.now(),
                          //                           rating,
                          //                         ).toJson(),
                          //                         FirebaseDatabase.instance
                          //                             .reference()
                          //                             .child(
                          //                                 'users/${appState.user.id}/ratings/r$cheeseId'),
                          //                         randomKey: false);
                          //                 if (result.committed) {
                          //                   Scaffold.of(context).showSnackBar(
                          //                     SnackBar(
                          //                       content: Text(
                          //                           'Added to your ratings.'),
                          //                     ),
                          //                   );
                          //                 }
                          //               });
                          //             }
                          //           } else {
                          //             Navigator.pop(context, false);
                          //             Navigator.pushReplacementNamed(
                          //                 context, "/");
                          //           }
                          //         },
                          //       ),
                          // ),
                        ],
                      )),
            ),
            // SmoothStarRating(
            //   allowHalfRating: true,
            //   onRatingChanged: (rating) async => setState(
            //         () {
            //           if (appState.user != null) {
            //             this.rating = rating;
            //             if (appState.user != null) {
            //               setState(() async {
            //                 TransactionResult result =
            //                     await writeNewElementToDatabase(
            //                         Rating.fromCheeseDateTime(
            //                           cheeseId,
            //                           DateTime.now(),
            //                           rating,
            //                         ).toJson(),
            //                         FirebaseDatabase.instance.reference().child(
            //                             'users/${appState.user.id}/ratings/r$cheeseId'),
            //                         randomKey: false);
            //                 if (result.committed) {
            //                   Scaffold.of(context).showSnackBar(
            //                     SnackBar(
            //                       content: Text('Added to your ratings.'),
            //                     ),
            //                   );
            //                 }
            //               });
            //             }
            //           } else {
            //             Navigator.pop(context, false);
            //             Navigator.pushReplacementNamed(context, "/");
            //           }
            //         },
            //       ),
            //   starCount: 5,
            //   rating: rating ?? 0.0,
            //   size: 40.0,
            //   color: Colors.green,
            //   borderColor: Colors.green,
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("\nCHEESE ID CARD\n"),
                    Text("Name: ${cheese.name}"),
                    Text("Country: ${cheese.country}"),
                    Text(
                        "Region: ${(cheese.region == "null") ? "Unknown" : cheese.region}"),
                    Text("\nPAIRINGS\n"),
                    Text("Wine: merlot, bourgogne dry."),
                    Text("Meats: red meat, lamb."),
                    Text(
                        "\nIpsam et quaerat sint aliquam. Aut delectus qui tenetur delectus. Voluptate blanditiis odit sunt nostrum et. A non voluptatem laudantium iure esse asperiores et.\nSed repellat beatae quia qui est. Consectetur eligendi sit voluptate maxime voluptate deleniti sequi. Ea sed consequuntur quaerat nemo consectetur temporibus consectetur omnis.\n"),
                    Text(
                        "\Ipsam et quaerat sint aliquam. Aut delectus qui tenetur delectus. Voluptate blanditiis odit sunt nostrum et. A non voluptatem laudantium iure esse asperiores et.\n"),
                    Text("\nLOCATION\n"),
                    Image.network("https://i.imgur.com/4L8KoEs.png"),
                    Text(
                        "\nIpsam et quaerat sint aliquam. Aut delectus qui tenetur delectus. Voluptate blanditiis odit sunt nostrum et. A non voluptatem laudantium iure esse asperiores et.\n"),
                    Text("\nABOUT THE PRODUCER\n"),
                    Text(
                        "\Ipsam et quaerat sint aliquam. Aut delectus qui tenetur delectus. Voluptate blanditiis odit sunt nostrum et. A non voluptatem laudantium iure esse asperiores et.\n"),
                    Text("\nHOW TO ORDER\n"),
                    Text(
                        "\Ipsam et quaerat sint aliquam. Aut delectus qui tenetur delectus. Voluptate blanditiis odit sunt nostrum et. A non voluptatem laudantium iure esse asperiores et.\n"),
                  ]),
            ),
          ]),
        ),
      ]),
    );
  }
}
