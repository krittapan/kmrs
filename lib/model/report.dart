import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
  String userType;
  String type;

  Report({
    required this.userType,
    required this.type,
  });

  factory Report.fromDocument(DocumentSnapshot doc) {
    return Report(
      userType: doc['userType'].toString(),
      type: doc['type'].toString(),
    );
  }
}
