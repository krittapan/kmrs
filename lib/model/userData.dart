import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  String uid;
  String segmentName;
  String segmentNameTH;
  String type;
  String segmentType;

  UserData({
    required this.uid,
    required this.segmentName,
    required this.type,
    required this.segmentNameTH,
    required this.segmentType,
  });

  factory UserData.fromDocument(DocumentSnapshot doc) {
    return UserData(
      uid: doc['uid'].toString(),
      segmentName: doc['segmentName'].toString(),
      segmentNameTH: doc['segmentNameTH'].toString(),
      type: doc['type'].toString(),
      segmentType: doc['segmentType'].toString(),
    );
  }
}
