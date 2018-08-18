import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:collection';

class User {
  final String username;
  final String email;
  final int id;
  final String password;
  // TODO: cheeses should be a Map<String, Cheese>
  // final Map<String, Cheese> cheeses;
  final cheeses;

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
        // cheeses = snapshot.value["cheeses"],

        cheeses = (snapshot.value["cheeses"] as Map).map(
            (k, v) => new MapEntry(k.toString(), Cheese.fromJson(v as Map))),

        // cheeses = (snapshot.value["cheeses"] as dynamic)
        //     .map((str, snap) => new MapEntry(str, Cheese.fromSnapshot(snap))),

        id = snapshot.value["id"];

  toJson() {
    return {
      "password": password,
      "username": username,
      "email": email,
      "id": id,
      "cheeses": cheeses,
    };
  }
}

class Cheese {
  String id;
  String name;
  String region;
  String country;
  String image;

  Cheese(
    this.id,
    this.name,
    this.region,
    this.country,
    this.image,
  );

  Cheese.fromSnapshot(DataSnapshot snapshot)
      : id = snapshot.value["id"],
        name = snapshot.value["name"],
        region = snapshot.value["Region"],
        country = snapshot.value["Country of origin"],
        image = snapshot.value["image"];

  Cheese.fromJson(Map<dynamic, dynamic> json)
      : id = json["id"],
        name = json["name"],
        region = json["Region"],
        country = json["Country of origin"],
        image = json["image"];

  // Cheese.fromJson(JSON json)
  //     : id = jsonDecode(json["id"]),
  //       name = jsonDecode(json["name"]),
  //       region = jsonDecode(json["Region"]),
  //       country = jsonDecode(json["Country of origin"]),
  //       image = jsonDecode(json["image"]);

  toJson([Cheese cheese]) {
    return {
      "id": id,
      "name": name,
      "Region": region,
      "Country of origin": country,
      "image": image,
    };
  }
}

// error message: type '_InternalLinkedHashMap<dynamic, dynamic>'
// is not a subtype of type 'DataSnapshot' in type cast
