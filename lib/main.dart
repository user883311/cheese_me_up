//
//
//
import 'package:cheese_me_up/checkin_route.dart';
import 'package:cheese_me_up/history_route.dart';
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
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => new LoginRoute(),
        '/create_account_route': (BuildContext context) =>
            new CreateAccountRoute(),
        '/feed_route': (BuildContext context) => new FeedRoute(),
        '/checkin_route': (BuildContext context) => new CheckinRoute(),
        // '/settings_route': (BuildContext context) => new SettingsRoute(),
        '/history_route': (BuildContext context) => new HistoryRoute(),
      },

      // {
      //   // When we navigate to the "/" route, build the FirstScreen Widget
      //   "/": (context) => LoginRoute(),
      //   "/create_account_route": (context)=> CreateAccountRoute(),
      //   // When we navigate to the "/second" route, build the SecondScreen Widget
      //   "/feed_route": (context) => FeedRoute(),
      //   "/checkin_route": (context) => CheckinRoute(),
      //   // "/settings_route": (context) => SettingsRoute(),
      //   // "/history_route": (context) => HistoryRoute(),
      // },

      onGenerateRoute: (routeSettings) {
        var path = routeSettings.name.split('/');
        print("path is: $path");

        switch (path[1]) {
          case "feed_route":
            final foo = path.length > 1 ? path[2] : null;
            return new MaterialPageRoute(
              builder: (context) => new FeedRoute(
                    userId: foo,
                  ),
              settings: routeSettings,
            );
            break;
          case "checkin_route":
            final foo = path.length > 1 ? path[2] : null;
            return new MaterialPageRoute(
              builder: (context) => new CheckinRoute(
                    userId: foo,
                  ),
              settings: routeSettings,
            );
          case "history_route":
            final foo = path.length > 1 ? path[2] : null;
            return new MaterialPageRoute(
              builder: (context) => new HistoryRoute(
                    userId: foo,
                  ),
              settings: routeSettings,
            );
          default:
        }
        // fallback route here
      },
    );
  }
}
