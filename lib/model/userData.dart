import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String organizationName;
  final String userType;

  UserData({
    required this.organizationName,
    required this.userType,
  });

  factory UserData.fromDocument(DocumentSnapshot doc) {
    return UserData(
      organizationName: doc['organizationName'].toString(),
      userType: doc['userType'].toString(),
    );
  }
}
