import 'package:cheese_me_up/app_state_container.dart';
import 'package:cheese_me_up/elements/cards/this_period_card.dart';
import 'package:cheese_me_up/models/app_state.dart';
import 'package:cheese_me_up/models/cheese.dart';
import 'package:cheese_me_up/routes/checkin_route.dart';
import 'package:cheese_me_up/routes/history_route.dart';
import 'package:cheese_me_up/routes/login_route.dart';
import 'package:cheese_me_up/routes/map_route.dart';
import 'package:cheese_me_up/routes/settings_route.dart';
import 'package:flutter/material.dart';
import 'package:cheese_me_up/models/user.dart';
import 'package:cheese_me_up/elements/cards/all_time_card.dart';
import 'package:cheese_me_up/elements/cards/remember_card.dart';

// TODO: add ability to pull body and release to refresh State

// TODO: use FutureBuilder to build widget once db response received, or for image loading (stream?)

class FeedRoute extends StatefulWidget {
  FeedRoute();

  @override
  _FeedRoute createState() {
    return new _FeedRoute();
  }
}

class _FeedRoute extends State<FeedRoute> {
  AppState appState;
  int _currentIndex = 0;

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

    List _navigationViews = [
      {
        "body": ListView(
          children: _cardsBuilder(user, cheeses),
        ),
        "appBar": null,
      },
      {
        "body": new HistoryRoute(),
        "appBar": null,
      },
      {
        "body": new CheckinRoute(),
        "appBar": null,
      },
      {
        "body": MapRoute(),
        "appBar": null,
      },
      {
        "body": new SettingsRoute(),
        "appBar": null,
      },
    ];

    List<BottomNavigationBarItem> _bottomNavBarItems = [
      BottomNavigationBarItem(
        title: Text("Home"),
        icon: Icon(
          Icons.home,
        ),
      ),
      BottomNavigationBarItem(
        title: Text("History"),
        icon: Icon(Icons.history),
      ),
      BottomNavigationBarItem(
        title: Text("Cheeses"),
        icon: Icon(Icons.search),
      ),
      BottomNavigationBarItem(
        title: Text("Around me"),
        icon: Icon(Icons.person_pin_circle),
      ),
      BottomNavigationBarItem(
        title: Text("Settings"),
        icon: Icon(Icons.settings),
      ),
    ];

    return Scaffold(
      appBar: _navigationViews[_currentIndex]["appBar"],
      body: _navigationViews[_currentIndex]["body"],
      bottomNavigationBar: new BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() => _currentIndex = index);
        },
        fixedColor: Colors.blueGrey[700],
        items: _bottomNavBarItems,
        type: BottomNavigationBarType.fixed,
      ),
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
      _widgetToDisplay.add(ThisPeriodCard(
        periodName: "week",
        user: user,
        cheeses: cheeses,
      ));
      _widgetToDisplay.add(ThisPeriodCard(
        periodName: "month",
        user: user,
        cheeses: cheeses,
      ));
    }

    return _widgetToDisplay;
  }

  @override
  Widget build(BuildContext context) {
    var container = AppStateContainer.of(context);
    appState = container.state;

    return _pageToDisplay;
  }
}
