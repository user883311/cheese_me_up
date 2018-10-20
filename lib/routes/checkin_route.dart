import 'dart:async';
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
  TextEditingController _searchStringController;

  @override
  void initState() {
    super.initState();
  }

  // @override
  // void dispose() {
  // TODO: replace user=null by disconnecting from Firebase
  // & checking on connection status
  // user = null;
  // if (streamSubscription != null) {
  //   streamSubscription.cancel();
  // }
  // super.dispose();
  // }

  // void _onEntryAdded(Event event) {
  // setState(() {
  //   var cheese = Cheese.fromSnapshot(event.snapshot);
  //   cheeses[cheese.id.toString()] = cheese;
  //   _cheesesShortlist.add(cheese);
  // });
  // }

  void refreshSearch(String searchString) {
    setState(() {
      print("searchString: $searchString");
      _cheesesShortlist = [];
      for (Cheese cheese in appState.cheeses.values) {
        if (cheese.fullSearch
            .toLowerCase()
            .contains(searchString.toLowerCase())) {
          _cheesesShortlist.add(cheese);
        }
      }
      print("_cheesesShortlist:\n$_cheesesShortlist");
    });
  }

  // void tappedCheeseTile(Cheese cheese, [User user]) {
  //   // open the Cheese bottom sheet
  //   Navigator.pushNamed(context, "/cheese_route/${cheese.id}");

  //   // showModalBottomSheet(
  //   //     context: context,
  //   //     builder: (BuildContext context) {
  //   //       return CheeseRoute(cheeseId: cheese.name);
  //   //     });
  // }

  @override
  Widget build(BuildContext context) {
    var container = AppStateContainer.of(context);
    appState = container.state;
    _cheesesShortlist.addAll(appState.cheeses.values);
    User user = appState.user;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, "/", ModalRoute.withName('/'));
              // if (userIdCopy != null && userIdCopy != "") {
              //   print("pressed back button");
              //   Navigator.pushReplacementNamed(
              //       context, '/feed_route/$userIdCopy');
              // } else {
              //   Navigator.pushNamedAndRemoveUntil(
              //       context, "/", ModalRoute.withName('/'));
              // }
            }),
        title: TextField(
          autofocus: false,
          controller: _searchStringController,
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
