import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class CycleSetting {
  String year;
  String cycle;
  Timestamp startTime;
  Timestamp endTime;
  Timestamp createTime;
  CycleSetting({
    required this.year,
    required this.cycle,
    required this.startTime,
    required this.endTime,
    required this.createTime,
  });

  CycleSetting copyWith({
    String? year,
    String? cycle,
    Timestamp? startTime,
    Timestamp? endTime,
    Timestamp? createTime,
  }) {
    return CycleSetting(
      year: year ?? this.year,
      cycle: cycle ?? this.cycle,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      createTime: createTime ?? this.createTime,
    );
  }

  // Map<String, dynamic> toMap() {
  //   return {
  //     'year': year,
  //     'cycle': cycle,
  //     'startTime': startTime.toMap(),
  //     'endTime': endTime.toMap(),
  //     'createTime': createTime.toMap(),
  //   };
  // }

  factory CycleSetting.fromMap(Map<String, dynamic> map) {
    return CycleSetting(
      year: map['year'].toString(),
      cycle: map['cycle'].toString(),
      startTime: map['startTime'] as Timestamp,
      endTime: map['endTime'] as Timestamp,
      createTime: map['createTime'] as Timestamp,
    );
  }

  // String toJson() => json.encode(toMap());

  // factory CycleSetting.fromJson(String source) =>
  //     CycleSetting.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CycleSetting(year: $year, cycle: $cycle, startTime: $startTime, endTime: $endTime, createTime: $createTime)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CycleSetting &&
        other.year == year &&
        other.cycle == cycle &&
        other.startTime == startTime &&
        other.endTime == endTime &&
        other.createTime == createTime;
  }

  @override
  int get hashCode {
    return year.hashCode ^
        cycle.hashCode ^
        startTime.hashCode ^
        endTime.hashCode ^
        createTime.hashCode;
  }
}
