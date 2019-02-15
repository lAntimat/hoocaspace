
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryName {

  String id;
  String categoryName;
  int order;

  CategoryName(this.categoryName);

  CategoryName.withId(this.id, this.categoryName, this.order);


  factory CategoryName.fromDocument(DocumentSnapshot d) {
    return new CategoryName.withId(
        d.documentID, d["categoryName"], d["order"]);
  }
}