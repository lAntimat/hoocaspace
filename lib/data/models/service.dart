import 'package:cloud_firestore/cloud_firestore.dart';

class Service {
  String id;
  int odometer = 0;
  String name = "";
  String description = "";
  int price = 0;
  int distance = 0;

  Service(
      this.odometer, this.name, this.description, this.price, this.distance);


  Service.withId(this.id, this.odometer, this.name, this.description, this.price,
      this.distance);

  factory Service.fromDocument(DocumentSnapshot d) {
    return new Service.withId(
        d.documentID, d["odometer"], d["name"], d["description"], d["price"], d["distance"]);
  }
}
