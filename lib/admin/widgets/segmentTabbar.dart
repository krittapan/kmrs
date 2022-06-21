import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:kmrs/admin/widgets/widgets.dart';
import 'package:kmrs/model/userData.dart';

class SementTabbar extends StatefulWidget {
  UserData userData;
  SementTabbar({Key? key, required this.userData}) : super(key: key);

  @override
  State<SementTabbar> createState() => _SementTabbarState();
}

class _SementTabbarState extends State<SementTabbar> {
  @override
  void initState() {
    super.initState();
    // Add fild all doc in collection
    // FirebaseFirestore.instance.collection('reports').get().then(
    //       (value) => value.docs.forEach(
    //         (element) {
    //           var docRef = FirebaseFirestore.instance
    //               .collection('reports')
    //               .doc(element.id);

    //           docRef.update({'year': '2565'});
    //         },
    //       ),
    //     );
  }

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 20),
              const Text('รายงานประจำปี 2565',
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 22)),
              DefaultTabController(
                length: 3, // length of tabs
                initialIndex: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      child: const TabBar(
                        labelColor: Colors.green,
                        unselectedLabelColor: Colors.black,
                        tabs: [
                          Tab(text: 'รายงานแผน'),
                          Tab(text: 'รายงานผล 6 เดือน'),
                          Tab(text: 'รายงานผล 12 เดือน'),
                        ],
                      ),
                    ),
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
                    Container(
                      height: 600, //height of TabBarView
                      decoration: const BoxDecoration(
                          border: Border(
                              top: BorderSide(color: Colors.grey, width: 0.5))),
                      child: TabBarView(
                        children: <Widget>[
                          Container(
                            child: SegmentList(
                              userData: widget.userData,
                              year: '2565',
                              cycle: '1',
                            ),
                          ),
                          Container(
                            child: SegmentList(
                              userData: widget.userData,
                              year: '2565',
                              cycle: '2',
                            ),
                          ),
                          Container(
                            child: SegmentList(
                              userData: widget.userData,
                              year: '2565',
                              cycle: '3',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
