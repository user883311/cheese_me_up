//
//
//
import 'dart:async';
import 'package:cheese_me_up/models/user_cheese.dart';
import 'package:cheese_me_up/utils/database.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final Map<String, dynamic> labels = {
  "sign_in_link": "Already have an account? Sign in here!",
  "create_account_link": "Don't have an account yet? Create one here!",
  "sign_in_button_title": "Log into my account",
  "create_account_button_title": "Create account",
  "sign_in_appbar_title": "Sign in",
  "create_account_appbar_title": "Create account",
  "sign_in_function": ({String email, String password}) async {
    FirebaseUser user;
    try {
      user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      print("user: $user");
      userIdCopy = user.uid;
      return user;
    } catch (e) {
      print("Firebase sign-in error:\n$e");
      return e;
    }
  },
  "create_account_function": ({String email, String password}) async {
    FirebaseUser user;
    // throw exception is password1 and password2 do not match
    try {
      user = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      print("created user: $user");
      userIdCopy = user.uid;
      await addNewUserToDatabase(User.fromJson({
        "id": user.uid,
        "username": user.email,
        "email": user.email,
      }));
      return user;
    } catch (e) {
      print("Firebase account creation error:\n$e");
      return e;
    }
  },
};

Future<Null> addNewUserToDatabase(User user) async {
  DatabaseReference _usersRef =
      FirebaseDatabase.instance.reference().child('users/${user.id}');

  final TransactionResult transactionResult = await writeNewElementToDatabase(
      user.toJson(), _usersRef,
      randomKey: false);
}

final FirebaseAuth _auth = FirebaseAuth.instance;
String userIdCopy;
bool signInOrCreateAccountMode = true;

class LoginRoute extends StatefulWidget {
  LoginRoute();

  @override
  LoginRouteState createState() => new LoginRouteState();
}

class LoginRouteState extends State<LoginRoute> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController1 =
      new TextEditingController(text: "password");
  TextEditingController passwordController2 =
      new TextEditingController(text: "password");

  Future _logInWithGoogle() {}
  Future _logInWithFacebook() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
            padding: EdgeInsets.all(10.0),
            child: Image.asset("assets/media/icons/cheese_color.png")),
        title: Text("CheesopediA"),
      ),
      body: Container(
        margin: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: "Email address",
              ),
            ),
            TextField(
              controller: passwordController1,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Password",
              ),
            ),
            signInOrCreateAccountMode
                ? Container()
                : new TextField(
                    controller: passwordController2,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Type your password again",
                    ),
                  ),
            RaisedButton(
              child: Text(
                signInOrCreateAccountMode
                    ? labels["sign_in_button_title"]
                    : labels["create_account_button_title"],
              ),
              onPressed: () async {
                var functionToUse = signInOrCreateAccountMode
                    ? labels["sign_in_function"]
                    : labels["create_account_function"];

                if (!signInOrCreateAccountMode &&
                    passwordController1.text != passwordController2.text) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return new SimpleDialog(
                          title: Text('Bummer! Your 2 passwords do not match.'),
                          children: <Widget>[
                            new SimpleDialogOption(
                              onPressed: () {
                                Navigator.pop(context, true);
                              },
                              child: const Text(
                                'OK',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        );
                      });
                } else {
                  await functionToUse(
                          email: emailController.text,
                          password: passwordController1.text)
                      .then((response) {
                    if (response.runtimeType == FirebaseUser &&
                        response.uid != null) {
                      print(response);
                      Navigator.pushNamed(context, '/feed_route/${response.uid}');
                    } else {
                      print("Login failed.. Response:\n$response");
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return new SimpleDialog(
                              title: Text(
                                  'Bummer! It failed. ${response.details}'),
                              children: <Widget>[
                                new SimpleDialogOption(
                                  onPressed: () {
                                    Navigator.pop(context, true);
                                  },
                                  child: const Text(
                                    'OK',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            );
                          });
                    }
                  });
                }
              },
            ),
            Divider(),
            new Builder(builder: (context) {
              return new RaisedButton(
                // TODO: add Google authentification capabilities
                onPressed: () {
                  Scaffold.of(context).showSnackBar(
                    new SnackBar(
                      content: new Text("This functionality isn't built yet"),
                    ),
                  );
                },
                child: Text("Google sign-in"),
              );
            }),
            RaisedButton(
              // TODO: add Facebook authentification capabilities
              onPressed: _logInWithFacebook,
              child: Text("Facebook sign-in"),
            ),
            FlatButton(
              child: Text(
                signInOrCreateAccountMode
                    ? labels["create_account_link"]
                    : labels["sign_in_link"],
                style: TextStyle(color: Colors.blue[700]),
              ),
              onPressed: signInOrCreateAccountMode
                  ? () {
                      setState(() {
                        signInOrCreateAccountMode = false;
                      });
                    }
                  : () {
                      setState(() {
                        signInOrCreateAccountMode = true;
                      });
                    },
            ),
            Text("Crafted in Helvetia."),
          ],
        ),
      ),
    );
  }
}
