import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:cheese_me_up/models/app_state.dart';
import 'package:cheese_me_up/models/cheese.dart';
import 'package:cheese_me_up/models/producer.dart';
import 'package:cheese_me_up/models/user.dart';
import 'package:cheese_me_up/utils/database.dart';

enum LoginType { email, google, facebook }

/// The AppStateContainer is an [InheritedWidget] wrapped in a [StatefulWidget].
/// This basically makes the container a stateful widget that has the ability to pass
/// state all the way down the tree and be updated with [setState()], which would rerender
/// all the ancestor widgets that rely on the slice of state updated.
class AppStateContainer extends StatefulWidget {
  final AppState state;
  final Widget child;

  AppStateContainer({
    @required this.child,
    this.state,
  });

  // This creates a method on the AppState that's just like 'of'
  // On MediaQueries, Theme, etc
  // This is the secret to accessing your AppState all over your app
  static _AppStateContainerState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_InheritedStateContainer)
            as _InheritedStateContainer)
        .data;
  }

  @override
  _AppStateContainerState createState() => new _AppStateContainerState();
}

class _AppStateContainerState extends State<AppStateContainer> {
  // Pass the state through because on a StatefulWidget,
  // properties are immutable. This way we can update it.
  AppState state;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference _userRef;
  StreamSubscription streamSubscription;
  // This is used to sign into Google, not Firebase.
  GoogleSignInAccount googleUser;
  final googleSignIn = new GoogleSignIn();

  @override
  void initState() {
    super.initState();
    if (widget.state != null) {
      state = widget.state;
    } else {
      state = new AppState.loading();
      initUser();
      // initFirebaseCheeses();
      initSqliteCheeses();
      // initFirebaseStorage();
    }
  }

  @override
  void dispose() {
    streamSubscription.cancel();
    super.dispose();
  }

  // Future<void> initFirebaseStorage() async {
  //   FirebaseApp app = FirebaseApp(name: "cheesopedia");
  //   var storage = FirebaseStorage(
  //       app: app, storageBucket: 'gs://cheese-me-up.appspot.com');
  //   state.storage = storage;
  // }

  /// Accesses the Firebase cheeses node and loads every [Cheese] entry into the
  /// [cheeses] collection.
  // Future<Null> initFirebaseCheeses() async {
  //   final FirebaseDatabase database = FirebaseDatabase.instance;
  //   Query _cheesesRef;
  //   _cheesesRef = database.reference().child("cheeses").orderByChild("name");
  //   void _onEntryAdded(Event event) {
  //     setState(() {
  //       Cheese cheese = Cheese.fromSnapshot(event.snapshot);
  //       state.cheeses[cheese.id.toString()] = cheese;
  //     });
  //   }

  //   _cheesesRef.onChildAdded.listen(_onEntryAdded);
  // }

  /// Accesses the SQLite cheeses database and loads every [Cheese] entry into the
  /// [cheeses] collection.
  Future<Null> initSqliteCheeses() async {
    // Construct the path to the app's writable database file:
    var dbDir = await getDatabasesPath();
    var dbPath = join(dbDir, "app.db");

    // Delete any existing database:
    await deleteDatabase(dbPath);

    // Create the writable database file from the bundled cheeses database file:
    ByteData data = await rootBundle.load("assets/database/cheeses.db");
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(dbPath).writeAsBytes(bytes);

    state.sqlDatabase = await openDatabase(dbPath);
    var db = state.sqlDatabase;

    // Get the cheeses.
    List<Map> cheesesList = await db.rawQuery('SELECT * FROM cheeses');
    for (Map cheeseMap in cheesesList) {
      setState(() {
        state.cheeses[cheeseMap["cheeseID"].toString()] =
            Cheese.fromMap(cheeseMap);
      });
    }

    // Get the producers.
    List<Map> producersList = await db.rawQuery('SELECT * FROM producers');
    for (Map producerMap in producersList) {
      print("producerMap= \n$producerMap");
      setState(() {
        state.producers[producerMap["producerID"].toString()] =
            Producer.fromMap(producerMap);
      });
    }

    // // get the producedBy
    // List<Map<String,String>> producedBy = await db.rawQuery('SELECT * FROM producedBy');
    // // create two Maps for retrieving cheeses and producers alike
    // for (Map<String,String> producedByLine in producedBy) {
    //   print("producedByLine= \n$producedByLine");
    //   setState(() {
    //     state.producers[producerMap["producerID"].toString()] =
    //         Producer.fromMap(producerMap);
    //   });
    // }

    // await db.close();
  }

  Future<Null> initUser() async {
    // First, check if a user exists.
    googleUser = await _ensureGoogleLoggedInOnStartUp();
    // If the user is null, we aren't loading anyhting
    // because there isn't anything to load.
    // This will force the homepage to navigate to the auth page.
    if (googleUser == null) {
      print("googleUser == null ...");
      setState(() {
        state.isLoading = false;
      });
    } else {
      print("googleUser: $googleUser");
      // If there is a user, tell Flutter to keep that
      // loading screen up Firebase logs in this user.
      await googleLogIntoFirebase();
    }
  }

  Future<GoogleSignInAccount> _ensureGoogleLoggedInOnStartUp() async {
    // That class has a currentUser if there's already a user signed in on
    // this device.
    GoogleSignInAccount user = googleSignIn.currentUser;
    if (user == null) {
      // but if not, Google should try to sign one in whos previously signed in
      // on this phone.
      user = await googleSignIn.signInSilently();
    }
    // NB: This could still possibly be null.
    googleUser = user;
    return user;
  }

