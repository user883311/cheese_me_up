import 'package:cheese_me_up/app_state_container.dart';
import 'package:cheese_me_up/elements/cards/themed_card.dart';
import 'package:cheese_me_up/elements/themed_snackbar.dart';
import 'package:cheese_me_up/elements/time.dart';
import 'package:cheese_me_up/models/app_state.dart';
import 'package:cheese_me_up/models/checkin.dart';
import 'package:cheese_me_up/models/cheese.dart';
import 'package:cheese_me_up/models/user.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import './themed_card.dart';

class HistoryCard extends StatefulWidget {
  final CheckIn checkin;
  final Cheese cheese;

  HistoryCard({
    this.checkin,
    @required this.cheese,
  });

  @override
  HistoryCardState createState() {
    return new HistoryCardState();
  }
}

class HistoryCardState extends State<HistoryCard> {
  _deleteCheckin(String userId, String checkinId) {
    final FirebaseDatabase database = FirebaseDatabase.instance;
    DatabaseReference _userRef =
        database.reference().child("users/$userId/checkins/$checkinId");
    setState(() {
      _userRef.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    var container = AppStateContainer.of(context);
    AppState appState = container.state;
    User user = appState.user;

    return Slidable(
      child: ThemedCard(
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.transparent,
            child: ClipOval(
              child: FadeInImage.assetNetwork(
                fadeInDuration: Duration(seconds: 2),
                fadeInCurve: Curves.bounceIn,
                placeholder: "assets/media/icons/cheese_color.png",
                image: "https://via.placeholder.com/350x150",
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                  child: Text(
                widget.cheese.name,
                overflow: TextOverflow.ellipsis,
              )),
              widget.checkin == null
                  ? Text("")
                  : new PointWidget(
                      checkin: widget.checkin,
                      cheese: widget.cheese,
                    ),
            ],
          ),
          subtitle: new Text(widget.cheese.region +
              ", " +
              widget.cheese.country +
              "\n${relevantTimeSince(widget.checkin.time)["durationInt"]} ${relevantTimeSince(widget.checkin.time)["unit"]} ago"),
          onTap: () =>
              Navigator.pushNamed(context, "/cheese_route/${widget.cheese.id}"),
        ),
      ),
      delegate: new SlidableDrawerDelegate(),
      actionExtentRatio: 0.25,
      secondaryActions: <Widget>[
        new IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            _deleteCheckin(user.id, widget.checkin.checkinId);
            showSnackBar(context, "This checkin has been deleted.");
          },
        ),
      ],
      // controller: _slidableController,
    );
  }
}

class PointWidget extends StatelessWidget {
  final CheckIn checkin;
  final Cheese cheese;

  const PointWidget({
    Key key,
    this.checkin,
    this.cheese,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int points = checkin.points;
    return ConstrainedBox(
      constraints: BoxConstraints.tight(Size.fromRadius(18.0)),
      child: Row(children: [
        Text(
          points.toString(),
          style: TextStyle(
            color: Colors.brown[_color(points)],
          ),
        ),
        Icon(
          Icons.monetization_on,
          size: 18.0,
          color: Colors.brown[_color(points)],
        ),
      ]),
    );
  }

  int _color(points) {
    if (points == null) {
      return 0;
    }
    return points.toInt() * 100;
  }
}
