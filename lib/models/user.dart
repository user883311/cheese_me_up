// This is a representation of the User object.
// The 2 methods help to translate between the Firebase
// realtime database and the required Flutter JSON objects.

import 'package:firebase_database/firebase_database.dart';

class User {
  int id;
  String username;
  String email;
  List<Map> cheeses;

  User(
    this.username,
    this.email,
    this.cheeses,
  );

  User.fromSnapshot(DataSnapshot snapshot)
      : id = snapshot.value["id"],
        username = snapshot.value["username"],
        email = snapshot.value["email"],
        cheeses = snapshot.value["cheeses"];

  toJson() {
    return {
      "username": username,
      "email": email,
      "cheeses": cheeses,
    };
  }
}
