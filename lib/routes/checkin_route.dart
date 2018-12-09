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
  TextEditingController searchStringController;
  User user;
  bool searchOn = false;

  @override
  void initState() {
    super.initState();
  }

  void refreshSearch(String searchString) {
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
  }

  @override
  Widget build(BuildContext context) {
    var container = AppStateContainer.of(context);
    appState = container.state;
    User user = appState.user;
    if (!searchOn) {
      _cheesesShortlist.addAll(appState.cheeses.values);
    }

    Widget checkinBody = Column(
      children: <Widget>[
        Flexible(
          child: ListView.builder(
              itemCount: _cheesesShortlist.length,
              itemBuilder: (context, index) => CheeseTile(
                  cheese: _cheesesShortlist[index],
                  user: user,
                  onTapped: () => Navigator.pushNamed(
                      context, "/cheese_route/${_cheesesShortlist[index].id}"),
                  circleAvatar: true)),
        ),
      ],
    );
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: (user == null)
            ? IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () => Navigator.pop(context))
            : null,
        title: TextField(
          autofocus: false,
          controller: searchStringController,
          onChanged: refreshSearch,
          decoration: InputDecoration(
            // hintStyle: TextStyle(color: Colors.white70),
            hintText: "Search a cheese...",
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.format_align_center),
          )
        ],
      ),
      body: checkinBody,
    );
  }
}
