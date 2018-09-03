import 'package:firebase_database/firebase_database.dart';
import 'package:meta/meta.dart';

class Cheese {
  String id;
  String name;
  String region;
  String country;
  String image;
  bool show;
  String fullSearch;

  Cheese(
      {@required this.id,
      @required this.name,
      this.region,
      this.country,
      this.image,
      this.show,
      this.fullSearch});

  Cheese.fromSnapshot(DataSnapshot snapshot)
      : id = snapshot.value["id"],
        name = snapshot.value["name"],
        region = snapshot.value["region"],
        country = snapshot.value["country"],
        image = snapshot.value["image"],
        show = true,
        fullSearch = snapshot.value["name"] +
            " " +
            snapshot.value["region"] +
            " " +
            snapshot.value["country"];

  Cheese.fromJson(Map<dynamic, dynamic> json)
      : id = json["id"],
        name = json["name"],
        region = json["region"],
        country = json["country"],
        image = json["image"],
        fullSearch = json["fullSearch"];

  toJson([Cheese cheese]) {
    return {
      "id": id,
      "name": name,
      "region": region,
      "country": country,
      "image": image,
      fullSearch: fullSearch,
    };
  }
}
