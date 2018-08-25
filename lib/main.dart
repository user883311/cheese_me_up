//
//
//
import 'package:cheese_me_up/checkin_route.dart';
import 'package:cheese_me_up/history_route.dart';
import 'package:cheese_me_up/settings_route.dart';
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
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: Colors.orange[100],
        cardColor: Colors.orange[50],
        buttonColor: Colors.blue[100],
        dividerColor: Colors.black,
      ),
      initialRoute: "/",
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => new LoginRoute(),
        // '/create_account_route': (BuildContext context) => new CreateAccountRoute(),
        '/feed_route': (BuildContext context) => new FeedRoute(),
        '/checkin_route': (BuildContext context) => new CheckinRoute(),
        '/settings_route': (BuildContext context) => new SettingsRoute(),
        '/history_route': (BuildContext context) => new HistoryRoute(),
      },
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
          case "settings_route":
            final foo = path.length > 1 ? path[2] : null;
            return new MaterialPageRoute(
              builder: (context) => new SettingsRoute(
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
