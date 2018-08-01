// This is a representation of the User object.
// The 2 methods help to translate between the Firebase
// realtime database and the required Flutter JSON objects.

import 'package:cheese_me_up/models/cheese.dart';
import 'package:firebase_database/firebase_database.dart';

class User {
  final String username;
  final String email;
  final int id;
  final String password;
  final List cheeses;

  User(
    this.username,
    this.email,
    this.id,
    this.password,
    this.cheeses,
  );

  User.fromSnapshot(DataSnapshot snapshot)
      : username = snapshot.value["username"],
        email = snapshot.value["email"],
        password = snapshot.value["password"],
        cheeses = snapshot.value["cheeses"].toList(),
        id = snapshot.value["id"];

  toJson() {
    return {
      "password":password,
      "username": username,
      "email": email,
      "id": id,
      "cheeses":cheeses,
    };
  }
}
