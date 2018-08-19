import 'package:firebase_database/firebase_database.dart';
import 'package:meta/meta.dart';

class User {
  final String username;
  final String email;
  final int id;
  final String password;
  final Map<String, CheckIn> checkins;

  User({
    @required this.username,
    @required this.email,
    @required this.id,
    this.password,
    this.checkins,
  });

  User.fromSnapshot(DataSnapshot snapshot)
      : username = snapshot.value["username"],
        email = snapshot.value["email"],
        password = snapshot.value["password"],
        checkins = (snapshot.value["checkins"] as Map ?? {}).map(
            (k, v) => new MapEntry(k.toString(), CheckIn.fromJson(v as Map))),
        id = snapshot.value["id"];

  toJson() {
    return {
      "password": password,
      "username": username,
      "email": email,
      "id": id,
      "checkins": checkins,
    };
  }
}

class Cheese {
  String id;
  String name;
  String region;
  String country;
  String image;

  Cheese({
    @required this.id,
    @required this.name,
    this.region,
    this.country,
    this.image,
  });

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

class CheckIn {
  final DateTime time;
  final Cheese cheese;
  final int points;

  CheckIn({
    @required this.time,
    @required this.cheese,
    this.points,
  });

  dynamic myEncode(DateTime item) {
    return item.toIso8601String();
  }

  CheckIn.fromCheeseDateTime(Cheese cheese, DateTime time, [int points])
      : time = time,
        cheese = cheese,
        points = points;

  CheckIn.fromJson(Map<dynamic, dynamic> jsonMap)
      : time = DateTime.fromMillisecondsSinceEpoch(jsonMap["time"] as int),
        cheese = Cheese.fromJson(jsonMap["cheese"]),
        points = jsonMap["points"];

  toJson([CheckIn checkin]) {
    return {
      "time": time.millisecondsSinceEpoch,
      "cheese": cheese.toJson(),
    };
  }
}
