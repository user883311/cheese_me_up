//
//
//
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
        // print("event.snapshot is:\n${event.snapshot.toString()}");
        user = new User.fromSnapshot(event.snapshot);

        // print(user.toString());
        // print(
        //     'Connected to the user database and read ${event.snapshot.value}');
        // print('Howdy, ${user.username}, user ID ${user.id}!');
        // print('We sent the verification link to ${user.email}.');
        // print('Your pw is ${user.password}.');
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
      drawer: (user == null) ? null : HistoryDrawer(),
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

class HistoryDrawer extends StatefulWidget {
  final String drawerTitle = "History";
  HistoryDrawer({Key key}) : super(key: key);

  @override
  _HistoryDrawerState createState() => new _HistoryDrawerState();
}

class _HistoryDrawerState extends State<HistoryDrawer> {
  List<Cheese> cheeses;

  @override
  void initState() {
    super.initState();
    cheeses = listMyCheeses(user.cheeses);
  }

  Widget _builder(context, index) {
    return Text("cheese # $index: ${cheeses[index].name}");
  }

  List<Cheese> listMyCheeses(Map cheeses) {
    List<Cheese> res = new List();
    cheeses.values.forEach((v) => res.add(v));
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Scaffold(
        appBar: AppBar(
          title: Text("History"),
        ),
        body: ListView.builder(
          itemCount: user.cheeses.length,
          itemBuilder: _builder,
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
