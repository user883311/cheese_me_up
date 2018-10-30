import 'package:cheese_me_up/app_state_container.dart';
import 'package:cheese_me_up/elements/cards/history_card.dart';
import 'package:cheese_me_up/elements/cards/starred_card.dart';
import 'package:cheese_me_up/elements/cheese_tile.dart';
import 'package:cheese_me_up/models/app_state.dart';
import 'package:cheese_me_up/models/checkin.dart';
import 'package:cheese_me_up/models/cheese.dart';
import 'package:cheese_me_up/models/rating.dart';
import 'package:cheese_me_up/models/user.dart';
import 'package:flutter/material.dart';

class HistoryRoute extends StatefulWidget {
  HistoryRoute({Key key});

  @override
  _HistoryRouteState createState() => new _HistoryRouteState();
}

class _HistoryRouteState extends State<HistoryRoute> {
  AppState appState;
  bool deleteMode;

  @override
  void initState() {
    super.initState();
    deleteMode = false;
  }

  @override
  Widget build(BuildContext context) {
    var container = AppStateContainer.of(context);
    appState = container.state;
    Map<String, Cheese> cheeses = appState.cheeses;
    User user = appState.user;
    List<CheckIn> checkins = user.checkins.values.toList();
    List<Rating> ratings = user.ratings.values.toList();
    checkins.sort((a, b) => b.time.compareTo(a.time));
    ratings.sort((a, b) => b.time.compareTo(a.time));

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.history)),
              Tab(icon: Icon(Icons.star)),
            ],
          ),

          // automaticallyImplyLeading: false,
          // bottom:
          // TabBar(
          //   tabs: [
          //     Tab(icon: Icon(Icons.history)),
          //     Tab(icon: Icon(Icons.star)),
          //   ],
          // ),
          // title: Text("History"),
          // leading: IconButton(
          //     icon: Icon(Icons.arrow_back_ios),
          //     onPressed: () {
          //       // Navigator.pop(context);
          //       Navigator.pushNamedAndRemoveUntil(
          //           context, "/", ModalRoute.withName('/'));
          //     }),
        ),
        body: TabBarView(
          children: <Widget>[
            (user.checkins.isEmpty)
                ? Card(
                    child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                            "Your history section is empty. Go check out some new cheeses! ")),
                  )
                : ListView.builder(
                    itemCount: checkins.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.all(5.0),
                        child: HistoryCard(
                          checkin: checkins[index],
                          cheese: cheeses[checkins[index].cheeseId],
                        ),
                      );
                    },
                  ),
            (user.ratings.isEmpty)
                ? Card(
                    child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                            "Your starred section is empty. Go rate some new cheeses! ")),
                  )
                : ListView.builder(
                    itemCount: ratings.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.all(5.0),
                        child: StarredCard(
                          cheese: cheeses[ratings[index].cheeseId],
                          user: user,
                          circleAvatar: deleteMode
                              ? Text("d")
                              : StarWidget(
                                  user: user,
                                  cheese: cheeses[ratings[index].cheeseId],
                                ),
                          onTapped: () => Navigator.pushNamed(context,
                              "/cheese_route/${cheeses[ratings[index].cheeseId].id}"),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
