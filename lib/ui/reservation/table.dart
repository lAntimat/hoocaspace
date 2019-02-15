import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hoocaspace/ui/reservation/reservation.dart';

class Table {
  String id;
  String tableName;
  int personCount;
  bool withGameConsole;
  String consoleName;
  List<Reservation> reservations;

  Table(this.tableName, this.personCount, this.withGameConsole,
      this.consoleName, this.reservations);

  Table.withId(this.id, this.tableName, this.personCount, this.withGameConsole,
      this.consoleName, this.reservations);

  factory Table.fromDocument(DocumentSnapshot d) {
    return new Table.withId(d.documentID, d["tableName"], d["personCount"],
        d["reservationDate"], d["personCount"], d["message"]);
  }

  toMap() {
    var map = new Map<String, dynamic>();
    map['tableName'] = tableName;
    map['personCount'] = personCount;
    map['withGameConsole'] = withGameConsole;
    map['consoleName'] = consoleName;
    map['reservations'] = reservations;
    map['timestamp'] = FieldValue.serverTimestamp();
    return new Map.from(map).cast<String, dynamic>();
  }
}