  Future<Null> googleLogIntoFirebase() async {
    // This method will be used in two cases,
    // To make it work from both, we'll need to see if theres a user.
    // When fired from the button on the auth screen, there should
    // never be a googleUser
    if (googleUser == null) {
      // This built in method brings starts the process
      // Of a user entering their Google email and password.
      googleUser = await googleSignIn.signIn();
    }

    // This is how you'll always sign into Firebase.
    // It's all built in props and methods, so not much work on your end.
    FirebaseUser firebaseUser;
    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      // Authenticate the GoogleUser
      // This will give back an access token and id token
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      // Sign in to firebase with that:
      firebaseUser = await _auth.signInWithGoogle(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      // Not necessary
      print('Logged in with Google Sign In, firebaseUser: $firebaseUser');

      setState(() {
        // Updating the isLoading will force the Homepage to change because of
        // The inheritedWidget setup.
        state.isLoading = false;
      });

      // Add the user to the global app state
      _userRef = database.reference().child("users/${firebaseUser.uid}");
      streamSubscription = _userRef.onValue.listen((Event event) async {
        bool _isUserNotInDatabase = (event.snapshot.value == null);
        if (_isUserNotInDatabase) {
          User newUser = User.fromJson({
            "id": firebaseUser.uid,
            "displayName": firebaseUser.displayName,
            "email": firebaseUser.email,
            "isEmailVerified": firebaseUser.isEmailVerified,
          });
          // Add new user to the database
          await addUserToFirebase(newUser, firebaseUser.uid);
        }
        setState(() {
          state.user = new User.fromSnapshot(event.snapshot);
        });
      });
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<dynamic> emailLogIntoFirebase(String email, String password) async {
    FirebaseUser firebaseUser;
    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      firebaseUser = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      print('Logged in via email, firebaseUser: $firebaseUser');

      setState(() {
        // Updating the isLoading will force the Homepage to change because of
        // The inheritedWidget setup.
        state.isLoading = false;
      });

      // Add the user to the global state
      _userRef = database.reference().child("users/${firebaseUser.uid}");
      streamSubscription = _userRef.onValue.listen((Event event) async {
        bool _isUserNotInDatabase = (event.snapshot.value == null);
        if (_isUserNotInDatabase) {
          User newUser = User.fromJson({
            "id": firebaseUser.uid,
            "displayName": firebaseUser.displayName,
            "email": firebaseUser.email,
          });
          // Add new user to the database
          await addUserToFirebase(newUser, firebaseUser.uid);
        }
        setState(() {
          state.user = new User.fromSnapshot(event.snapshot);
        });
      });
      return true;
    } catch (e) {
      print("Firebase sign-in error (${e.runtimeType}):\n$e");
      return e;
    }
  }

  Future getAuthentificatedUser(LoginType loginType,
      [String email, String password]) async {
    FirebaseUser firebaseUser;
    FirebaseAuth _auth = FirebaseAuth.instance;

    // get the firebase user ID = authentify user
    String firebaseUserID;
    try {
      switch (loginType) {
        case LoginType.email:
          print("LoginType.email");
          print("email=$email");
          firebaseUser = await _auth.signInWithEmailAndPassword(
              email: email, password: password);
          setState(() {
            // Updating the isLoading will force the Homepage to change because of
            // The inheritedWidget setup.
            state.isLoading = false;
          });
          break;

        case LoginType.google:
          print("LoginType.google");
          GoogleSignInAuthentication googleAuth =
              await googleUser.authentication;
          firebaseUser = await _auth.signInWithGoogle(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );
          setState(() {
            state.isLoading = false;
          });
          break;

        default:
      }
      print('--Logged in with Google Sign In, firebaseUser: $firebaseUser');
      firebaseUserID = firebaseUser.uid;
    } catch (error) {
      print("Sign-in error (${error.runtimeType}):\n$error");
      throw error;
    }

    // User firebase user ID to add the user to the app global state
    _userRef = database.reference().child("users/$firebaseUserID");
    streamSubscription = _userRef.onValue.listen((Event event) async {
      bool _isUserNotInDatabase = (event.snapshot.value == null);
      if (_isUserNotInDatabase) {
        User newUser = User.fromJson({
          "id": firebaseUser.uid,
          "displayName": firebaseUser.displayName,
          "email": firebaseUser.email,
        });
        // Add new user to the database
        await addUserToFirebase(newUser, firebaseUser.uid);
      }

      User userInstance = User.fromSnapshot(event.snapshot);
      print(userInstance.toString());
      setState(() {
        state.user = userInstance;
      });
      return userInstance;
    });
  }

  // So the WidgetTree is actually
  // AppStateContainer --> InheritedStateContainer --> The rest of your app.
  @override
  Widget build(BuildContext context) {
    return new _InheritedStateContainer(
      data: this,
      child: widget.child,
    );
  }
}

// This is likely all your InheritedWidget will ever need.
class _InheritedStateContainer extends InheritedWidget {
  // The data is whatever this widget is passing down.
  final _AppStateContainerState data;

  // InheritedWidgets are always just wrappers.
  // So there has to be a child,
  // Although Flutter just knows to build the Widget thats passed to it
  // So you don't have have a build method or anything.
  _InheritedStateContainer({
    Key key,
    @required this.data,
    @required Widget child,
  }) : super(key: key, child: child);

  // This is a better way to do this, which you'll see later.
  // But basically, Flutter automatically calls this method when any data
  // in this widget is changed.
  // You can use this method to make sure that flutter actually should
  // repaint the tree, or do nothing.
  // It helps with performance.
  @override
  bool updateShouldNotify(_InheritedStateContainer old) => true;
}
