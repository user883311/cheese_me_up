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
      : id = snapshot.value["id"].toString(),
        name = snapshot.value["name"].toString(),
        region = snapshot.value["region"].toString(),
        country = snapshot.value["country"].toString(),
        image = snapshot.value["image"].toString(),
        show = true,
        fullSearch = snapshot.value["name"].toString() +
            " " +
            snapshot.value["region"].toString() +
            " " +
            snapshot.value["country"].toString();

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
