import 'package:cheese_me_up/models/checkin.dart';
import 'package:cheese_me_up/models/cheese.dart';
import 'package:cheese_me_up/models/user.dart';
import 'package:meta/meta.dart';
import 'package:intl/intl.dart';

class Sentence {
  final User user;

  Sentence({
    @required this.user,
  });

  String get greetings => "Howdy ${user.displayName ?? ""}!";

  String get recapTotalPointsToDate {
    List< CheckIn> checkins = user.checkins.values.toList();
    checkins.sort((a, b) => a.time.compareTo(b.time));
    String response = "";
    if (checkins.length == 0) {
      response += "You have'nt tried any cheese yet -- as far as we know! ";
      response += "\nLet us know the yummylicious cheese you've just had! ";
    } else if (checkins.length > 1) {
      response += "To this day, you have scored ${user.sumPoints} points! ";
      response +=
          "\nYour very first cheese (as far as we remember) was ${checkins.first.cheese.name}. ";
      response +=
          "The latest one was... ${checkins.last.cheese.name}. ";
    } else if (user.checkins.length == 1) {
      response += "To this day, you have scored ${user.sumPoints} points!";
      response +=
          "\nYou've already checked in your very first cheese: a ${checkins.first.cheese.name}. ";
      response += "Congratulations!";
    }
    return response;
  }

  String get uniqueCheesesListSentence {
    if (user.uniqueCheeses.isEmpty) {
      return null;
    } else if (user.uniqueCheeses.length == 1) {
      String response =
          "You have only tried ${user.uniqueCheeses.length} cheese: a ${user.uniqueCheeses.first.name}";
      return response;
    } else {
      String response =
          "You have tried ${user.uniqueCheeses.length} different cheeses: ";
      // TODO: sort Cheeses by date added
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

  String rememberCheckin(CheckIn checkin) {
    return "On ${DateFormat("EEEEE, MMM d, ''yy").format(checkin.time)}, you had some ${checkin.cheese.name}";
  }

  String listOfCheeseNames(Iterable<Cheese> iterable) {
    if (iterable.isEmpty) {
      return null;
    } else if (iterable.length == 1) {
      return "${iterable.first.name}";
    } else {
      String response = "";
      List list = iterable.toList();
      Cheese cheese;
      for (var i = 0; i < list.length; i++) {
        cheese = list[i];
        if (i == list.length - 1) {
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
