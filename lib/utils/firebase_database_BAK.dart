//
//
//
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';

final FirebaseDatabase database = FirebaseDatabase.instance;

// database.reference().child("message").set({"firstname":"Alex"});
// database.reference().child("message").once().then((DataSnapshot data){
//   print(data.value.values);
// });

final DatabaseReference cheeseDatabase = database.reference().child("cheeses");

Future<Map<int, Map>> getEntireDatabase() async {
  cheeseDatabase.once().then((DataSnapshot data) {
    print(data.value.values);
  });
  return null;
}
