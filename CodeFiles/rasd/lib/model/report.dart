import 'package:cloud_firestore/cloud_firestore.dart';

class report {
  String id;
  final int status; //0-> pending , 1->confirmed
  final String v_type;
  final String addInfo;

  report({
    required this.id,
    required this.status,
    required this.v_type,
    required this.addInfo,
  });

  report.fromSnapShot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : id = snapshot.id,
        status = snapshot['status'],
        v_type = snapshot['v_type'],
        addInfo = snapshot['addInfo'];

  static report fromJsonD(Map<String, dynamic> json) => report(
        id: json['id'],
        status: json['status'],
        v_type: json['v_type'],
        addInfo: json['addInfo'],
      );
}
