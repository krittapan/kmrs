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
  int isReport = 0;
  int isReport1 = 0;
  int isReport2 = 0;
  String currentCycle = '1';
  String currentYear = '2565';
  String reportId = '';

  Future getDocstatus() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('reports')
        .where('owner', isEqualTo: widget.userData.uid)
        .where('year', isEqualTo: currentYear)
        //.where('cycle', isEqualTo: '1')
        .get();
    snapshot.docs.forEach(
      (DocumentSnapshot doc) {
        setState(() {
          if (doc['cycle'].toString() == currentCycle) {
            reportId = doc.id;
            switch (doc['cycle'].toString()) {
              case '1':
                isReport = doc['status'] as int;
                break;
              case '2':
                isReport1 = doc['status'] as int;
                break;
              case '3':
                isReport2 = doc['status'] as int;
                break;
              default:
            }
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

  String statusToString(int status) {
    switch (status) {
      case 1:
        return '????????????????????????????????????';
      case 2:
        return '???????????????????????????';
      case 3:
        return '??????????????????????????????????????????????????????????????????';
      case 4:
        return '??????????????????????????????????????? ??????????????????????????????????????????????????????';
      case 5:
        return '??????????????????????????????????????? ????????????????????????????????????';
      default:
        return '????????????????????????????????????';
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
              label: const Text('??????????????????????????????',
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
                        TextLabel(label: '?????????????????????????????????????????????????????? $currentYear '),
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
                                        '???????????????????????????',
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
                                          child: isReport == 0
                                              ? const Text('?????????????????????????????????????????????')
                                              : Text(statusToString(isReport)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        '???????????????????????? 6 ???????????????',
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
                                              ? const Text('?????????????????????????????????????????????')
                                              : Text(statusToString(isReport1)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        '???????????????????????? 12 ???????????????',
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
                                              ? const Text('?????????????????????????????????????????????')
                                              : Text(statusToString(isReport2)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        TextLabel(label: '??????????????????????????????????????? - ?????????????????????????????????'),
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
                              child: Text('?????????????????????????????????'),
                            ),
                          ),
                        ),
                        TextLabel(label: '??????????????????????????????????????? - ???????????????????????????????????????'),
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
                              child: Text('?????????????????????????????????'),
                            ),
                          ),
                        ),
                        TextLabel(label: '???????????????????????????????????????????????????????????? ?'),
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
                                    '?????????????????????????????????????????????????????? ??????????????????????????????????????????????????? ??????????????????????????????????????????????????????????????????'),
                                Text('????????? 02-942-8445-9'),
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
                        TextLabel(label: '??????????????????'),
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
                                  isReport: isReport,
                                ),
                                ButtonEditReportCycle1(
                                  widget: widget,
                                  isReport: isReport,
                                  reportId: reportId,
                                ),
                                ButtonReportCycle2(
                                  widget: widget,
                                  isReport: isReport,
                                  currentCycle: currentCycle,
                                ),
                                ButtonEditReportCycle2(
                                  widget: widget,
                                  isReport1: isReport1,
                                ),
                                ButtonReportCycle3(
                                  widget: widget,
                                  isReport: isReport2,
                                ),
                                ButtonEditReportCycle3(
                                  widget: widget,
                                  isReport: isReport2,
                                )
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
  ButtonReportCycle1({
    Key? key,
    required this.widget,
    required this.isReport,
  }) : super(key: key);
  final UserDashboard widget;
  int isReport;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: isReport == 1
            ? ElevatedButton.icon(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xffd9dedf))),
                onPressed: () => Navigator.push<AppBloc>(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => ReportForm(
                      userData: widget.userData,
                    ),
                  ),
                ),
                icon: const Icon(
                  Icons.description_outlined,
                  color: Colors.black,
                ),
                label: const Text(
                  '???????????????????????????',
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
                  '???????????????????????????',
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
    required this.isReport,
    required this.currentCycle,
  }) : super(key: key);
  final UserDashboard widget;
  String currentCycle;
  int isReport;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: (isReport >= 2) && (currentCycle == '2')
            ? ElevatedButton.icon(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xffd9dedf))),
                onPressed: () => Navigator.push<AppBloc>(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => ReportForm(
                      userData: widget.userData,
                    ),
                  ),
                ),
                icon: const Icon(
                  Icons.description_outlined,
                  color: Colors.black,
                ),
                label: const Text(
                  '????????????????????????????????? 6 ???????????????',
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
                  '????????????????????????????????? 6 ???????????????',
                ),
              ),
      ),
    );
  }
}

class ButtonReportCycle3 extends StatelessWidget {
  ButtonReportCycle3({
    Key? key,
    required this.widget,
    required this.isReport,
  }) : super(key: key);
  final UserDashboard widget;
  int isReport;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: isReport == 3
            ? ElevatedButton.icon(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xffd9dedf))),
                onPressed: () => Navigator.push<AppBloc>(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => ReportForm(
                      userData: widget.userData,
                    ),
                  ),
                ),
                icon: const Icon(
                  Icons.description_outlined,
                  color: Colors.black,
                ),
                label: const Text(
                  '????????????????????????????????? 12 ???????????????',
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
                  '????????????????????????????????? 12 ???????????????',
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
    required this.isReport,
    required this.reportId,
  }) : super(key: key);
  final UserDashboard widget;
  int isReport;
  String reportId;

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
        child: widget.isReport != ''
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
                  '??????????????????????????????????????????',
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
                  '??????????????????????????????????????????',
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
    required this.isReport1,
  }) : super(key: key);
  final UserDashboard widget;
  int isReport1;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: isReport1 >= 2
            ? ElevatedButton.icon(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xffd9dedf))),
                onPressed: () => Navigator.push<AppBloc>(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => ReportForm(
                      userData: widget.userData,
                    ),
                  ),
                ),
                icon: const Icon(
                  Icons.edit_outlined,
                  color: Colors.black,
                ),
                label: const Text(
                  '??????????????????????????????????????? 6 ???????????????',
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
                  '??????????????????????????????????????? 6 ???????????????',
                ),
              ),
      ),
    );
  }
}

class ButtonEditReportCycle3 extends StatelessWidget {
  ButtonEditReportCycle3({
    Key? key,
    required this.widget,
    required this.isReport,
  }) : super(key: key);
  final UserDashboard widget;
  int isReport;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: isReport == '?????????????????????????????????????????????'
            ? ElevatedButton.icon(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xffd9dedf))),
                onPressed: () => Navigator.push<AppBloc>(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => ReportForm(
                      userData: widget.userData,
                    ),
                  ),
                ),
                icon: const Icon(
                  Icons.edit_outlined,
                  color: Colors.black,
                ),
                label: const Text(
                  '??????????????????????????????????????? 12 ???????????????',
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
                  '??????????????????????????????????????? 12 ???????????????',
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
