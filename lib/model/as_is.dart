import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Asis {
  late final String strengths;
  late final String weaknesses;
  late final String opportunities;
  late final String threatsl;

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
  factory Asis.fromJson(Map<String, dynamic> json) {
    List<String> contents = json['content']['rendered'].toString().split('"');

    return Asis(
      strengths: json['strengths'].toString(),
      weaknesses: json['weaknesses'].toString(),
      opportunities: json['opportunities'].toString(),
      threatsl: json['threatsl'].toString(),
    );
  }

  Asis.fromMap(Map<dynamic, dynamic> map)
      : strengths = map['strengths'].toString(),
        weaknesses = map['weaknesses'].toString(),
        opportunities = map['opportunities'].toString(),
        threatsl = map['threatsl'].toString();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['strengths'] = this.strengths;
    data['weaknesses'] = this.weaknesses;
    data['opportunities'] = this.opportunities;
    data['threatsl'] = this.threatsl;
    return data;
  }

  Asis copyWith({
    String? strengths,
    String? weaknesses,
    String? opportunities,
    String? threatsl,
  }) {
    return Asis(
      strengths: strengths ?? this.strengths,
      weaknesses: weaknesses ?? this.weaknesses,
      opportunities: opportunities ?? this.opportunities,
      threatsl: threatsl ?? this.threatsl,
    );
  }

  @override
  String toString() {
    return 'Asis(strengths: $strengths, weaknesses: $weaknesses, opportunities: $opportunities, threatsl: $threatsl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Asis &&
        other.strengths == strengths &&
        other.weaknesses == weaknesses &&
        other.opportunities == opportunities &&
        other.threatsl == threatsl;
  }

  @override
  int get hashCode {
    return strengths.hashCode ^
        weaknesses.hashCode ^
        opportunities.hashCode ^
        threatsl.hashCode;
  }
}
