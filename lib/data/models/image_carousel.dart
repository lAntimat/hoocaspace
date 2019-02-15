import 'package:cloud_firestore/cloud_firestore.dart';

class ImageCarousel {
  String id;
  String title = "";
  String url = "";
  var order = 0;

  ImageCarousel.withId(this.id, this.title, this.url, this.order);

  factory ImageCarousel.fromDocument(DocumentSnapshot d) {
    return new ImageCarousel.withId(
        d.documentID, d["title"], d["url"], d["order"]);
  }
}
