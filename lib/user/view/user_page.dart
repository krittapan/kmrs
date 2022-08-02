// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmrs/app/app.dart';
import 'package:kmrs/edit_report/edit_report.dart';
import 'package:kmrs/footer/footer.dart';
import 'package:kmrs/model/userData.dart';
import 'package:kmrs/report/report_form.dart';
import 'package:kmrs/user/user.dart';

class UserDashboard extends StatefulWidget {
  UserData userData;

  UserDashboard({Key? key, required this.userData}) : super(key: key);

  @override
  _UserDashboardState createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  int isReport1 = 0;
  int isReport2 = 0;
  int isReport3 = 0;
  String currentCycle = '1';
  String currentYear = '2565';
  String reportId1 = '';
  String reportId2 = '';
  String reportId3 = '';

  Future getDocstatus() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('reports')
        .where('owner', isEqualTo: widget.userData.uid)
        .where('year', isEqualTo: currentYear)
        // .where('cycle', isEqualTo: currentYear)
        .get();

    snapshot.docs.forEach(
      (DocumentSnapshot doc) {
        setState(() {
          switch (doc['cycle'].toString()) {
            case '1':
              isReport1 = int.parse(doc['status'].toString());
              reportId1 = doc.id;
              print("Cycle 1 >> Status =======>   ${isReport1}");
              break;
            case '2':
              isReport2 = int.parse(doc['status'].toString());
              reportId2 = doc.id;
              print("Cycle 2 >> Status =======>   ${isReport2}");
              break;
            case '3':
              isReport3 = int.parse(doc['status'].toString());
              reportId3 = doc.id;
              print("Cycle 3 >> Status =======>   ${isReport3}");
              break;
            default:
          }
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getDocstatus();
  }

  void setPageTitle(String title, BuildContext context) {
    SystemChrome.setApplicationSwitcherDescription(
        ApplicationSwitcherDescription(
      label: title,
      primaryColor:
          Theme.of(context).primaryColor.value, // This line is required
    ));
  }

  String statusToString(dynamic status) {
    switch (status) {
      case 0:
        return 'ไม่ส่งรายงาน';
      case 1:
        return 'ส่งรายงาน';
      case 2:
        return 'ดำเนินการตรวจสอบรายงาน';
      case 3:
        return 'ตรวจสอบรายงาน มีหมายเหตุปรับปรุง';
      case 4:
        return 'ตรวจสอบรายงาน เสร็จสมบรูณ์';
      default:
        return 'ไม่ทราบสถานะ';
    }
  }

  @override
  Widget build(BuildContext context) {
    setPageTitle(widget.userData.segmentNameTH, context);
    return Scaffold(
      backgroundColor: const Color(0xffeff5f5),
      appBar: AppBar(
        backgroundColor: const Color(0xff006664),
        leading: Padding(
          padding: const EdgeInsets.all(5),
          child: Image.asset(
            'ku_logo.png',
            color: Colors.white,
          ),
        ),
        title: Container(
          width: double.infinity,
          child: Text(widget.userData.segmentNameTH,
              overflow: TextOverflow.ellipsis),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(7),
            child: ElevatedButton.icon(
              label: const Text('ออกจากระบบ',
                  style: TextStyle(color: Colors.black)),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white)),
              icon: const Icon(
                Icons.logout_outlined,
                color: Colors.red,
              ),
              onPressed: () async =>
                  context.read<AppBloc>().add(AppLogoutRequested()),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Align(
          alignment: const Alignment(0, -1 / 3),
          child: Column(
            children: <Widget>[
              const DataDashboard(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextLabel(label: 'สถานะรายงานประจำปี $currentYear '),
                        Card(
                          margin: const EdgeInsets.all(20),
                          elevation: 4,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: Container(
                            margin: const EdgeInsets.all(20),
                            child: Center(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'รายงานแผน',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Card(
                                        margin: const EdgeInsets.all(5),
                                        elevation: 4,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5),
                                          ),
                                        ),
                                        child: Container(
                                          margin: const EdgeInsets.all(5),
                                          child: isReport1 == 0
                                              ? const Text('ยังไม่ส่งรายงาน')
                                              : Text(statusToString(isReport1)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'รายงานผล 6 เดือน',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Card(
                                        margin: const EdgeInsets.all(5),
                                        elevation: 4,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5),
                                          ),
                                        ),
                                        child: Container(
                                          margin: const EdgeInsets.all(5),
                                          child: isReport2 == 0
                                              ? const Text('ยังไม่ส่งรายงาน')
                                              : Text(statusToString(isReport2)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'รายงานผล 12 เดือน',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Card(
                                        margin: const EdgeInsets.all(5),
                                        elevation: 4,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5),
                                          ),
                                        ),
                                        child: Container(
                                          margin: const EdgeInsets.all(5),
                                          child: isReport3 == 0
                                              ? const Text('ยังไม่ส่งรายงาน')
                                              : Text(statusToString(isReport3)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        TextLabel(label: 'รายงานประจำปี - ระดับมหาลัย'),
                        Card(
                          margin: const EdgeInsets.all(20),
                          elevation: 4,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: Container(
                            margin: const EdgeInsets.all(20),
                            height: 100,
                            color: Colors.grey[300],
                            child: const Center(
                              child: Text('ไม่พบข้อมูล'),
                            ),
                          ),
                        ),
                        TextLabel(label: 'รายงานประจำปี - ระดับหน่วยงาน'),
                        Card(
                          margin: const EdgeInsets.all(20),
                          elevation: 4,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: Container(
                            margin: const EdgeInsets.all(20),
                            height: 100,
                            color: Colors.grey[300],
                            child: const Center(
                              child: Text('ไม่พบข้อมูล'),
                            ),
                          ),
                        ),
                        TextLabel(label: 'ต้องการความช่วยเหลือ ?'),
                        Card(
                          margin: const EdgeInsets.all(20),
                          elevation: 4,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: Container(
                            margin: const EdgeInsets.all(30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                    'งานพัฒนาและฝึกอบรม กองการเจ้าหน้าที่ มหาวิทยาลัยเกษตรศาสตร์'),
                                Text('โทร 02-942-8445-9'),
                                Text('Email : fgra@ku.ac.th'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextLabel(label: 'รายงาน'),
                        Card(
                          margin: const EdgeInsets.all(20),
                          elevation: 4,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                ButtonReportCycle1(
                                  widget: widget,
                                  isReport1: isReport1,
                                  currentCycle: currentCycle,
                                ),
                                ButtonEditReportCycle1(
                                  widget: widget,
                                  isReport1: isReport1,
                                  reportId: reportId1,
                                  currentCycle: currentCycle,
                                ),
                                ButtonReportCycle2(
                                  widget: widget,
                                  isReport1: isReport1,
                                  isReport2: isReport2,
                                  currentCycle: currentCycle,
                                ),
                                ButtonEditReportCycle2(
                                  widget: widget,
                                  isReport2: isReport2,
                                  isReport3: isReport3,
                                  reportId2: reportId2,
                                  currentCycle: currentCycle,
                                ),
                                ButtonReportCycle3(
                                  widget: widget,
                                  isReport2: isReport2,
                                  isReport3: isReport3,
                                  currentCycle: currentCycle,
                                ),
                                ButtonEditReportCycle3(
                                    widget: widget,
                                    isReport3: isReport3,
                                    reportId3: reportId3)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: const Footer(),
    );
  }
}

class ButtonReportCycle1 extends StatelessWidget {
  ButtonReportCycle1(
      {Key? key,
      required this.widget,
      required this.isReport1,
      required this.currentCycle})
      : super(key: key);
  final UserDashboard widget;
  int isReport1;
  String currentCycle;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: isReport1 == 0 && (currentCycle == '1')
            ? ElevatedButton.icon(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xffd9dedf))),
                onPressed: () => Navigator.push<AppBloc>(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => ReportForm(
                      currentCycle: currentCycle,
                      userData: widget.userData,
                    ),
                  ),
                ),
                icon: const Icon(
                  Icons.description_outlined,
                  color: Colors.black,
                ),
                label: const Text(
                  'รายงานแผน',
                  style: TextStyle(color: Colors.black),
                ),
              )
            : ElevatedButton.icon(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xffd9dedf))),
                onPressed: null,
                icon: const Icon(
                  Icons.description_outlined,
                ),
                label: const Text(
                  'รายงานแผน',
                ),
              ),
      ),
    );
  }
}

class ButtonReportCycle2 extends StatelessWidget {
  ButtonReportCycle2({
    Key? key,
    required this.widget,
    required this.isReport1,
    required this.isReport2,
    required this.currentCycle,
  }) : super(key: key);
  final UserDashboard widget;
  String currentCycle;
  int isReport1;
  int isReport2;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: (isReport1 >= 2 && isReport2 == 0) && (currentCycle == '2')
            ? ElevatedButton.icon(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xffd9dedf))),
                onPressed: () => Navigator.push<AppBloc>(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => ReportForm(
                      currentCycle: currentCycle,
                      userData: widget.userData,
                    ),
                  ),
                ),
                icon: const Icon(
                  Icons.description_outlined,
                  color: Colors.black,
                ),
                label: const Text(
                  'รายงานผลรอบ 6 เดือน',
                  style: TextStyle(color: Colors.black),
                ),
              )
            : ElevatedButton.icon(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xffd9dedf))),
                onPressed: null,
                icon: const Icon(
                  Icons.description_outlined,
                ),
                label: const Text(
                  'รายงานผลรอบ 6 เดือน',
                ),
              ),
      ),
    );
  }
}

