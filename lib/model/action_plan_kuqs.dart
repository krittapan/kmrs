import 'package:cloud_firestore/cloud_firestore.dart';

class ApKuqs {
  late final String target;
  late final String obligations;
  late final String objective;
  late final String output;
  late final String successMetrics;
  late final String knowledgeManagementActivities;
  late final String periodOperated;
  late final String budget;
  late final String responsiblePerson;

  ApKuqs({
    required this.target,
    required this.obligations,
    required this.objective,
    required this.output,
    required this.successMetrics,
    required this.knowledgeManagementActivities,
    required this.periodOperated,
    required this.budget,
    required this.responsiblePerson,
  });

  factory ApKuqs.fromDocument(DocumentSnapshot doc) {
    return ApKuqs(
      target: doc['target'].toString(),
      obligations: doc['obligations'].toString(),
      objective: doc['objective'].toString(),
      output: doc['output'].toString(),
      successMetrics: doc['successMetrics'].toString(),
      knowledgeManagementActivities:
          doc['knowledgeManagementActivities'].toString(),
      periodOperated: doc['periodOperated'].toString(),
      budget: doc['budget'].toString(),
      responsiblePerson: doc['responsiblePerson'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['target'] = this.target;
    data['obligations'] = this.obligations;
    data['objective'] = this.objective;
    data['output'] = this.output;
    data['success_metrics'] = this.successMetrics;
    data['knowledgeManagementActivities'] = this.knowledgeManagementActivities;
    data['budget'] = this.budget;
    data['responsible_person'] = this.responsiblePerson;
    return data;
  }

  ApKuqs.fromMap(Map<dynamic, dynamic> map)
      : target = map['target'].toString(),
        obligations = map['obligations'].toString(),
        objective = map['objective'].toString(),
        output = map['output'].toString(),
        successMetrics = map['successMetrics'].toString(),
        knowledgeManagementActivities =
            map['knowledgeManagementActivities'].toString(),
        periodOperated = map['periodOperated'].toString(),
        budget = map['budget'].toString(),
        responsiblePerson = map['responsiblePerson'].toString();
}
