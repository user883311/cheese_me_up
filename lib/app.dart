import 'package:cheese_me_up/routes/checkin_route.dart';
import 'package:cheese_me_up/routes/cheese_route.dart';
import 'package:cheese_me_up/routes/feed_route.dart';
import 'package:cheese_me_up/routes/history_route.dart';
import 'package:cheese_me_up/routes/login_route.dart';
import 'package:cheese_me_up/routes/settings_route.dart';
import 'package:flutter/material.dart';

class AppRootWidget extends StatefulWidget {
  @override
  AppRootWidgetState createState() => new AppRootWidgetState();
}

class AppRootWidgetState extends State<AppRootWidget> {
  ThemeData get _themeData => new ThemeData(
        // backgroundColor: Colors.green,
        // bottomAppBarColor: Colors.yellow,
        // buttonColor: Colors.red[200],
        buttonTheme: ButtonThemeData(
          buttonColor: Color.fromRGBO(255, 202, 208, 0.7),
          height: 50.0,
          minWidth: 200.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
        ),
        canvasColor: Colors.red[200], // works for bottomAppBar
        cardColor: Colors.orange[50],
        dialogBackgroundColor: Colors.orange[50],
        dividerColor: Colors.black45,
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red[300], width: 2.0),
          ),
          hintStyle: TextStyle(color: Colors.black54),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black54),
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          filled: true,
          fillColor: Colors.white30,
        ),
        primaryColor: Colors.red[200],
        // primaryColorDark: Colors.black54,
        // primaryColorLight: Colors.white54,
        primarySwatch: Colors.brown,
        scaffoldBackgroundColor: Colors.white,
        // unselectedWidgetColor: Colors.deepPurple,
      );

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      showPerformanceOverlay: false,
      locale: Locale("en"),
      debugShowCheckedModeBanner: false,
      title: 'Cheese Me Up',
      theme: _themeData,
      initialRoute: "/",
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => new FeedRoute(),
        '/feed_route': (BuildContext context) => new FeedRoute(),
        '/login_route': (BuildContext context) => new LoginRoute(),
        '/checkin_route': (BuildContext context) => new CheckinRoute(),
        '/settings_route': (BuildContext context) => new SettingsRoute(),
        '/history_route': (BuildContext context) => new HistoryRoute(),
        '/cheese_route': (BuildContext context) =>
            new CheeseRoute(cheeseId: null),
      },
      onGenerateRoute: (routeSettings) {
        var path = routeSettings.name.split('/');
        switch (path[1]) {
          case "cheese_route":
            final cheeseId = path.length > 1 ? path[2] : null;

            return new MaterialPageRoute(
              builder: (context) => new CheeseRoute(cheeseId: cheeseId),
              settings: routeSettings,
            );

          default: // fallback route here
        }
      },
    );
  }
}
