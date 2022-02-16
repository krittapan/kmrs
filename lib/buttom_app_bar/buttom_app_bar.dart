import 'package:flutter/material.dart';

class ButtomAppBar extends StatelessWidget {
  const ButtomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 100,
          color: const Color.fromRGBO(239, 242, 243, 1),
        ),
        Container(
          width: double.infinity,
          height: 100,
          padding: const EdgeInsets.only(left: 13),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
              Text(
                'งานพัฒนาและฝึกอบรม กองการเจ้าหน้าที่มหาวิทยาลัยเกษตรศาสตร์',
                style: TextStyle(
                  color: Color.fromRGBO(31, 34, 33, 1),
                  fontSize: 14,
                ),
                textAlign: TextAlign.left,
              ),
              Text(
                'โทรศัพท์ 02-9428162',
                style: TextStyle(
                  color: Color.fromRGBO(31, 34, 33, 1),
                  fontSize: 14,
                ),
              ),
              Text(
                'Email : hr.psd@ku.th',
                style: TextStyle(
                  color: Color.fromRGBO(31, 34, 33, 1),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
