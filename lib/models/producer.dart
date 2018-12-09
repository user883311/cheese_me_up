import 'package:meta/meta.dart';

class Producer {
  String id;
  String name;
  String address;
  num latitude, longitude;
  var plusCode;
  String region, country;
  String image;
  String uri;
  String fullSearch;

  Producer(
      {@required this.id,
      @required this.name,
      this.region,
      this.country,
      this.image,
      this.uri,
      this.address,
      this.latitude,
      this.longitude,
      this.plusCode,
      this.fullSearch});

  Producer.fromMap(Map<dynamic, dynamic> map) {
    this.id = map["producerID"].toString();
    this.name = map["name"];
    this.address = map["address"];
    this.region = map["region"];
    this.uri = map["uri"];
    this.country = "Switzerland";
    this.plusCode = map["plusCode"];
    this.latitude = map["latitude"];
    this.longitude = map["longitude"];
    this.fullSearch = map["name"] + " Switzerland";
  }
}
