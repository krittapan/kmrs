import 'dart:html';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmrs/app/app.dart';
import 'package:kmrs/chack_report/chack_report_form.dart';
import 'package:kmrs/footer/footer.dart';
import 'package:kmrs/keyword/keyword_setting.dart';
import 'package:kmrs/model/userData.dart';
import 'package:kmrs/search/search_tast.dart';

class AdminDashboard extends StatefulWidget {
  UserData userData;
  AdminDashboard({Key? key, required this.userData}) : super(key: key);

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final Stream<QuerySnapshot> _reportStream =
      FirebaseFirestore.instance.collection('reports').snapshots();
  late Widget _iframeWidget;
  final IFrameElement _iframeElement = IFrameElement();

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffeff5f5),
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Image.asset(
            'ku_logo.png',
            color: Colors.white,
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(widget.userData.segmentNameTH),
          ],
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        backgroundColor: const Color(0xff006664),
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
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
                  child: Container(
                    margin: const EdgeInsets.all(30),
                    child: Center(
                      child: SizedBox(
                        height: 600,
                        width: 800,
                        child: _iframeWidget,
                      ),
                    ),
                  ),
                ),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                elevation: 4,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.all(30),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'ประจำปี',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 10),
                            Text('1/2565'),
                          ],
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Card(
                            elevation: 4,
                            margin: const EdgeInsets.all(10),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  height: 30,
                                  color: Colors.black,
                                  child: Row(
                                    children: [
                                      const Expanded(
                                        flex: 8,
                                        child: Text(
                                          'ขื่อส่วนงาน',
                                          style: TextStyle(color: Colors.white),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      const Expanded(
                                        flex: 2,
                                        child: Text(
                                          'สถานะ',
                                          style: TextStyle(color: Colors.white),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Container(),
                                      ),
                                    ],
                                  ),
                                ),
                                StreamBuilder<QuerySnapshot>(
                                  stream: _reportStream,
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasError) {
                                      return const Text('Something went wrong');
                                    }

                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Text('Loading');
                                    }

                                    return ListView(
                                      shrinkWrap: true,
                                      children: snapshot.data!.docs
                                          .map((DocumentSnapshot document) {
                                        Map<String, dynamic> data = document
                                            .data()! as Map<String, dynamic>;
                                        return SizedBox(
                                          height: 30,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 8,
                                                child: Text(
                                                  data['segmentNameTH']
                                                      .toString(),
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  data['status'].toString(),
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: TextButton(
                                                  style: ButtonStyle(
                                                    foregroundColor:
                                                        MaterialStateProperty
                                                            .all<Color>(
                                                                Colors.blue),
                                                  ),
                                                  onPressed: () =>
                                                      Navigator.push<AppBloc>(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          ChackReportForm(
                                                        userData:
                                                            widget.userData,
                                                        reportId: document.id,
                                                      ),
                                                    ),
                                                  ),
                                                  child: const Text('ตรวจสอบ'),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white)),
                          onPressed: () => Navigator.push<AppBloc>(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const SearchTast(),
                            ),
                          ),
                          icon: const Icon(
                            Icons.search,
                            color: Colors.black,
                          ),
                          label: const Text('ทดสอบระบบค้นหา คำ',
                              style: TextStyle(color: Colors.black)),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white)),
                          onPressed: () => Navigator.push<AppBloc>(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const SettingKeyword(),
                            ),
                          ),
                          icon: const Icon(
                            Icons.keyboard_control,
                            color: Colors.black,
                          ),
                          label: const Text('จัดการ คีย์เวิร์ด',
                              style: TextStyle(color: Colors.black)),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: const Footer(),
    );
  }
}
