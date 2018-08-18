// import 'package:cheese_me_up/models/cheese.dart';
import 'dart:convert';
class Cheese {
  String id;
  String name;
  String region;
  String country;
  String image;

  Cheese(
    this.id,
    this.name,
    this.region,
    this.country,
    this.image,
  );

  Cheese.fromJson(Json string) 
      : id = "id)",
        name = "name1",
        region = "region1",
        country = "origi1n",
        image = "img";
}

void main() {
  Map start = {
    "id": "id",
    "name": "name",
    "Region": "region",
    "Country of origin": "country",
    "image": "image",
  };
  print(start.toString().runtimeType);
  // Cheese cheese = Json.;
}
