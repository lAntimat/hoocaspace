import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String id;
  String name = "";
  String description = "";
  var price;
  String hardness = "";

  Product.withId(this.id, this.name, this.description, this.price, this.hardness);

  Product(this.name, this.description, this.price, this.hardness);

  factory Product.fromDocument(DocumentSnapshot d) {
    return new Product.withId(
        d.documentID, d["name"], d["description"], d["price"], d["hardness"]);
  }
}
