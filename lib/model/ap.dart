import 'package:cloud_firestore/cloud_firestore.dart';

class Ap {
  late final String list_of_experiences;
  late final String storage;
  late final String guidelines;

  Ap({
    required this.list_of_experiences,
    required this.storage,
    required this.guidelines,
  });

  factory Ap.fromDocument(DocumentSnapshot doc) {
    return Ap(
      list_of_experiences: doc['list_of_experiences'].toString(),
      storage: doc['storage'].toString(),
      guidelines: doc['guidelines'].toString(),
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['list_of_experiences'] = this.list_of_experiences;
    data['storage'] = this.storage;
    data['guidelines'] = this.guidelines;
    return data;
  }

  Ap.fromMap(Map<dynamic, dynamic> map)
      : list_of_experiences = map['list_of_experiences'].toString(),
        storage = map['storage'].toString(),
        guidelines = map['guidelines'].toString();
}
