import 'package:cheese_me_up/login_route.dart';
import 'package:cheese_me_up/models/user.dart';
import 'package:flutter/material.dart';

class HistoryRoute extends StatefulWidget {
  final User user;
  const HistoryRoute({Key key, @required this.user})
      : assert(user != null),
        super(key: key);

  @override
  HistoryRouteState createState() => new HistoryRouteState();
}

class HistoryRouteState extends State<HistoryRoute> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: user.cheeses.length,
      itemBuilder: (context, i) {
        return ListTile(
          title: Text('Item $i: ${user.cheeses[user.cheeses.values[i]]}'),
          onTap: () {
            // TODO: add consulting history route
          },
        );
      },
    );
  }
}
