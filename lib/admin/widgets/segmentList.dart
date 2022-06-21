import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:kmrs/app/app.dart';
import 'package:kmrs/chack_report/chack_report.dart';
import 'package:kmrs/keyword/keyword_setting.dart';
import 'package:kmrs/model/userData.dart';
import 'package:kmrs/search/search_tast.dart';

class SegmentList extends StatefulWidget {
  UserData userData;
  SegmentList({Key? key, required this.userData}) : super(key: key);

  @override
  State<SegmentList> createState() => _SegmentListState();
}

class _SegmentListState extends State<SegmentList> {
  final Stream<QuerySnapshot> _reportStream =
      FirebaseFirestore.instance.collection('reports').snapshots();
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
                        color: Colors.black, fontWeight: FontWeight.bold),
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
                              flex: 6,
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
                                .asMap()
                                .map(
                                  (index, DocumentSnapshot document) {
                                    Map<String, dynamic> data = document.data()!
                                        as Map<String, dynamic>;
                                    return MapEntry(
                                      index,
                                      SizedBox(
                                        height: 30,
                                        child: Row(
                                          children: [
                                            const Expanded(
                                              child: SizedBox(
                                                width: 10,
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                (index + 1).toString(),
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 5,
                                              child: Text(
                                                data['segmentNameTH']
                                                    .toString(),
                                                style: const TextStyle(
                                                    color: Colors.black),
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
                                                      MaterialStateProperty.all<
                                                          Color>(Colors.blue),
                                                ),
                                                onPressed: () =>
                                                    Navigator.push<AppBloc>(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        ChackReportForm(
                                                      userData: widget.userData,
                                                      reportId: document.id,
                                                    ),
                                                  ),
                                                ),
                                                child: const Text('ตรวจสอบ'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                )
                                .values
                                .toList(),
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
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white)),
                onPressed: () => Navigator.push<AppBloc>(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const SearchTast(),
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
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white)),
                onPressed: () => Navigator.push<AppBloc>(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const SettingKeyword(),
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
    );
  }
}
