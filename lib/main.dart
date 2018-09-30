import 'package:cheese_me_up/routes/checkin_route.dart';
import 'package:cheese_me_up/routes/cheese_route.dart';
import 'package:cheese_me_up/routes/feed_route.dart';
import 'package:cheese_me_up/routes/history_route.dart';
import 'package:cheese_me_up/routes/login_route.dart';
import 'package:cheese_me_up/routes/settings_route.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      showPerformanceOverlay: false,
      locale: Locale("en"),
      debugShowCheckedModeBanner: false,
      title: 'Cheese Me Up',
      theme: new ThemeData(
        buttonColor: Color.fromRGBO(181, 221, 255, 0.8),
        buttonTheme: ButtonThemeData(
            height: 50.0,
            minWidth: 200.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)))),
        cardColor: Colors.orange[50],
        dividerColor: Colors.black,
        primarySwatch: Colors.brown,
        scaffoldBackgroundColor: Colors.orange[100],
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: Color.fromRGBO(255, 241, 0, 0.6), width: 2.0),
          ),
          hintStyle: TextStyle(color: Colors.black54),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black54),
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          filled: true,
          fillColor: Colors.white30,
        ),
      ),
      initialRoute: "/",
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => new LoginRoute(),
        '/feed_route': (BuildContext context) => new FeedRoute(),
        '/checkin_route': (BuildContext context) => new CheckinRoute(),
        '/settings_route': (BuildContext context) => new SettingsRoute(),
        '/history_route': (BuildContext context) => new HistoryRoute(),
        '/cheese_route': (BuildContext context) => new CheeseRoute(
              cheeseId: null,
            ),
      },
      onGenerateRoute: (routeSettings) {
        var path = routeSettings.name.split('/');

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

          case "cheese_route":
            final foo = path.length > 1 ? path[2] : null;
            final user = path.length > 2 ? path[3] : null;
            return new MaterialPageRoute(
              builder: (context) => new CheeseRoute(
                    cheeseId: foo,
                    userId:user,
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
