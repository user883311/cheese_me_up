//
//
//
import 'package:cheese_me_up/checkin_route.dart';
import 'package:cheese_me_up/models/cheese.dart';
import 'package:cheese_me_up/models/user.dart';
import 'package:cheese_me_up/models/user_cheese.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

User user;

class FeedRoute extends StatefulWidget {
  FeedRoute();

  @override
  _FeedRoute createState() => new _FeedRoute();
}

class _FeedRoute extends State<FeedRoute> {
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference _userRef;

  final int userId = 0;

  @override
  void initState() {
    super.initState();
    _userRef = database.reference().child("users/$userId");
    _userRef.onValue.listen((Event event) {
      setState(() {
        // try {
        print("event.snapshot is:\n${event.snapshot.toString()}");
        user = new User.fromSnapshot(event.snapshot);
        print(user.toString());
        print(
            'Connected to the user database and read ${event.snapshot.value}');
        print('Howdy, ${user.username}, user ID ${user.id}!');
        print('We sent the verification link to ${user.email}.');
        print('Your pw is ${user.password}.');
        print(
            'Your list of cheeses is a ${user.cheeses.runtimeType}:\n${user.cheeses}.');
        // } catch (e) {
        // print("error message: $e");
        // }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Feed / Home"),
      ),
      body: ListView(
        children: <Widget>[
          user == null
              ? Text("Loading...")
              : AllTimeCard(
                  user: user,
                ),
        ],
      ),
      bottomNavigationBar: ButtonBar(
        alignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
            icon: new Icon(Icons.history),
            onPressed: () => null,
          ),
          IconButton(
            icon: new Icon(Icons.playlist_add_check),
            onPressed: _goCheckinRoute,
          ),
          IconButton(
            icon: new Icon(Icons.settings),
            onPressed: () => null,
          ),
        ],
      ),
      drawer: (user == null)
          ? null
          : HistoryDrawer(
              cheeses: user.cheeses,
            ),
    );
  }

  void _goCheckinRoute() {
    Navigator.pushNamed(context, '/checkin_route');
  }
}

class AllTimeCard extends StatefulWidget {
  // TODO: do I really need to require this parameter,
  // if only one user is ever going to be using the
  // app at one given time?
  final User user;
  const AllTimeCard({Key key, @required this.user})
      : assert(user != null),
        super(key: key);

  @override
  _AllTimeCard createState() => new _AllTimeCard();
}

class _AllTimeCard extends State<AllTimeCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Text(
          "Howdy, ${user.username}!\n\nTo this day, you have scored ${user.cheeses.length} cheeses, and the first one was... ${user.cheeses.values.first.name}.\nThe latest one was... ${user.cheeses.values.last.name}."),
    );
  }
}

class HistoryDrawer extends StatelessWidget {
  final String drawerTitle = "History";
  // final Map<String, Cheese> cheeses;
  final cheeses;
  HistoryDrawer({Key key, this.cheeses}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the Drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView.builder(
        itemCount: cheeses.length,
        itemBuilder: (context, index) {
          return Text("cheese $index");
        },
        padding: EdgeInsets.zero,
      ),
    );
  }
}
