//
//
//
import 'dart:async';
import 'package:cheese_me_up/models/user.dart';
import 'package:cheese_me_up/utils/database.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
      // print("user: $user");
      userIdCopy = user.uid;
      return user;
    } catch (e) {
      print("Firebase sign-in error (${e.runtimeType}):\n$e");
      if (e.runtimeType == PlatformException) {
        return e.details;
      } else {
        return e;
      }
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
        "displayName": user.email,
        "email": user.email,
      })).catchError((error) {
        throw Exception(error);
      });
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
final GoogleSignIn _googleSignIn = new GoogleSignIn();

class LoginRoute extends StatefulWidget {
  LoginRoute();

  @override
  LoginRouteState createState() => new LoginRouteState();
}

class LoginRouteState extends State<LoginRoute> {
  TextEditingController emailController =
      new TextEditingController(text: "user883311@gmail.com");
  TextEditingController passwordController1 =
      new TextEditingController(text: "password");
  TextEditingController passwordController2 =
      new TextEditingController(text: "password");

  Future _testSignInWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw "Sign in was cancelled.";
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      if (googleAuth == null) {
        throw "Authentification failed.";
      }
      final FirebaseUser user = await _auth.signInWithGoogle(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      assert(user.email != null);
      assert(user.displayName != null);
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);

      print('signInWithGoogle succeeded: $user');

      await addNewUserToDatabase(User.fromJson({
        "id": user.uid,
        "displayName": user.displayName,
        "email": user.email,
      })).catchError((error) {
        throw Exception(error);
      });
      return user;

      // return user;
    } on PlatformException catch (exception) {
      print("_testSignInWithGoogle exception:\n$exception");
      return exception;
    } catch (error) {
      print("_testSignInWithGoogle error:\n$error");
      return error;
    }
  }

  void handleSignInResponse(dynamic response) {
    print("response:\n$response");
    if (response.runtimeType == FirebaseUser && response.uid != null) {
      Navigator.pushNamed(context, '/feed_route/${response.uid}');
    } else {
      // ERROR HANDLING
      print("Login failed.. Response:\n$response");

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return new SimpleDialog(
              title: Text('Bummer! It failed. $response'),
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
  }

  Future _logInWithFacebook() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
            padding: EdgeInsets.all(10.0),
            child: Image.asset("assets/media/icons/cheese_color.png")),
        title: Text(
          "CheesopediA",
          style: TextStyle(fontFamily: "Calibri"),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            // margin: EdgeInsets.all(10.0),
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 25.0),
            child: Column(
              // direction: Axis.vertical,
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                // TODO :add a forgot password option to retrieve password
                Padding(
                  padding: EdgeInsets.only(top: 15.0),
                  child: RaisedButton(
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
                          passwordController1.text !=
                              passwordController2.text) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return new SimpleDialog(
                                title: Text(
                                    'Bummer! Your 2 passwords do not match.'),
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
                          handleSignInResponse(response);
                        });
                      }
                    },
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  child: Divider(),
                ),

                RaisedButton(
                  onPressed: () async {
                    handleSignInResponse(await _testSignInWithGoogle());
                  },
                  // child: ImageIcon(new AssetImage("assets/media/icons/google.png")),
                  child: Text("Google sign-in"),
                ),
                RaisedButton(
                  // TODO: add Facebook authentification capabilities
                  onPressed: _logInWithFacebook,
                  child: Text("Facebook sign-in"),
                ),
                
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 25.0),
                  child: FlatButton(
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
                ),

                Center(
                  child: Text("Crafted in Helvetia."),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
