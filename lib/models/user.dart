import 'dart:math';
import 'package:meta/meta.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cheese_me_up/models/checkin.dart';
import 'package:cheese_me_up/models/rating.dart';

class User {
  final String displayName;
  final String email;
  final String id;
  final String password;
  final Map<String, CheckIn> checkins;
  final Map<String, Rating> ratings;
  final bool isEmailVerified;

  User({
    @required this.displayName,
    @required this.email,
    @required this.id,
    this.password,
    this.checkins,
    this.ratings,
    this.isEmailVerified,
  });

  User.fromSnapshot(DataSnapshot snapshot)
      : displayName = snapshot.value["displayName"],
        email = snapshot.value["email"],
        password = snapshot.value["password"],
        checkins = (snapshot.value["checkins"] as Map ?? {}).map(
            (k, v) => new MapEntry(k.toString(), CheckIn.fromJson(v as Map))),
        ratings = (snapshot.value["ratings"] as Map ?? {}).map(
            (k, v) => new MapEntry(k.toString(), Rating.fromJson(v as Map))),
        id = snapshot.value["id"],
        isEmailVerified = snapshot.value["isEmailVerified"];

  User.fromJson(Map<dynamic, dynamic> json)
      : id = json["id"],
        displayName = json["displayName"],
        email = json["email"],
        password = json["password"],
        checkins = json["checkins"],
        ratings = json["ratings"],
        isEmailVerified = json["isEmailVerified"];

  toJson() {
    return {
      "password": password,
      "displayName": displayName,
      "email": email,
      "id": id,
      "checkins": checkins,
      "ratings": ratings,
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

  Set<String> get uniqueCheeseIds {
    var checkinsSorted = checkins.values.toList();
    checkinsSorted.sort((a, b) => a.time.compareTo(b.time));
    var uniqueCheesesId = new Set<String>();
    for (CheckIn checkin in checkinsSorted) {
      if (uniqueCheesesId.contains(checkin.cheeseId) == false) {
        uniqueCheesesId.add(checkin.cheeseId);
      }
    }
    return uniqueCheesesId;
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
    timeFilter(checkin) =>
        checkin.time.isAfter(from) && checkin.time.isBefore(to);
    List<CheckIn> result = checkins.values.where(timeFilter).toList();
    result.sort((a, b) => a.time.compareTo(b.time));
    return result;
  }
}
