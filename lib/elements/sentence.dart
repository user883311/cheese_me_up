import 'package:cheese_me_up/models/user.dart';
import 'package:meta/meta.dart';

class Sentence {
  final User user;

  Sentence({
    @required this.user,
  });

  String get greetings => "Howdy ${user.displayName?? ""}!";

  String get recapTotalPointsToDate {
    String response = "";
    if (user.checkins.length == 0) {
      response += "You have'nt tried any cheese yet -- as far as we know! ";
      response += "\nLet us know the yummylicious cheese you've just had! ";
    } else if (user.checkins.length > 1) {
      response += "To this day, you have scored ${user.sumPoints} points! ";
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

  String get uniqueCheesesListSentence {
    if (user.uniqueCheeses.isEmpty) {
      return null;
    } else {
      String response = "";

      for (var i = 0; i < user.uniqueCheeses.length; i++) {
        var cheese = user.uniqueCheeses.toList()[i];
        if (i == user.uniqueCheeses.length - 1) {
          response += " and ";
        } else if (i != 0) {
          response += ", ";
        }
        response += cheese.name;
      }

      return response;
    }
  }
}
