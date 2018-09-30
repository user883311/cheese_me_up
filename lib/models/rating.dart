import 'package:meta/meta.dart';

class Rating {
  final DateTime time;
  final String cheeseId;
  final int rating;

  Rating({
    @required this.time,
    @required this.cheeseId,
    this.rating,
  });

  dynamic myEncode(DateTime item) {
    return item.toIso8601String();
  }

  Rating.fromCheeseDateTime(String cheeseId, DateTime time, [int rating])
      : time = time,
        cheeseId = cheeseId,
        rating = rating;

  Rating.fromJson(Map<dynamic, dynamic> jsonMap)
      : time = DateTime.fromMillisecondsSinceEpoch(jsonMap["time"] as int),
        cheeseId = jsonMap["cheeseId"],
        rating = jsonMap["rating"];

  toJson([Rating checkin]) {
    return {
      "time": time.millisecondsSinceEpoch,
      "cheeseId": cheeseId,
      "rating": rating,
    };
  }
}
