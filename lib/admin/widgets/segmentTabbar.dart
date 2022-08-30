// ignore_for_file: omit_local_variable_types

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
 
  String currentCycle = '1';
  String currentYear = '2565';
  List<String> items = [
    '2565',
    '2566',
    '2567',
  ];
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

    //           docRef.update({'cycle': '1'});
    //         },
    //       ),
    //     );
  }

  @override
  Widget build(BuildContext context) {
   final size = MediaQuery.of(context).size;

    return Card(
      margin: const EdgeInsets.all(20),
      elevation: 4,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('รายงานประจำปี',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22)),
                Container(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                  width: 100,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      alignment: Alignment.bottomRight,
                      isExpanded: true,
                      items:
                          items.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 20)),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          currentYear = newValue!;
                        });
                      },
                      value: currentYear,
                    ),
                  ),
                ),
              ],
            ),
            DefaultTabController(
              length: 3, // length of tabs
              initialIndex: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const TabBar(
                    labelColor: Colors.green,
                    unselectedLabelColor: Colors.black,
                    tabs: [
                      Tab(text: 'รายงานแผน'),
                      Tab(text: 'รายงานผล 6 เดือน'),
                      Tab(text: 'รายงานผล 12 เดือน'),
                    ],
                  ),
                  Container(
                    height: 30,
                    width: size.width,
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
                          child: Padding(
                            padding: EdgeInsets.only(left: 17),
                            child: Text(
                              'เวลาส่ง',
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        const Expanded(
                          flex: 2,
                          child: Padding(
                            padding: EdgeInsets.only(right: 17),
                            child: Text(
                              'สถานะ',
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ),
                        Container(
                          width: size.width*0.2,
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
                        SegmentList(
                          userData: widget.userData,
                          year: currentYear,
                          cycle: '1',
                        ),
                        SegmentList(
                          userData: widget.userData,
                          year: currentYear,
                          cycle: '2',
                        ),
                        SegmentList(
                          userData: widget.userData,
                          year: currentYear,
                          cycle: '3',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
