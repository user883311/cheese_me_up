import 'package:cheese_me_up/models/cheese.dart';
import 'package:cheese_me_up/models/user.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AppState {
  // Your app will use this to know when to display loading spinners.
  bool isLoading;
  User user;
  Map<String, Cheese> cheeses;
  FirebaseStorage storage;

  AppState({
    this.isLoading = false,
    this.user,
    this.cheeses,
    this.storage,
  });

  // A constructor for when the app is loading.
  factory AppState.loading() => new AppState(isLoading: true, cheeses: {});

  @override
  String toString() {
    return 'AppState{isLoading: $isLoading, user: ${user?.displayName ?? 'null'}}';
  }
}
