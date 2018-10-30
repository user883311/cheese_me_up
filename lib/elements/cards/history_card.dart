import 'package:cheese_me_up/app_state_container.dart';
import 'package:cheese_me_up/elements/time.dart';
import 'package:cheese_me_up/models/app_state.dart';
import 'package:cheese_me_up/models/checkin.dart';
import 'package:cheese_me_up/models/cheese.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HistoryCard extends StatelessWidget {
  final CheckIn checkin;
  final Cheese cheese;
  // final String userId;

  HistoryCard({
    this.checkin,
    // this.userId,
    @required this.cheese,
  });

  _deleteCheckin(String userId, String checkinId) {
    final FirebaseDatabase database = FirebaseDatabase.instance;
    DatabaseReference _userRef =
        database.reference().child("users/$userId/checkins/$checkinId");
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
                  "${relevantTimeSince(checkin.time)["durationInt"]} ${relevantTimeSince(checkin.time)["unit"]} ago",
                  textScaleFactor: 1.2,
                ),
                Builder(
                  builder: (context) => GestureDetector(
                        onTap: () async {
                          switch (await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return new SimpleDialog(
                                  title: Text(
                                      'Do you want to delete this checkin?'),
                                  children: <Widget>[
                                    new SimpleDialogOption(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: const Text('Yes')),
                                    new SimpleDialogOption(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: const Text('No')),
                                  ],
                                );
                              })) {
                            case true:
                              _deleteCheckin(
                                  appState.user.id, checkin.checkinId);
                              Scaffold.of(context).showSnackBar(
                                  SnackBar(content: Text('Deleted checkin.'),backgroundColor: Colors.red[100],));
                              break;

                            case false:
                              break;

                            default:
                              break;
                          }
                        },
                        child: Icon(
                          Icons.delete_outline,
                          color: Colors.deepOrange[200],
                        ),
                      ),
                ),
              ],
            ),
            RawMaterialButton(
              child: Text("\n${cheese.name}"),
              onPressed: () =>
                  Navigator.pushNamed(context, "/cheese_route/${cheese.id}"),
            ),
            Row(children: [
              IconButton(
                iconSize: 3.0,
                icon: new Image.asset('assets/media/icons/trophy.png'),
                onPressed: () {},
              ),
              Text("+ ${checkin.points} points"),
            ]),
          ],
        ),
      ),
    );
  }
}
