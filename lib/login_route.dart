//
//
//
import 'package:flutter/material.dart';

class LoginRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Login"),
        ),
        body: Column(
          children: <Widget>[
            TextField(),
            TextField(),
            RaisedButton(
              onPressed: () {
                // TODO: add authentification capabilities
                Navigator.pushNamed(context, '/feed_route');
              },
              child: Text("login"),
            ),
          ],
        ));
  }
}
