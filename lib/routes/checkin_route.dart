import 'package:cheese_me_up/app_state_container.dart';
import 'package:cheese_me_up/elements/cheese_tile.dart';
import 'package:cheese_me_up/models/app_state.dart';
import 'package:cheese_me_up/models/cheese.dart';
import 'package:cheese_me_up/models/user.dart';
import 'package:flutter/material.dart';

class CheckinRoute extends StatefulWidget {
  CheckinRoute();

  @override
  CheckinRouteState createState() => CheckinRouteState();
}

class CheckinRouteState extends State<CheckinRoute> {
  AppState appState;
  Map<String, Cheese> cheeses = new Map();
  List<Cheese> _cheesesShortlist = List();
  // Cheese cheese;
  TextEditingController searchStringController;
  User user;
  bool searchOn = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateDependencies() {
    var container = AppStateContainer.of(context);
    appState = container.state;
    _cheesesShortlist.addAll(appState.cheeses.values);
  }

  void refreshSearch(String searchString) {
    print("searchString: $searchString");
    // searchStringController.text=searchString;
    searchOn = (searchString != "");
    _cheesesShortlist = [];
    for (Cheese cheese in appState.cheeses.values) {
      if (cheese.fullSearch
          .toLowerCase()
          .contains(searchString.toLowerCase())) {
        setState(() {
          _cheesesShortlist.add(cheese);
        });
      }
    }
    print("_cheesesShortlist:\n$_cheesesShortlist");
  }

  @override
  Widget build(BuildContext context) {
    var container = AppStateContainer.of(context);
    appState = container.state;
    User user = appState.user;
    if (!searchOn) {
      _cheesesShortlist.addAll(appState.cheeses.values);
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, "/", ModalRoute.withName('/'));
            }),
        title: TextField(
          autofocus: false,
          controller: searchStringController,
          onChanged: refreshSearch,
          decoration: InputDecoration(
            hintStyle: TextStyle(color: Colors.white70),
            hintText: "Search cheese...",
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              itemCount: _cheesesShortlist.length,
              itemBuilder: (context, index) {
                Cheese cheese = _cheesesShortlist[index];
                return cheeseTile(
                    cheese,
                    user,
                    () => Navigator.pushNamed(
                        context, "/cheese_route/${cheese.id}"),
                    false);
              },
            ),
          ),
        ],
      ),
    );
  }
}
