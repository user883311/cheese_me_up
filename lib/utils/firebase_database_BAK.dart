//
//
//
import 'dart:async';

import 'package:cheese_me_up/models/user.dart';
import 'package:firebase_database/firebase_database.dart';

Future<User> getUserProfile() async {
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference _userRef;

  final int userId = 0;

  _userRef = database.reference().child("users/$userId");
  _userRef.onValue.listen((Event event) {
    try {
      DataSnapshot snapshot = event.snapshot;
      var user = new User.fromSnapshot(snapshot);
      print('Connected to the user database and read ${snapshot.value}');
      print('Howdy, ${user.username}, user ID ${user.id}!');
      print('We sent the verification link to ${user.email}.');
      print('Your pw is ${user.password}.');
      print('Your list of cheeses is ${user.cheeses}.');
      return user;
    } catch (e) {
      print("error message: $e");
      return null;
    }
  });
  return null;
}
