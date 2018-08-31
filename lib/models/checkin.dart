import 'package:cheese_me_up/models/cheese.dart';
import 'package:meta/meta.dart';

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
      "points": points,
    };
  }
}
