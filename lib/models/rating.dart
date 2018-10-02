import 'package:meta/meta.dart';

class Rating {
  final DateTime time;
  final String cheeseId;
  final double rating;

  Rating({
    @required this.time,
    @required this.cheeseId,
    @required this.rating,
  });

  dynamic myEncode(DateTime item) {
    return item.toIso8601String();
  }

  Rating.fromCheeseDateTime(String cheeseId, DateTime time, double rating)
      : time = time,
        cheeseId = cheeseId,
        rating = rating;

  Rating.fromJson(Map<dynamic, dynamic> jsonMap)
      : time = DateTime.fromMillisecondsSinceEpoch(jsonMap["time"] as int),
        cheeseId = jsonMap["cheeseId"],
        rating = jsonMap["rating"]*1.0;

  toJson([Rating checkin]) {
    return {
      "time": time.millisecondsSinceEpoch,
      "cheeseId": cheeseId,
      "rating": rating,
    };
  }
}
