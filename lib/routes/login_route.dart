import 'dart:async';
import 'package:cheese_me_up/models/user.dart';
import 'package:cheese_me_up/utils/database.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

bool _disableButtons = false;

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
        "displayName": user.email.replaceAll(new RegExp(r"@\w*\.\w*"), ""),
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

class LoginRoute extends StatefulWidget {
  LoginRoute();

  @override
  LoginRouteState createState() {
    userIdCopy = null;
    return new LoginRouteState();
  }
}

class LoginRouteState extends State<LoginRoute> {
  TextEditingController emailController =
      new TextEditingController(text: "user883311@gmail.com");
  TextEditingController passwordController1 =
      new TextEditingController(text: "password");
  TextEditingController passwordController2 =
      new TextEditingController(text: "password");
  // TextEditingController emailToReset =
  //     new TextEditingController(text: "user883311@gmail.com");

  Future _testSignInWithGoogle() async {
    final GoogleSignIn _googleSignIn = new GoogleSignIn();
    _googleSignIn.signOut();
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

      // TODO addNewUserToDatabase ONLY IF user not in db yet
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
    // print("response:\n$response");
    try {
      if (response.runtimeType == FirebaseUser && response.uid != null) {
        Navigator.pushReplacementNamed(context, '/feed_route/${response.uid}');
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
    } finally {
      setState(() {
        _disableButtons = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Color.fromRGBO(181, 221, 255, 0.8),
        label: Text(
          "show me the\ncheese now!",
          style: TextStyle(color: Colors.black87),
        ),
        icon: Icon(
          Icons.search,
          color: Colors.black87,
        ),
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/checkin_route/');
        },
      ),
      resizeToAvoidBottomPadding: false,
      body: Container(
        decoration: new BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/media/img/wallpapers/wp_cheese_001.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 30.0),
                  child: Column(
                    children: [
                      Text(
                        "Brie.",
                        style: TextStyle(fontSize: 40.0, color: Colors.white70),
                      ),
                      Text(
                        "/briː/ French [bʁi]",
                        style: TextStyle(fontSize: 25.0, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: "Email address",
                        ),
                        keyboardType: TextInputType.emailAddress,
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
                        child: IgnorePointer(
                          ignoring: _disableButtons,
                          child: RaisedButton(
                            child: Text(
                              signInOrCreateAccountMode
                                  ? labels["sign_in_button_title"]
                                  : labels["create_account_button_title"],
                            ),
                            onPressed: () async {
                              setState(() {
                                _disableButtons = true;
                              });

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
                      ),
                    ],
                  ),
                ),
                signInOrCreateAccountMode
                    ? Padding(
                        padding: EdgeInsets.symmetric(vertical: 0.0),
                        child: IgnorePointer(
                          ignoring: _disableButtons,
                          child: EmailVerificationButton(),
                        ),
                      )
                    : Text(
                        "placeholder",
                        textScaleFactor: 0.0,
                      ),
                Divider(),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: IgnorePointer(
                    ignoring: _disableButtons,
                    child: RaisedButton(
                      // TODO: add disabled property
                      onPressed: () async {
                        setState(() {
                          _disableButtons = true;
                        });

                        handleSignInResponse(await _testSignInWithGoogle());
                      },
                      child: Text("Google sign-in"),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 25.0),
                  child: IgnorePointer(
                    ignoring: _disableButtons,
                    child: FlatButton(
                      child: Text(
                        signInOrCreateAccountMode
                            ? labels["create_account_link"]
                            : labels["sign_in_link"],
                        style: TextStyle(color: Colors.blue[900]),
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
                ),
                Center(
                  child: Text("Crafted in Helvetia.",
                      style: TextStyle(color: Colors.black87)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class EmailVerificationButton extends StatelessWidget {
  const EmailVerificationButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController emailToReset =
        new TextEditingController(text: "user883311@gmail.com");

    return FlatButton(
      child: Text(
        "Forgot your password? Click here.",
        style: TextStyle(color: Colors.blue[900]),
      ),
      onPressed: () async {
        try {
          await showDialog(
              context: context,
              builder: (BuildContext context) {
                return new EmailVerificationDialog(emailToReset: emailToReset);
              });
        } on Exception catch (e) {
          print('Exception details:\n $e');
        } catch (err) {
          print("2nd error");
        }
      },
    );
  }
}

class EmailVerificationDialog extends StatelessWidget {
  const EmailVerificationDialog({
    Key key,
    @required this.emailToReset,
  }) : super(key: key);

  final TextEditingController emailToReset;
  String validateEmail(String value) {
    String pattern = r'(^\w+@\w+\.\w+$)';
    // user333@fewf.com
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Email is required.";
    } else if (!regExp.hasMatch(value)) {
      return "Is this a valid email?";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(15.0),
          child: Form(
            child: TextFormField(
              controller: emailToReset,
              decoration: InputDecoration(hintText: "Email address"),
              keyboardType: TextInputType.emailAddress,
              validator: validateEmail,
              autovalidate: true,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(15.0),
          child: RaisedButton(
            child: Text("Send me an verification email."),
            onPressed: () async {
              try {
                await _auth
                    .sendPasswordResetEmail(email: emailToReset.text.trim())
                    .then((_) {});
              } on Exception catch (e) {
                print('1/ Exception details:\n $e');
              } catch (e, s) {
                print('2/ Exception details:\n $e');
                print('Stack trace:\n $s');
              } finally {
                await showDialog(
                    context: context,
                    builder: (context) => SimpleDialog(children: <Widget>[
                          Text(
                              "A password reset email has been sent to this email address, if it is linked to an active account. Thanks!")
                        ]));
                Navigator.pop(context);
              }
            },
          ),
        ),
      ],
    );
  }
}