class ButtonReportCycle3 extends StatelessWidget {
  ButtonReportCycle3(
      {Key? key,
      required this.widget,
      required this.isReport2,
      required this.isReport3,
      required this.currentCycle})
      : super(key: key);
  final UserDashboard widget;
  int isReport2;
  int isReport3;
  String currentCycle;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: (isReport2 != 0) && (isReport3 == 0) && (currentCycle == '3')
            ? ElevatedButton.icon(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xffd9dedf))),
                onPressed: () => Navigator.push<AppBloc>(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => ReportForm(
                      currentCycle: currentCycle,
                      userData: widget.userData,
                    ),
                  ),
                ),
                icon: const Icon(
                  Icons.description_outlined,
                  color: Colors.black,
                ),
                label: const Text(
                  'รายงานผลรอบ 12 เดือน',
                  style: TextStyle(color: Colors.black),
                ),
              )
            : ElevatedButton.icon(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xffd9dedf))),
                onPressed: null,
                icon: const Icon(
                  Icons.description_outlined,
                ),
                label: const Text(
                  'รายงานผลรอบ 12 เดือน',
                ),
              ),
      ),
    );
  }
}

class ButtonEditReportCycle1 extends StatefulWidget {
  ButtonEditReportCycle1({
    Key? key,
    required this.widget,
    required this.isReport1,
    required this.reportId,
    required this.currentCycle,
  }) : super(key: key);
  final UserDashboard widget;
  int isReport1;
  String reportId;
  String currentCycle;

