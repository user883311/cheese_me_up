import 'package:cheese_me_up/models/cheese.dart';
import 'package:cheese_me_up/models/user.dart';

/// This function returns the number of points attributed for a 
/// given [CheckIn] by a particular [User].
int pointsForNewCheese(Cheese newlyCheckedInCheese, User user){
  // TODO: new rules for points

  // Rule 1: if cheese never tried before, get 2x the points

  // Rule 2: if cheese from a country never tried before, get 3x the points

  // Rule 3: if cheese tried 10x in a row, get +50% loyalty points

  return 1;
}