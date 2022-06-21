import 'package:cloud_firestore/cloud_firestore.dart';

class Ap {
  late final String list_of_experiences;
  late final String storage;
  late final String guidelines;
  String? list_of_experiencesCheck;
  String? storageCheck;
  bool? guidelinesCheck;

  Ap({
    required this.list_of_experiences,
    required this.storage,
    required this.guidelines,
    this.list_of_experiencesCheck,
    this.storageCheck,
    this.guidelinesCheck,
  });

  factory Ap.fromDocument(DocumentSnapshot doc) {
    return Ap(
      list_of_experiences: doc['list_of_experiences'].toString(),
      storage: doc['storage'].toString(),
      guidelines: doc['guidelines'].toString(),
      list_of_experiencesCheck: doc['list_of_experiencesCheck'].toString(),
      storageCheck: doc['storageCheck'].toString(),
      guidelinesCheck: doc['guidelinesCheck'] as bool,
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['list_of_experiences'] = this.list_of_experiences;
    data['storage'] = this.storage;
    data['guidelines'] = this.guidelines;
    data['list_of_experiencesCheck'] = this.list_of_experiencesCheck;
    data['storageCheck'] = this.storageCheck;
    //data['list_of_experiencesCheck'] = 'ไม่ตรงตามยุทธศาสตร์';
    //data['storageCheck'] = 'ไม่ระบุบ';
    data['guidelinesCheck'] = this.guidelinesCheck;
    return data;
  }

  Ap.fromMap(Map<dynamic, dynamic> map)
      : list_of_experiences = map['list_of_experiences'].toString(),
        storage = map['storage'].toString(),
        guidelines = map['guidelines'].toString(),
        list_of_experiencesCheck = map['list_of_experiencesCheck'].toString(),
        storageCheck = map['storageCheck'].toString(),
        guidelinesCheck = map['guidelinesCheck'] as bool;
}
