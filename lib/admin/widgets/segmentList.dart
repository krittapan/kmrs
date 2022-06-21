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
  String year;
  String cycle;
  SegmentList(
      {Key? key,
      required this.userData,
      required this.year,
      required this.cycle})
      : super(key: key);

  @override
  State<SegmentList> createState() => _SegmentListState();
}

class _SegmentListState extends State<SegmentList> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _reportStream = FirebaseFirestore.instance
        .collection('reports')
        .where('year', isEqualTo: widget.year)
        .where('cycle', isEqualTo: widget.cycle)
        .snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: _reportStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data!.docs.length == 0) {
          return const Center(
            child: Text('ไม่พบข้อมูล'),
          );
        } else {
          return ListView(
            shrinkWrap: true,
            children: snapshot.data!.docs
                .asMap()
                .map(
                  (index, DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    return MapEntry(
                      index,
                      SizedBox(
                        height: 30,
                        child: InkWell(
                          // splashColor: Colors.blue, // or the color you want
                          onLongPress: () {
                            //show your on long press event
                          },
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
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Text(
                                  data['segmentNameTH'].toString(),
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  data['status'].toString(),
                                  style: const TextStyle(color: Colors.black),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: TextButton(
                                  style: ButtonStyle(
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.blue),
                                  ),
                                  onPressed: () => Navigator.push<AppBloc>(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
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
                      ),
                    );
                  },
                )
                .values
                .toList(),
          );
        }
      },
    );
  }
}
