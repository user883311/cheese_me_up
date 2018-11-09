import 'package:cheese_me_up/app_state_container.dart';
import 'package:cheese_me_up/elements/themed_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class LoginRoute extends StatefulWidget {
  LoginRoute();

  @override
  LoginRouteState createState() => new LoginRouteState();
}

class LoginRouteState extends State<LoginRoute> {
  bool _disableButtons = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _signInOrCreateAccountMode = true;

  TextEditingController _emailController =
      new TextEditingController(text: "user883311@gmail.com");
  TextEditingController _passwordController1 =
      new TextEditingController(text: "password");
  TextEditingController _passwordController2 = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    _disableButtons = false;
    final container = AppStateContainer.of(context);

    Widget _floatingActionButton = FloatingActionButton.extended(
      backgroundColor: Color.fromRGBO(255, 202, 208, 0.9),
      label: Text(
        "show me the\ncheese now!",
        style: TextStyle(color: Colors.black87),
      ),
      icon: Icon(Icons.search, color: Colors.black87),
      onPressed: () {
        Navigator.pushNamed(context, '/checkin_route');
      },
    );

    return Scaffold(
      floatingActionButton: _floatingActionButton,
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
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: "Email address",
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      TextField(
                        controller: _passwordController1,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Password",
                        ),
                      ),
                      _signInOrCreateAccountMode
                          ? Container()
                          : new TextField(
                              controller: _passwordController2,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: "Type your password again",
                              ),
                            ),
                      Padding(
                        padding: EdgeInsets.only(top: 15.0),
                        child: IgnorePointer(
                          ignoring: _disableButtons,
                          child: Builder(
                            builder: (context) {
                              return RaisedButton(
                                // color: Color.fromRGBO(181, 221, 255, 0.8),
                                child: Text(
                                  _signInOrCreateAccountMode
                                      ? "Log into my account"
                                      : "Create account",
                                ),
                                onPressed: () async {
                                  setState(() {
                                    _disableButtons = true;
                                  });
                                  try {
                                    if (!_signInOrCreateAccountMode) {
                                      if (_passwordController1.text !=
                                          _passwordController2.text) {
                                        throw "Your 2 passwords do not match.";
                                      }
                                      await _auth
                                          .createUserWithEmailAndPassword(
                                        email: _emailController.text,
                                        password: _passwordController1.text,
                                      );
                                    }
                                    dynamic _loginAttemptResponse =
                                        await container.emailLogIntoFirebase(
                                            _emailController.text,
                                            _passwordController1.text);
                                    if (_loginAttemptResponse != true) {
                                      throw _loginAttemptResponse;
                                    }
                                  } catch (e) {
                                    print("error came:$e");
                                    showSnackBar(context,
                                        "Bummer! ${e.details.toString()}");
                                  }
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _signInOrCreateAccountMode
                    ? Padding(
                        padding: EdgeInsets.symmetric(vertical: 0.0),
                        child: IgnorePointer(
                          ignoring: _disableButtons,
                          child: EmailVerificationButton(),
                        ),
                      )
                    : Text(
                        "just a placeholder",
                        textScaleFactor: 0.0,
                      ),
                Divider(),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: IgnorePointer(
                    ignoring: _disableButtons,
                    child: RaisedButton(
                      // color: Color.fromRGBO(181, 221, 255, 0.8),
                      onPressed: () => container.googleLogIntoFirebase(),
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
                        _signInOrCreateAccountMode
                            ? "Don't have an account yet? Create one here!"
                            : "Already have an account? Sign in here!",
                        style: TextStyle(color: Colors.blue[900]),
                      ),
                      onPressed: _signInOrCreateAccountMode
                          ? () {
                              setState(() {
                                _signInOrCreateAccountMode = false;
                              });
                            }
                          : () {
                              setState(() {
                                _signInOrCreateAccountMode = true;
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
    TextEditingController emailToReset = new TextEditingController();
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
                FirebaseAuth _auth = FirebaseAuth.instance;
                await _auth
                    .sendPasswordResetEmail(email: emailToReset.text.trim())
                    .then((_) {});
                await showDialog(
                    context: context,
                    builder: (context) => SimpleDialog(children: <Widget>[
                          Text(
                              "A password reset email has been sent to this email address, if it is linked to an active account. Thanks!")
                        ]));
                Navigator.pop(context);
              } on PlatformException catch (e) {
                await showDialog(
                    context: context,
                    builder: (context) => SimpleDialog(
                        children: <Widget>[Text(e.details.toString())]));
              } on Exception catch (e) {
                await showDialog(
                    context: context,
                    builder: (context) =>
                        SimpleDialog(children: <Widget>[Text(e.toString())]));
              } catch (e) {
                print(e);
              }
            },
          ),
        ),
      ],
    );
  }
}
