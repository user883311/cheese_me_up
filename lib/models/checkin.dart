import 'package:meta/meta.dart';

class CheckIn {
  final String checkinId;
  final DateTime time;
  final String cheeseId;
  final int points;

  CheckIn({
    @required this.time,
    @required this.cheeseId,
    this.checkinId,
    this.points,
  });

  dynamic myEncode(DateTime item) {
    return item.toIso8601String();
  }

  CheckIn.fromCheeseDateTime(String cheeseId, DateTime time,
      [int points, String checkinId])
      : time = time,
        checkinId = checkinId,
        cheeseId = cheeseId,
        points = points;

  // from database
  CheckIn.fromJson(Map<dynamic, dynamic> jsonMap, String keyString)
      : time = DateTime.fromMillisecondsSinceEpoch(jsonMap["time"] as int),
        cheeseId = jsonMap["cheeseId"],
        checkinId = keyString,
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
