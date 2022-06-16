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
  bool? targetCheck;
  String? obligationsCheck;
  bool? objectiveCheck;
  bool? outputCheck;
  bool? successMetricsCheck;
  bool? knowledgeManagementActivitiesCheck;
  bool? periodOperatedCheck;

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
    data['objectiveCheck'] = this.objectiveCheck;
    data['outputCheck'] = this.outputCheck;
    data['successMetricsCheck'] = this.successMetricsCheck;
    data['knowledgeManagementActivitiesCheck'] =
        this.knowledgeManagementActivitiesCheck;
    data['periodOperatedCheck'] = this.periodOperatedCheck;
    return data;
  }

  ApKuqs.fromMap(Map<dynamic, dynamic> map)
      : target = map['target'].toString(),
        obligations = map['obligations'].toString(),
        objective = map['objective'].toString(),
        output = map['output'].toString(),
        success_metrics = map['success_metrics'].toString(),
        knowledgeManagementActivities =
            map['knowledgeManagementActivities'].toString(),
        periodOperated = map['periodOperated'].toString(),
        budget = map['budget'].toString(),
        responsiblePerson = map['responsiblePerson'].toString(),
        targetCheck = map['targetCheck'] as bool,
        objectiveCheck = map['objectiveCheck'] as bool,
        obligationsCheck = map['obligationsCheck'].toString(),
        outputCheck = map['outputCheck'] as bool,
        successMetricsCheck = map['successMetricsCheck'] as bool,
        knowledgeManagementActivitiesCheck =
            map['knowledgeManagementActivitiesCheck'] as bool,
        periodOperatedCheck = map['periodOperatedCheck'] as bool;
}
