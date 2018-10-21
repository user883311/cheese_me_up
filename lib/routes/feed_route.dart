import 'dart:async';
import 'package:cheese_me_up/app_state_container.dart';
import 'package:cheese_me_up/models/app_state.dart';
import 'package:cheese_me_up/models/cheese.dart';
import 'package:cheese_me_up/routes/login_route.dart';
import 'package:flutter/material.dart';
import 'package:cheese_me_up/models/user.dart';
import 'package:cheese_me_up/elements/cards/all_time_card.dart';
import 'package:cheese_me_up/elements/cards/remember_card.dart';

// TODO: add ability to pull body and release to refresh State

// TODO: use FutureBuilder to build widget once db response received

class FeedRoute extends StatefulWidget {
  FeedRoute();

  @override
  _FeedRoute createState() {
    return new _FeedRoute();
  }
}

class _FeedRoute extends State<FeedRoute> {
  AppState appState;

  @override
  void didPopNext() {
    // Covering route was popped off the navigator.
    print("Did Pop Next");
  }

  Widget get _pageToDisplay {
    if (appState.isLoading) {
      return _loadingView;
    } else if (!appState.isLoading && appState.user == null) {
      return new LoginRoute();
    } else {
      return _homeView;
    }
  }

  Widget get _loadingView {
    return new Center(
      child: new CircularProgressIndicator(),
    );
  }

  Widget get _homeView {
    User user = appState.user;
    Map<String, Cheese> cheeses = appState.cheeses;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IgnorePointer(
              child: IconButton(
                icon: Image.asset(
                  "assets/media/icons/settings.png",
                  color: Colors.transparent,
                ),
                onPressed: () {},
              ),
            ),
            Text("Brie"),
            IconButton(
              icon: Image.asset("assets/media/icons/settings.png"),
              onPressed: () => Navigator.pushNamed(context, '/settings_route'),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
      ),
      body: ListView(
        children: _cardsBuilder(user, cheeses),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.brown,
        ),
        child: ButtonBar(
          alignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Image.asset("assets/media/icons/history.png"),
              onPressed: () async {
                // await Navigator.pushNamed(context, '/history_route');
                await Navigator.pushReplacementNamed(context, '/history_route');
                print("just came back to FeedRoute..!");
              },
            ),
            IconButton(
                icon: Image.asset("assets/media/icons/map.png"),
                onPressed: () {
                  return showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: Text(
                            "The Map functionnality is in preparation. Stay tuned!"),
                      );
                    },
                  );
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Colors.brown,
                width: 2.0,
              ),
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          backgroundColor: Colors.brown[800],
          onPressed: _goCheckinRoute,
          child: Padding(
            child: Image.asset("assets/media/icons/cheese_color.png"),
            padding: EdgeInsets.all(10.0),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  List<Widget> _cardsBuilder(User user, Map<String, Cheese> cheeses) {
    List<Widget> _widgetToDisplay = [
      AllTimeCard(
        user: user,
        cheeses: cheeses,
      ),
    ];
    if (user.checkins.isNotEmpty) {
      _widgetToDisplay.add(RememberCard(
        user: user,
        cheeses: cheeses,
      ));
    }
    return _widgetToDisplay;
  }

  void _goCheckinRoute() {
    Navigator.pushReplacementNamed(context, '/checkin_route');
  }

  @override
  Widget build(BuildContext context) {
    var container = AppStateContainer.of(context);
    appState = container.state;

    return _pageToDisplay;
  }
}
