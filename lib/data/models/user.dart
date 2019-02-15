import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id;
  String name = "";
  String phoneNumber = "";
  String imageUrl = "";

  User.withId(this.id, this.name, this.imageUrl, this.phoneNumber);

  User(this.name, this.imageUrl, this.phoneNumber);

  factory User.fromDocument(DocumentSnapshot d) {
    return new User.withId(
        d.documentID,
        d["name"] ?? "",
        d["imageUrl"] ?? "",
        d["phoneNumber"] ?? "");
  }
   toMap() {
     var map = new Map<String, dynamic>();
     map['id'] = id;
     map['name'] = name;
     map['phoneNumber'] = phoneNumber;
     map['imageUrl'] = imageUrl;
     map['createdAt'] = FieldValue.serverTimestamp();
    return new Map.from(map).cast<String, dynamic>();

    //d.documentID, d["name"], d["phoneNumber"], d["phoneNumber"]);
  }
}
