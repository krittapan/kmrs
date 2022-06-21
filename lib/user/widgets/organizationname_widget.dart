import 'package:flutter/material.dart';

class OrganizationNameCard extends StatelessWidget {
  const OrganizationNameCard({
    Key? key,
    required this.organizationName,
  }) : super(key: key);

  final String organizationName;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 4,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(30),
          child: Row(
            children: [
              const Text('หน่วยงาน :'),
              const SizedBox(width: 20),
              Text(organizationName),
            ],
          ),
        ),
      ),
    );
  }
}
