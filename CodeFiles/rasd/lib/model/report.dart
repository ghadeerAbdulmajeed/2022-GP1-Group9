import 'package:cloud_firestore/cloud_firestore.dart';

class report {
  String id;
  final int status; //0-> pending , 1->confirmed
  final String v_type;

  report({
    required this.id,
    required this.status,
    required this.v_type,
  });

  report.fromSnapShot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : id = snapshot.id,
        status = snapshot['status'],
        v_type = snapshot['v_type'];

  static report fromJsonD(Map<String, dynamic> json) => report(
        id: json['id'],
        status: json['status'],
        v_type: json['v_type'],
      );
}
