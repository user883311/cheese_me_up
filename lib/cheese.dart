// This is a representation of the Cheese object.
// The 2 methods help to translate between the Firebase
// realtime database and the required Flutter JSON objects.

import 'package:firebase_database/firebase_database.dart';

class Cheese {
  String id;
  String name;
  String region;
  String country;
  String image;

  Cheese(
    this.name,
    this.region,
    this.country,
    this.image,
  );

  Cheese.fromSnapshot(DataSnapshot snapshot)
      : id = snapshot.key,
        name = snapshot.value["name"],
        region = snapshot.value["Region"],
        country = snapshot.value["Country of origin"],
        image = snapshot.value["image"];

  toJson() {
    return {
      "name": name,
      "Region": region,
      "Country of origin": country,
      "image": image,
    };
  }
}
