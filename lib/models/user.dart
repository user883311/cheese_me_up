import 'dart:math';

import 'package:cheese_me_up/models/checkin.dart';
import 'package:cheese_me_up/models/cheese.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:meta/meta.dart';

class User {
  final String displayName;
  final String email;
  final String id;
  final String password;
  final Map<String, CheckIn> checkins;
  final bool isEmailVerified;

  User({
    @required this.displayName,
    @required this.email,
    @required this.id,
    this.password,
    this.checkins,
    this.isEmailVerified,
  });

  User.fromSnapshot(DataSnapshot snapshot)
      : displayName = snapshot.value["displayName"],
        email = snapshot.value["email"],
        password = snapshot.value["password"],
        checkins = (snapshot.value["checkins"] as Map ?? {}).map(
            (k, v) => new MapEntry(k.toString(), CheckIn.fromJson(v as Map))),
        id = snapshot.value["id"],
        isEmailVerified = snapshot.value["isEmailVerified"];

  User.fromJson(Map<dynamic, dynamic> json)
      : id = json["id"],
        displayName = json["displayName"],
        email = json["email"],
        password = json["password"],
        checkins = json["checkins"],
        isEmailVerified = json["isEmailVerified"];

  toJson() {
    return {
      "password": password,
      "displayName": displayName,
      "email": email,
      "id": id,
      "checkins": checkins,
      "isEmailVerified": isEmailVerified,
    };
  }

  int get sumPoints {
    int sumPoints = 0;
    for (CheckIn checkin in checkins.values) {
      sumPoints += checkin.points ?? 0;
    }
    return sumPoints;
  }

  Set<Cheese> get uniqueCheeses {
    var uniqueCheeses = new Set<Cheese>();
    var uniqueCheesesId = new Set<String>();
    for (CheckIn checkin in checkins.values) {
      if (uniqueCheesesId.contains(checkin.cheese.id) == false) {
        uniqueCheeses.add(checkin.cheese);
      }
      uniqueCheesesId.add(checkin.cheese.id);
    }
    return uniqueCheeses;
  }

  CheckIn get randomCheckin {
    var random = new Random();
    if (checkins.isNotEmpty) {
      return checkins.values.toList()[random.nextInt(checkins.length)];
    } else {
      return null;
    }
  }

  List<CheckIn> getCheckinsFromPeriod(DateTime from, DateTime to) {
    myFilter(checkin) =>
        checkin.time.isAfter(from) || checkin.time.isBefore(to);
    List<CheckIn> result = checkins.values.where(myFilter).toList();
    return result;
  }
}
