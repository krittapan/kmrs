import 'package:cloud_firestore/cloud_firestore.dart';

class Asis {
  final String strengths;
  final String weaknesses;
  final String opportunities;
  final String threatsl;

  Asis({
    required this.strengths,
    required this.weaknesses,
    required this.opportunities,
    required this.threatsl,
  });

  factory Asis.fromDocument(DocumentSnapshot doc) {
    return Asis(
      strengths: doc['strengths'].toString(),
      weaknesses: doc['weaknesses'].toString(),
      opportunities: doc['opportunities'].toString(),
      threatsl: doc['threatsl'].toString(),
    );
  }
}
