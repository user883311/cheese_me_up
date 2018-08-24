//
//
//
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
String userIdCopy;

class LoginRoute extends StatefulWidget {
  LoginRoute();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  @override
  LoginRouteState createState() => new LoginRouteState();
}

class LoginRouteState extends State<LoginRoute> {
  final String noAccountYetMessage =
      "Don't have an account yet? Create one here!";
  final String logIntoMyAccountButtonTitle = "Log into my account";
  final String otherRoute = "/create_account_route";
  final bool toggleSignInCreateAccount = true;
  final String title = "Sign in";
  final TextEditingController emailController =
      new TextEditingController(text: "user883311@gmail.com");
  final TextEditingController passwordController =
      new TextEditingController(text: "password");

  Future _logInWithGoogle() {}
  Future _logInWithFacebook() {}

  Future<FirebaseUser> _tentativeSignInCreateAccount() async {
    FirebaseUser user;
    try {
      user = await _auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      print(user);
      print("response.uid:\n${user.uid}");
      userIdCopy = user.uid;
      return user;
    } catch (e) {
      print("error:\n$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Column(
          children: <Widget>[
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: "Email",
              ),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Password",
              ),
            ),
            RaisedButton(
              child: Text(logIntoMyAccountButtonTitle),
              onPressed: () async {
                await _tentativeSignInCreateAccount().then((response) {
                  // try {
                  //   print(response);
                  //   Navigator.pushNamed(context, '/feed_route/$userIdCopy');
                  // } catch (e) {
                  //   print("Login failed..");
                  //   showDialog(
                  //       context: context,
                  //       builder: (BuildContext context) {
                  //         return new SimpleDialog(
                  //           title: Text('Login failed.'),
                  //           children: <Widget>[
                  //             new SimpleDialogOption(
                  //               onPressed: () {
                  //                 // go back to Feed Route
                  //                 Navigator.pop(context, true);
                  //                 // Navigator.pop(context, true);
                  //               },
                  //               child: const Text('Try again'),
                  //             ),
                  //           ],
                  //         );
                  //       });
                  // }
                  if (response != null) {
                    print(response);
                    Navigator.pushNamed(context, '/feed_route/$userIdCopy');
                  } else {
                    print("Login failed..");
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return new SimpleDialog(
                            title: Text(
                                'Bummer! Your login failed. Check your username and/or password.'),
                            children: <Widget>[
                              new SimpleDialogOption(
                                onPressed: () {
                                  // go back to Feed Route
                                  Navigator.pop(context, true);
                                  // Navigator.pop(context, true);
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
              },
            ),
            Divider(),
            RaisedButton(
              // TODO: add authentification capabilities
              onPressed: _logInWithGoogle,
              child: Text("Google sign-in"),
            ),
            RaisedButton(
              // TODO: add authentification capabilities
              onPressed: _logInWithFacebook,
              child: Text("Facebook sign-in"),
            ),
            FlatButton(
              child: Text(
                noAccountYetMessage,
                style: TextStyle(color: Colors.blue[700]),
              ),
              onPressed: toggleSignInCreateAccount
                  ? () {
                      Navigator.pushNamed(context, otherRoute);
                    }
                  : () {
                      Navigator.pop(context);
                    },
            ),
          ],
        ));
  }
}

//==========================================================================================
//==========================================================================================
class CreateAccountRoute extends LoginRoute {
  @override
  final String noAccountYetMessage = "Already have an account? Sign in here!";
  final String logIntoMyAccountButtonTitle = "Create my account";
  final bool toggleSignInCreateAccount = false;
  final String title = "Create account";

  Future<String> _tentativeSignInCreateAccount() async {
    print("${emailController.text}.|");
    var response = _createAccountWithEmailPassword(
        emailController.text, passwordController.text);
    if (response != null) {
      print("the account creation WAS successful...");
    } else {
      print("the account creation was not successful...");
    }
  }

  Future<String> _createAccountWithEmailPassword(
      String emailString, String passwordString) async {
    try {
      FirebaseUser user = await _auth
          .createUserWithEmailAndPassword(
              email: emailString, password: passwordString)
          .then((resultUser) {
        //return the user unique id
        print("Success: resultUser is :\n$resultUser");
        return resultUser;
      });
    } catch (e) {
      print("Error in _createAccountWithEmailPassword: \n$e");
      return null;
    }
  }
}
