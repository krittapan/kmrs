// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmrs/app/app.dart';
import 'package:kmrs/edit_report/edit_report_form.dart';
import 'package:kmrs/footer/footer.dart';
import 'package:kmrs/model/userData.dart';
import 'package:kmrs/report/report_form.dart';

class UserDashboard extends StatefulWidget {
  UserData userData;
  UserDashboard({Key? key, required this.userData}) : super(key: key);

  @override
  _UserDashboardState createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  late Widget _iframeWidget;
  final IFrameElement _iframeElement = IFrameElement();
  late String isReport = '';
  String reportId = '';

  Future getDocstatus() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('reports')
        .where('owner', isEqualTo: widget.userData.uid)
        .where('year', isEqualTo: '1/2565')
        .get();
    snapshot.docs.forEach(
      (DocumentSnapshot doc) {
        print(doc['status']);
        print(doc.id);
        print(doc.exists);
        setState(() {
          isReport = doc['status'].toString();
          reportId = doc.id;
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _iframeElement.height = '600';
    _iframeElement.width = '800';

    _iframeElement.src =
        'https://datastudio.google.com/embed/reporting/873b3f9a-cbf7-4334-aec5-4ac2684ccee7/page/TghnC';
    _iframeElement.style.border = 'none';

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'iframeElement',
      (int viewId) => _iframeElement,
    );

    _iframeWidget = HtmlElementView(
      key: UniqueKey(),
      viewType: 'iframeElement',
    );
    getDocstatus();
  }

  @override
  Widget build(BuildContext context) {
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
              Card(
                margin: const EdgeInsets.all(20),
                elevation: 4,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Center(
                  child: SizedBox(
                    height: 600,
                    width: 800,
                    child: _iframeWidget,
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextLabel(label: 'รายงานล่าสุด'),
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
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'ปี 2565',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
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
                                      child: isReport == ''
                                          ? const Text('ยังไม่ส่งรายงานแผน')
                                          : Text(isReport),
                                    ),
                                  )
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
                                ButtonPlanReport(
                                  widget: widget,
                                  isReport: isReport,
                                ),
                                ButtonReport(
                                  widget: widget,
                                  isReport: isReport,
                                ),
                                ButtonEditPlanReport(
                                  widget: widget,
                                  isReport: isReport,
                                  reportId: reportId,
                                ),
                                ButtonEditReport(
                                  widget: widget,
                                  isReport: isReport,
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

class ButtonPlanReport extends StatelessWidget {
  ButtonPlanReport({
    Key? key,
    required this.widget,
    required this.isReport,
  }) : super(key: key);
  final UserDashboard widget;
  String isReport = '';

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: isReport == ''
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
                  'รายงานแผนประจำปี',
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
                  'รายงานแผนประจำปี',
                ),
              ),
      ),
    );
  }
}

class ButtonReport extends StatelessWidget {
  ButtonReport({
    Key? key,
    required this.widget,
    required this.isReport,
  }) : super(key: key);
  final UserDashboard widget;
  String isReport = '';

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: isReport == 'ตรวจสอบรายงานแผนแล้ว'
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
                  'รายงานผลประจำปี',
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
                  'รายงานผลประจำปี',
                ),
              ),
      ),
    );
  }
}

class ButtonEditPlanReport extends StatelessWidget {
  ButtonEditPlanReport({
    Key? key,
    required this.widget,
    required this.isReport,
    required this.reportId,
  }) : super(key: key);
  final UserDashboard widget;
  String isReport = '';
  String reportId = '';

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: isReport != ''
            ? ElevatedButton.icon(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xffd9dedf))),
                onPressed: () => Navigator.push<AppBloc>(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => EditReportForm(
                        userData: widget.userData, reportId: reportId),
                  ),
                ),
                icon: const Icon(
                  Icons.edit_outlined,
                  color: Colors.black,
                ),
                label: const Text(
                  'แก้ไขรายงานแผนประจำปี',
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
                  'แก้ไขรายงานแผนประจำปี',
                ),
              ),
      ),
    );
  }
}

class ButtonEditReport extends StatelessWidget {
  ButtonEditReport({
    Key? key,
    required this.widget,
    required this.isReport,
  }) : super(key: key);
  final UserDashboard widget;
  String isReport = '';

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: isReport == 'ส่งรายงานผลแล้ว'
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
                  'แก้ไขรายงานผลประจำปี',
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
                  'แก้ไขรายงานผลประจำปี',
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
