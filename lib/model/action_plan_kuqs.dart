import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ApKuqs {
  late final String target;
  late final String obligations;
  late final String objective;
  late final String output;
  late final String success_metrics;
  late final String knowledgeManagementActivities;
  late final String periodOperated;
  late final String budget;
  late final String responsiblePerson;
  bool? targetCheck = false;
  late String? obligationsCheck;
  bool? objectiveCheck = false;
  bool? outputCheck = false;
  bool? successMetricsCheck = false;
  bool? knowledgeManagementActivitiesCheck = false;
  bool? periodOperatedCheck = false;

  ApKuqs({
    required this.target,
    required this.obligations,
    required this.objective,
    required this.output,
    required this.success_metrics,
    required this.knowledgeManagementActivities,
    required this.periodOperated,
    required this.budget,
    required this.responsiblePerson,
    this.targetCheck,
    this.obligationsCheck,
    this.objectiveCheck,
    this.outputCheck,
    this.successMetricsCheck,
    this.knowledgeManagementActivitiesCheck,
    this.periodOperatedCheck,
  });

  factory ApKuqs.fromDocument(DocumentSnapshot doc) {
    return ApKuqs(
      target: doc['target'].toString(),
      obligations: doc['obligations'].toString(),
      objective: doc['objective'].toString(),
      output: doc['output'].toString(),
      success_metrics: doc['success_metrics'].toString(),
      knowledgeManagementActivities:
          doc['knowledgeManagementActivities'].toString(),
      periodOperated: doc['periodOperated'].toString(),
      budget: doc['budget'].toString(),
      responsiblePerson: doc['responsiblePerson'].toString(),
      targetCheck: doc['targetCheck'] as bool,
      obligationsCheck: doc['obligationsCheck'].toString(),
      objectiveCheck: doc['obligationsCheck'] as bool,
      outputCheck: doc['outputChack'] as bool,
      successMetricsCheck: doc['successMetricsCheck'] as bool,
      knowledgeManagementActivitiesCheck:
          doc['knowledgeManagementActivitiesCheck'] as bool,
      periodOperatedCheck: doc['periodOperatedCheck'] as bool,
    );
  }

  @override
  String toString() {
    return 'ApKuqs(target: $target, obligations: $obligations, objective: $objective, output: $output, success_metrics: $success_metrics, knowledgeManagementActivities: $knowledgeManagementActivities, periodOperated: $periodOperated, budget: $budget, responsiblePerson: $responsiblePerson, targetCheck: $targetCheck, obligationsCheck: $obligationsCheck, objectiveCheck: $objectiveCheck, outputCheck: $outputCheck, successMetricsCheck: $successMetricsCheck, knowledgeManagementActivitiesCheck: $knowledgeManagementActivitiesCheck, periodOperatedCheck: $periodOperatedCheck)';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['target'] = this.target;
    data['obligations'] = this.obligations;
    data['objective'] = this.objective;
    data['output'] = this.output;
    data['success_metrics'] = this.success_metrics;
    data['knowledgeManagementActivities'] = this.knowledgeManagementActivities;
    data['budget'] = this.budget;
    data['responsible_person'] = this.responsiblePerson;
    data['targetCheck'] = this.targetCheck;
    data['obligationsCheck'] = this.obligationsCheck;
    //data['obligationsCheck'] = "ไม่ตรงตามยุทธศาสตร์ ";
    data['objectiveCheck'] = this.objectiveCheck;
    data['outputCheck'] = this.outputCheck;
    data['successMetricsCheck'] = this.successMetricsCheck;
    data['knowledgeManagementActivitiesCheck'] =
        this.knowledgeManagementActivitiesCheck;
    data['periodOperatedCheck'] = this.periodOperatedCheck;
    return data;
  }

  ApKuqs copyWith({
    String? target,
    String? obligations,
    String? objective,
    String? output,
    String? success_metrics,
    String? knowledgeManagementActivities,
    String? periodOperated,
    String? budget,
    String? responsiblePerson,
    bool? targetCheck,
    String? obligationsCheck,
    bool? objectiveCheck,
    bool? outputCheck,
    bool? successMetricsCheck,
    bool? knowledgeManagementActivitiesCheck,
    bool? periodOperatedCheck,
  }) {
    return ApKuqs(
      target: target ?? this.target,
      obligations: obligations ?? this.obligations,
      objective: objective ?? this.objective,
      output: output ?? this.output,
      success_metrics: success_metrics ?? this.success_metrics,
      knowledgeManagementActivities:
          knowledgeManagementActivities ?? this.knowledgeManagementActivities,
      periodOperated: periodOperated ?? this.periodOperated,
      budget: budget ?? this.budget,
      responsiblePerson: responsiblePerson ?? this.responsiblePerson,
      targetCheck: targetCheck ?? this.targetCheck,
      obligationsCheck: obligationsCheck ?? this.obligationsCheck,
      objectiveCheck: objectiveCheck ?? this.objectiveCheck,
      outputCheck: outputCheck ?? this.outputCheck,
      successMetricsCheck: successMetricsCheck ?? this.successMetricsCheck,
      knowledgeManagementActivitiesCheck: knowledgeManagementActivitiesCheck ??
          this.knowledgeManagementActivitiesCheck,
      periodOperatedCheck: periodOperatedCheck ?? this.periodOperatedCheck,
    );
  }

  factory ApKuqs.fromMap(Map<String, dynamic> map) {
    return ApKuqs(
      target: map['target'].toString(),
      obligations: map['obligations'].toString(),
      objective: map['objective'].toString(),
      output: map['output'].toString(),
      success_metrics: map['success_metrics'].toString(),
      knowledgeManagementActivities:
          map['knowledgeManagementActivities'].toString(),
      periodOperated: map['periodOperated'].toString(),
      budget: map['budget'].toString(),
      responsiblePerson: map['responsiblePerson'].toString(),
      targetCheck: map['targetCheck'] as bool,
      obligationsCheck: map['obligationsCheck'].toString(),
      objectiveCheck: map['objectiveCheck'] as bool,
      outputCheck: map['outputCheck'] as bool,
      successMetricsCheck: map['successMetricsCheck'] as bool,
      knowledgeManagementActivitiesCheck:
          map['knowledgeManagementActivitiesCheck'] as bool,
      periodOperatedCheck: map['periodOperatedCheck'] as bool,
    );
  }

  factory ApKuqs.fromJson(Map<String, dynamic> json) {
    List<String> contents = json['content']['rendered'].toString().split('"');
    return ApKuqs(
      target: json['target'].toString(),
      obligations: json['obligations'].toString(),
      objective: json['objective'].toString(),
      output: json['output'].toString(),
      success_metrics: json['success_metrics'].toString(),
      knowledgeManagementActivities:
          json['knowledgeManagementActivities'].toString(),
      periodOperated: json['periodOperated'].toString(),
      budget: json['budget'].toString(),
      responsiblePerson: json['responsiblePerson'].toString(),
      targetCheck: json['targetCheck'] as bool,
      obligationsCheck: json['obligationsCheck'].toString(),
      objectiveCheck: json['objectiveCheck'] as bool,
      outputCheck: json['outputCheck'] as bool,
      successMetricsCheck: json['successMetricsCheck'] as bool,
      knowledgeManagementActivitiesCheck:
          json['knowledgeManagementActivitiesCheck'] as bool,
      periodOperatedCheck: json['periodOperatedCheck'] as bool,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ApKuqs &&
        other.target == target &&
        other.obligations == obligations &&
        other.objective == objective &&
        other.output == output &&
        other.success_metrics == success_metrics &&
        other.knowledgeManagementActivities == knowledgeManagementActivities &&
        other.periodOperated == periodOperated &&
        other.budget == budget &&
        other.responsiblePerson == responsiblePerson &&
        other.targetCheck == targetCheck &&
        other.obligationsCheck == obligationsCheck &&
        other.objectiveCheck == objectiveCheck &&
        other.outputCheck == outputCheck &&
        other.successMetricsCheck == successMetricsCheck &&
        other.knowledgeManagementActivitiesCheck ==
            knowledgeManagementActivitiesCheck &&
        other.periodOperatedCheck == periodOperatedCheck;
  }

  @override
  int get hashCode {
    return target.hashCode ^
        obligations.hashCode ^
        objective.hashCode ^
        output.hashCode ^
        success_metrics.hashCode ^
        knowledgeManagementActivities.hashCode ^
        periodOperated.hashCode ^
        budget.hashCode ^
        responsiblePerson.hashCode ^
        targetCheck.hashCode ^
        obligationsCheck.hashCode ^
        objectiveCheck.hashCode ^
        outputCheck.hashCode ^
        successMetricsCheck.hashCode ^
        knowledgeManagementActivitiesCheck.hashCode ^
        periodOperatedCheck.hashCode;
  }
}
