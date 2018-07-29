//
//
//
import 'package:cheese_me_up/checkin_route.dart';
import 'package:flutter/material.dart';

import 'login_route.dart';
import 'feed_route.dart';

void main() {
  print("runApp...");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Cheese Me Up',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: "/",
      routes: {
        // When we navigate to the "/" route, build the FirstScreen Widget
        "/": (context) => LoginRoute(),
        // When we navigate to the "/second" route, build the SecondScreen Widget
        "/feed_route": (context) => FeedRoute(),
        "/checkin_route": (context) => CheckinRoute(),
        // "/settings_route": (context) => SettingsRoute(),
        // "/history_route": (context) => HistoryRoute(),
      },
    );
  }
}
