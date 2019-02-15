import 'package:cloud_firestore/cloud_firestore.dart';

class Reservation {
  String id;
  String tableId;
  String clientId;
  DateTime reservationDate;
  int personCount;
  String message;

  Reservation(this.tableId, this.clientId, this.reservationDate,
      this.personCount, this.message);

  Reservation.withId(this.id, this.tableId, this.clientId, this.reservationDate,
      this.personCount, this.message);

  factory Reservation.fromDocument(DocumentSnapshot d) {
    return new Reservation.withId(d.documentID, d["tableId"], d["clientId"],
        d["reservationDate"], d["personCount"], d["message"]);
  }

  toMap() {
    var map = new Map<String, dynamic>();
    map['tableId'] = tableId;
    map['clientId'] = clientId;
    map['reservationDate'] = reservationDate;
    map['personCount'] = personCount;
    map['message'] = message;
    map['timestamp'] = FieldValue.serverTimestamp();
    return new Map.from(map).cast<String, dynamic>();
  }
}
