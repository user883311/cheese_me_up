import 'package:cheese_me_up/models/user_cheese.dart';
import 'package:meta/meta.dart';

class Sentence {
  // TODO: add locale...
  final User user;

  Sentence({
    @required this.user,
  });

  String get greetings => "Howdy ${user.username}!";

  String get recapTotalPointsToDate {
    String response = "";
    if (user.checkins.length == 0) {
      response += "You have'nt tried any cheese yet -- as far as we know! ";
      response += "\nLet us know the yummylicious cheese you've just had! ";
    } else if (user.checkins.length > 1) {
      response +=
          "To this day, you have scored ${user.sumPoints} points! ";
      response +=
          "\nYour very first cheese (as far as we remember) was ${user.checkins.values.first.cheese.name}. ";
      response +=
          "The latest one was... ${user.checkins.values.last.cheese.name}. ";
    } else if (user.checkins.length == 1) {
      response += "To this day, you have scored ${user.sumPoints} points!";
      response +=
          "\nYou've already checked in your very first cheese: a ${user.checkins.values.first.cheese.name}. ";
      response += "Congratulations!";
    }
    return response;
  }
}
