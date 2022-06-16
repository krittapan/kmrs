import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Asis {
  late final String strengths;
  late final String weaknesses;
  late final String opportunities;
  late final String threatsl;
  bool? strengthsCheck;
  bool? weaknessesCheck;
  bool? opportunitiesCheck;
  bool? threatslCheck;

  Asis({
    required this.strengths,
    required this.weaknesses,
    required this.opportunities,
    required this.threatsl,
    this.strengthsCheck,
    this.weaknessesCheck,
    this.opportunitiesCheck,
    this.threatslCheck,
  });

  factory Asis.fromDocument(DocumentSnapshot doc) {
    return Asis(
      strengths: doc['strengths'].toString(),
      weaknesses: doc['weaknesses'].toString(),
      opportunities: doc['opportunities'].toString(),
      threatsl: doc['threatsl'].toString(),
      strengthsCheck: doc['strengthsCheck'] as bool,
      weaknessesCheck: doc['weaknesses'] as bool,
      opportunitiesCheck: doc['opportunitiesCheck'] as bool,
      threatslCheck: doc['threatslCheck'] as bool,
    );
  }
  factory Asis.fromJson(Map<String, dynamic> json) {
    List<String> contents = json['content']['rendered'].toString().split('"');

    return Asis(
      strengths: json['strengths'].toString(),
      weaknesses: json['weaknesses'].toString(),
      opportunities: json['opportunities'].toString(),
      threatsl: json['threatsl'].toString(),
      strengthsCheck: json['strengthsCheck'] as bool,
      weaknessesCheck: json['weaknessesCheck'] as bool,
      opportunitiesCheck: json['opportunitiesCheck'] as bool,
      threatslCheck: json['threatslCheck'] as bool,
    );
  }

  Asis.fromMap(Map<dynamic, dynamic> map)
      : strengths = map['strengths'].toString(),
        weaknesses = map['weaknesses'].toString(),
        opportunities = map['opportunities'].toString(),
        threatsl = map['threatsl'].toString(),
        strengthsCheck = map['strengthsCheck'] as bool,
        weaknessesCheck = map['weaknessesCheck'] as bool,
        opportunitiesCheck = map['opportunitiesCheck'] as bool,
        threatslCheck = map['threatslCheck'] as bool;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['strengths'] = this.strengths;
    data['weaknesses'] = this.weaknesses;
    data['opportunities'] = this.opportunities;
    data['threatsl'] = this.threatsl;
    data['strengthsCheck'] = this.strengthsCheck;
    data['weaknessesCheck'] = this.weaknessesCheck;
    data['opportunitiesCheck'] = this.opportunitiesCheck;
    data['threatslCheck'] = this.threatslCheck;
    return data;
  }

  Asis copyWith({
    String? strengths,
    String? weaknesses,
    String? opportunities,
    String? threatsl,
    bool? strengthsCheck,
    bool? weaknessesCheck,
    bool? opportunitiesCheck,
  }) {
    return Asis(
      strengths: strengths ?? this.strengths,
      weaknesses: weaknesses ?? this.weaknesses,
      opportunities: opportunities ?? this.opportunities,
      threatsl: threatsl ?? this.threatsl,
      strengthsCheck: strengthsCheck ?? this.strengthsCheck,
      weaknessesCheck: weaknessesCheck ?? this.weaknessesCheck,
      opportunitiesCheck: opportunitiesCheck ?? this.opportunitiesCheck,
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
