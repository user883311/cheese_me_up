import 'package:cheese_me_up/models/cheese.dart';
import 'package:cheese_me_up/models/producer.dart';
import 'package:cheese_me_up/models/user.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AppState {
  // Your app will use this to know when to display loading spinners.
  bool isLoading;
  User user;
  Map<String, Cheese> cheeses;
  Map<String, Producer> producers;
  FirebaseStorage storage;
  var sqlDatabase;
  // Map<String, List<Cheese>> cheesesListByProducer;
  // Map<String, List<Cheese>> producersListByCheese;

  AppState({
    this.isLoading = false,
    this.user,
    this.cheeses,
    this.producers,
    this.storage,
  });

  // A constructor for when the app is loading.
  factory AppState.loading() => new AppState(isLoading: true, cheeses: {}, producers: {});

  @override
  String toString() {
    return 'AppState{isLoading: $isLoading, user: ${user?.displayName ?? 'null'}}';
  }
}
