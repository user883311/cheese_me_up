import 'package:cheese_me_up/models/cheese.dart';
import 'package:meta/meta.dart';

class CheckIn {
  final DateTime time;
  final String cheeseId;
  final int points;

  CheckIn({
    @required this.time,
    @required this.cheeseId,
    this.points,
  });

  dynamic myEncode(DateTime item) {
    return item.toIso8601String();
  }

  CheckIn.fromCheeseDateTime(String cheeseId, DateTime time, [int points])
      : time = time,
        cheeseId = cheeseId,
        points = points;

  // from database
  CheckIn.fromJson(Map<dynamic, dynamic> jsonMap)
      : time = DateTime.fromMillisecondsSinceEpoch(jsonMap["time"] as int),
        cheeseId = jsonMap["cheeseId"],
        points = jsonMap["points"];

  // to database
  toJson([CheckIn checkin]) {
    return {
      "time": time.millisecondsSinceEpoch,
      "cheeseId": cheeseId,
      "points": points,
    };
  }
}
