import 'package:cheese_me_up/models/cheese.dart';
import 'package:cheese_me_up/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppState {
  // Your app will use this to know when to display loading spinners.
  bool isLoading;
  // FirebaseUser user;
  User user;
  Map<String, Cheese> cheeses;
  

  // Constructor
  AppState({
    this.isLoading = false,
    this.user,
    this.cheeses,
    
  });

  // A constructor for when the app is loading.
  factory AppState.loading() => new AppState(isLoading: true, cheeses: {});

  @override
  String toString() {
    return 'AppState{isLoading: $isLoading, user: ${user?.displayName ?? 'null'}}';
  }
}