  @override
  State<ButtonEditReportCycle1> createState() => _ButtonEditReportCycle1State();
}

class _ButtonEditReportCycle1State extends State<ButtonEditReportCycle1> {
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: (widget.isReport1 >= 1) && (int.parse(widget.currentCycle) <= 2)
            ? ElevatedButton.icon(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xffd9dedf))),
                onPressed: () => Navigator.push<AppBloc>(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => EditReportForm(
                        userData: widget.widget.userData,
                        reportId: widget.reportId),
                  ),
                ),
                icon: const Icon(
                  Icons.edit_outlined,
                  color: Colors.black,
                ),
                label: const Text(
                  'แก้ไขรายงานแผน',
                  style: TextStyle(color: Colors.black),
                ),
              )
            : ElevatedButton.icon(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xffd9dedf))),
                onPressed: null,
                icon: const Icon(
                  Icons.edit_outlined,
                ),
                label: const Text(
                  'แก้ไขรายงานแผน',
                ),
              ),
      ),
    );
  }
}

class ButtonEditReportCycle2 extends StatelessWidget {
  ButtonEditReportCycle2({
    Key? key,
    required this.widget,
    required this.isReport2,
    required this.isReport3,
    required this.reportId2,
    required this.currentCycle,
  }) : super(key: key);
  final UserDashboard widget;
  int isReport2;
  int isReport3;
  String reportId2;
  String currentCycle;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: (isReport2 > 0) &&
                (isReport3 == 0) &&
                (int.parse(currentCycle) <= 3)
            ? ElevatedButton.icon(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xffd9dedf))),
                onPressed: () => Navigator.push<AppBloc>(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => EditReportForm(
                        reportId: reportId2, userData: widget.userData),
                  ),
                ),
                icon: const Icon(
                  Icons.edit_outlined,
                  color: Colors.black,
                ),
                label: const Text(
                  'แก้ไขรายงานผล 6 เดือน',
                  style: TextStyle(color: Colors.black),
                ),
              )
            : ElevatedButton.icon(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xffd9dedf))),
                onPressed: null,
                icon: const Icon(
                  Icons.edit_outlined,
                ),
                label: const Text(
                  'แก้ไขรายงานผล 6 เดือน',
                ),
              ),
      ),
    );
  }
}

class ButtonEditReportCycle3 extends StatelessWidget {
  ButtonEditReportCycle3(
      {Key? key,
      required this.widget,
      required this.isReport3,
      required this.reportId3})
      : super(key: key);
  final UserDashboard widget;
  int isReport3;
  String reportId3;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: isReport3 >= 1
            ? ElevatedButton.icon(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xffd9dedf))),
                onPressed: () => Navigator.push<AppBloc>(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => EditReportForm(
                        reportId: reportId3, userData: widget.userData),
                  ),
                ),
                icon: const Icon(
                  Icons.edit_outlined,
                  color: Colors.black,
                ),
                label: const Text(
                  'แก้ไขรายงานผล 12 เดือน',
                  style: TextStyle(color: Colors.black),
                ),
              )
            : ElevatedButton.icon(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xffd9dedf))),
                onPressed: null,
                icon: const Icon(
                  Icons.edit_outlined,
                ),
                label: const Text(
                  'แก้ไขรายงานผล 12 เดือน',
                ),
              ),
      ),
    );
  }
}

class TextLabel extends StatelessWidget {
  String label;
  TextLabel({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      ),
    );
  }
}
