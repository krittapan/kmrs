import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class OrganizationName extends StatefulWidget {
  String organizationName;
  OrganizationName({Key? key, required this.organizationName})
      : super(key: key);

  @override
  State<OrganizationName> createState() => _OrganizationNameState();
}

class _OrganizationNameState extends State<OrganizationName> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(20),
      elevation: 4,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.all(20),
        child: Row(
          children: [
            const Text(
              '1.ส่วนงาน',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 300,
              child: Text(
                widget.organizationName,
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
