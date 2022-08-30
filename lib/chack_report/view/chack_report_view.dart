import 'dart:convert';
import 'dart:html';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kmrs/admin/admin.dart';
import 'package:kmrs/app/app.dart';
import 'package:flutter/services.dart';
import 'package:kmrs/footer/footer.dart';
import 'package:kmrs/model/action_plan_kuqs.dart';
import 'package:kmrs/model/ap.dart';
import 'package:kmrs/model/as_is.dart';
import 'package:kmrs/model/userData.dart';
import 'package:kmrs/user/view/user_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChackReportForm extends StatefulWidget {
  String reportId;
  UserData userData;
  ChackReportForm({Key? key, required this.userData, required this.reportId})
      : super(key: key);

  @override
  _ChackReportFormState createState() => _ChackReportFormState();
}

class _ChackReportFormState extends State<ChackReportForm> {
  CollectionReference reports =
      FirebaseFirestore.instance.collection('reports');
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();

  final _form2Key = GlobalKey<FormState>(); //search

  List<String> buff = [];
  List<String> buff1 = [];
  late String tobe = '';
  late String tobeComment = '';
  late String asisComment = '';
  late String apkuqaComment = '';
  late String apComment = '';
  late String swotAsIs = '';
  late String segmentNameTH = '';
  late List<Asis> asisList = [];
  late List<ApKuqs> apkuqaList = [];
  late List<Ap> apList = [];
  late String search;
  bool tobeCheck = false;
  bool swotChack = false;  
  bool isLodeing = true;
  List<bool> asisChack = [
    false,
    false,
    false,
    false,
  ];
  List<bool> apkuqaChack = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];
  List<bool> apChack = [
    false,
  ];

  List<String> keywordList = [
    'สร้างสรรค์ภูมิปัญญา',
    'นวัตกรรม',
    'มั่นคง',
  ];
  List<String> items = [
    'ไม่ตรงตามยุทธศาสตร์ ',
    'ยุทธศาสตร์ที่ 1',
    'ยุทธศาสตร์ที่ 2',
    'ยุทธศาสตร์ที่ 3',
    'ยุทธศาสตร์ที่ 4',
    'ยุทธศาสตร์ที่ 5',
  ];
  List<String> items1 = [
    'ไม่ระบุบ',
    'เว็บส่วนงาน',
    'คลังความรู้ส่วนงาน',
    'Software/APP',
    'FB/Community',
    'คลังดิจิทัล มก.',
    'อื่น ๆ ระบุ',
  ];
  List<String> keywordAwsList = [];
  List<String> subTitleNo3 = [
    'จุดแข็ง (Strengths)',
    'จุดอ่อน (Weaknesses)',
    'โอกาส (Opportunities)',
    'อุปสรรค (Threats)'
  ];
  List<String> titleTableNo4 = [
    'ลำดับ',
    'เป้าหมาย/ประเด็นการจัดการความรู้',
    'ความสอดคล้องกับยุทธศาสตร์ หรือภาระหน้าที่ตาม KUQS/พันธกิจ',
    'วัตถุประสงค์',
    'ผลผลิต/ผลลัพธ์ที่คาดว่าจะได้รับ(Output/Outcome)',
    'ตัวชี้วัดความสำเร็จ',
    'กิจกรรมการจัดการความรู้',
    'ระยะเวลาที่ดำเนินการ',
    'งบประมาณ(ถ้ามี)',
    'ผู้รับผิดชอบหลัก'
  ];
//ตัวแปล scroll
  // final _verticalScrollController = ScrollController();
  final _horizontalScrollController = ScrollController();
  void chackKeywordFunction(String str) {
    keywordAwsList.clear();
    for (int i = 0; i < keywordList.length; i++) {
      RegExp exp = RegExp(
        keywordList[i],
        caseSensitive: false,
      );
      if (exp.hasMatch(str)) keywordAwsList.add(keywordList[i]);
    }
  }

  Future getDoc() async {
    await FirebaseFirestore.instance
        .collection('reports')
        .doc(widget.reportId)
        .get()
        .then((document) {
      if (document.exists) {
        setState(() {
          segmentNameTH = document['segmentNameTH'].toString();
          tobe = document['tobe'].toString();
          tobeCheck = document['tobeCheck'] as bool;
          swotChack = document['swotChack'] as bool;
          swotAsIs = document['swotAsIs'].toString();
          List<dynamic> ass;
          ass = document['asIs'] as List<dynamic>;
          for (var i = 0; i < ass.length; i++) {
            asisList.add(Asis.fromMap(ass[i] as Map<String, dynamic>));
          }
          ass.clear();
          ass = document['apkuqa'] as List<dynamic>;
          for (var i = 0; i < ass.length; i++) {
            apkuqaList.add(ApKuqs.fromMap(ass[i] as Map<String, dynamic>));
          }
          ass.clear();
          ass = document['ap'] as List<dynamic>;
          for (var i = 0; i < ass.length; i++) {
            apList.add(Ap.fromMap(ass[i] as Map<String, dynamic>));
          }
        });
      } else {
        print('Document does not exist on the database');
      }
    }).whenComplete(() {
      //await updateDoc();
      isLodeing = false;
    });
  }

  Future updateDoc() async {
    // Call the user's CollectionReference to add a new user
    return reports.doc(widget.reportId).update({
      //'status': 'ส่งรายงานแผนแล้ว',
      'status': 3,
      'tobeCheck': tobeCheck,
      'swotChack': swotChack,
      'tobeComment': tobeComment,
      'asisComment': asisComment,
      'apkuqaComment': apkuqaComment,
      'apComment': apComment,
      'asIs': asisList.map((e) => e.toJson()).toList(),
      'apkuqa': apkuqaList.map((e) => e.toJson()).toList(),
      'ap': apList.map((e) => e.toJson()).toList(),
    });
  }

  Future addFieldToDoc() async {
    // Call the user's CollectionReference to add a new user
    return reports.doc(widget.reportId).update({
      'tobeComment': 'ไม่มีหมายเหตุ',
      'asisComment': 'ไม่มีหมายเหตุ',
      'apkuqaComment': 'ไม่มีหมายเหตุ',
      'apComment': 'ไม่มีหมายเหตุ',
      //'status': 'ส่งรายงานแผนแล้ว',
      // 'status': 3,
      // 'tobeCheck': tobeCheck,
      // 'swotChack': swotChack,
      // 'asIs': asisList.map((e) => e.toJson()).toList(),
      // 'apkuqa': apkuqaList.map((e) => e.toJson()).toList(),
      // 'ap': apList.map((e) => e.toJson()).toList(),
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
  }

  @override
  void initState() {
    // super.initState(); should be at the start of the method
    super.initState();
    getDoc();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select((AppBloc bloc) => bloc.state.user);
    setPageTitle('ตรวจรายงาน $segmentNameTH', context);
    return Scaffold(
      backgroundColor: const Color(0xffeff5f5),
      appBar: AppBar(
        backgroundColor: const Color(0xff006664),
        title: const Text(
          'ตรวจสอบ รายงานแผนการจัดการความรู้ของส่วนงาน ประจำปี',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
        ),
      ),
      body: isLodeing == true
          ? const Center(
              child: CircularProgressIndicator(
                semanticsLabel: 'ค้นหาขอมูล',
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const <Widget>[
                          Text(
                            'คณะกรรมการจัดการความรู้มหาวิทยาลัยเกษตรศาสตร์ ได้จัดทำแบบฟอร์มรายงานแผนการจัดการความรู้ เพื่อให้ส่วนงานนำไปจัดทำแผนการจัดการความรู้ของส่วนงานให้ครอบคลุมองค์ประกอบการประกันคุณภาพและการประเมินผลด้านการจัดการความรู้ของมหาวิทยาลัยขอให้คณะกรรมการหรือคณะทำงานด้านการจัดการความรู้ของส่วนงาน ใส่ข้อมูลให้ครบถ้วนเพื่อประโยชน์สูงสุดในการดำเนินการจัดการความรู้มหาวิทยาลัยเกษตรศาสตร์',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                  organizationName(segmentNameTH),
                  toBe(),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            '3. การวิเคราะห์ตนเองของส่วนงาน (As is)',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(10),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 5,
                                      child: TextTableWidget(
                                          text:
                                              'ปัจจัยภายในที่สนับสนุนและอุปสรรคที่มีผลต่อการจัดการความรู้ให้สำเร็จตามเป้าหมาย'),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: TextTableWidget(
                                          text:
                                              'ปัจจัยภายนอกที่สนับสนุนและอุปสรรคที่มีผลต่อการจัดการความรู้ให้สำเร็จตามเป้าหมาย'),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                Row(
                                  children: List.generate(
                                      subTitleNo3.length,
                                      (index) => Expanded(
                                          flex: 5,
                                          child: TextTableWidget(
                                              text: subTitleNo3[index]))),
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: asisList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      margin: const EdgeInsets.all(5),
                                      child: Column(
                                        children: [
                                          const Divider(),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 5,
                                                child: CheckboxListTile(
                                                  title: Text(asisList[index]
                                                      .strengths),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      asisList[index]
                                                              .strengthsCheck =
                                                          !asisList[index]
                                                              .strengthsCheck!;
                                                    });
                                                  },
                                                  value: asisList[index]
                                                      .strengthsCheck,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 5,
                                                child: CheckboxListTile(
                                                  title: Text(asisList[index]
                                                      .weaknesses),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      asisList[index]
                                                              .weaknessesCheck =
                                                          !asisList[index]
                                                              .weaknessesCheck!;
                                                    });
                                                  },
                                                  value: asisList[index]
                                                      .weaknessesCheck,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 5,
                                                child: CheckboxListTile(
                                                  title: Text(asisList[index]
                                                      .opportunities),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      asisList[index]
                                                              .opportunitiesCheck =
                                                          !asisList[index]
                                                              .opportunitiesCheck!;
                                                    });
                                                  },
                                                  value: asisList[index]
                                                      .opportunitiesCheck,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 5,
                                                child: CheckboxListTile(
                                                  title: Text(
                                                      asisList[index].threatsl),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      asisList[index]
                                                              .threatslCheck =
                                                          !asisList[index]
                                                              .threatslCheck!;
                                                    });
                                                  },
                                                  value: asisList[index]
                                                      .threatslCheck,
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(
                                                    Icons.visibility),
                                                onPressed: () async {
                                                  await showDialog<Widget>(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return StatefulBuilder(
                                                          builder: (context,
                                                              setState) {
                                                        return AlertDialog(
                                                          title: const Text(
                                                              'การวิเคราะห์ตนเองของส่วนงาน (As is)'),
                                                          content:
                                                              SingleChildScrollView(
                                                            child: Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .all(10),
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  const Text(
                                                                    'จุดแข็ง (Strengths)',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(8),
                                                                    child:
                                                                        CheckboxListTile(
                                                                      title: Text(
                                                                          asisList[index]
                                                                              .strengths),
                                                                      onChanged:
                                                                          (value) {
                                                                        setState(
                                                                            () {
                                                                          asisList[index].strengthsCheck =
                                                                              !asisList[index].strengthsCheck!;
                                                                        });
                                                                      },
                                                                      value: asisList[
                                                                              index]
                                                                          .strengthsCheck,
                                                                    ),
                                                                  ),
                                                                  const Text(
                                                                    'จุดอ่อน (Weaknesses)',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(8),
                                                                    child:
                                                                        CheckboxListTile(
                                                                      title: Text(
                                                                          asisList[index]
                                                                              .weaknesses),
                                                                      onChanged:
                                                                          (value) {
                                                                        setState(
                                                                            () {
                                                                          asisList[index].weaknessesCheck =
                                                                              !asisList[index].weaknessesCheck!;
                                                                        });
                                                                      },
                                                                      value: asisList[
                                                                              index]
                                                                          .weaknessesCheck,
                                                                    ),
                                                                  ),
                                                                  const Text(
                                                                    'โอกาส (Opportunities)',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(8),
                                                                    child:
                                                                        CheckboxListTile(
                                                                      title: Text(
                                                                          asisList[index]
                                                                              .opportunities),
                                                                      onChanged:
                                                                          (value) {
                                                                        setState(
                                                                            () {
                                                                          asisList[index].opportunitiesCheck =
                                                                              !asisList[index].opportunitiesCheck!;
                                                                        });
                                                                      },
                                                                      value: asisList[
                                                                              index]
                                                                          .opportunitiesCheck,
                                                                    ),
                                                                  ),
                                                                  const Text(
                                                                    'อุปสรรค (Threats)',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(8),
                                                                    child:
                                                                        CheckboxListTile(
                                                                      title: Text(
                                                                          asisList[index]
                                                                              .threatsl),
                                                                      onChanged:
                                                                          (value) {
                                                                        setState(
                                                                            () {
                                                                          asisList[index].threatslCheck =
                                                                              !asisList[index].threatslCheck!;
                                                                        });
                                                                      },
                                                                      value: asisList[
                                                                              index]
                                                                          .threatslCheck,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: const Text(
                                                                'ปิด',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .blue),
                                                              ),
                                                            )
                                                          ],
                                                        );
                                                      });
                                                    },
                                                  );
                                                  setState(() {});
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                const Divider(),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'ผลสรุปการวิเคราะห์ตนเองจาก SWOT (As is)',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(10),
                                  child: CheckboxListTile(
                                    title: Text(
                                      swotAsIs,
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        swotChack = !swotChack;
                                      });
                                    },
                                    value: swotChack,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Text(
                            'หมายเหตุ',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(10),
                            child: TextFormField(
                              onChanged: (value) => asisComment = value,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              minLines: 1,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
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
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            '4.  แนวทางการจัดการความรู้ที่สนับสนุนยุทธศาสตร์ หรือภาระหน้าที่ตาม KUQS ของส่วนงาน สู่ความสำเร็จ (KM Action plans)',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          ScrollConfiguration(
                            behavior: ScrollConfiguration.of(context).copyWith(
                              dragDevices: {
                                PointerDeviceKind.touch,
                                PointerDeviceKind.mouse,
                              },
                            ),
                            child: Scrollbar(
                              // isAlwaysShown: true,
                              controller: _horizontalScrollController,
                              interactive: true,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                controller: _horizontalScrollController,
                                child: DataTable(
                                    dataRowHeight: 86,
                                    // dataTextStyle: TextStyle(),
                                    // columnSpacing: 10,
                                    columns: List.generate(titleTableNo4.length,
                                        (index) {
                                      // ignore: lines_longer_than_80_chars
                                      return DataColumn(
                                          label: Expanded(
                                        // flex: 7,
                                        child: TextTableWidget(
                                            text: titleTableNo4[index]),
                                      ));
                                    }),
                                    rows: List.generate(apkuqaList.length,
                                        (index) {
                                      return DataRow(cells: [
                                        DataCell(Text((index + 1).toString())),
                                        DataCell(
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.3,
                                            child: CheckboxListTile(
                                              title: textCell(
                                                  apkuqaList[index].target,
                                                  150),
                                              onChanged: (value) {
                                                setState(() {
                                                  // ignore: lines_longer_than_80_chars
                                                  apkuqaList[index]
                                                          .targetCheck =
                                                      !apkuqaList[index]
                                                          .targetCheck!;
                                                });
                                              },
                                              value:
                                                  apkuqaList[index].targetCheck,
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Column(
                                            children: [
                                              textCell(
                                                  apkuqaList[index].obligations,
                                                  50),
                                              Container(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        5, 0, 5, 0),
                                                child:
                                                    // ignore: lines_longer_than_80_chars
                                                    DropdownButtonHideUnderline(
                                                  child: Column(
                                                    children: [
                                                      DropdownButton(
                                                        alignment: Alignment
                                                            .bottomRight,
                                                        isExpanded: true,
                                                        items: items.map<
                                                            DropdownMenuItem<
                                                                String>>((String
                                                            value) {
                                                          return DropdownMenuItem<
                                                              String>(
                                                            value: value,
                                                            child: Text(value),
                                                          );
                                                        }).toList(),
                                                        onChanged:
                                                            (String? newValue) {
                                                          setState(() {
                                                            apkuqaList[index]
                                                                    .obligationsCheck =
                                                                newValue;
                                                          });
                                                        },
                                                        value: apkuqaList[index]
                                                            .obligationsCheck,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        DataCell(
                                          CheckboxListTile(
                                            title: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.3,
                                              child: textCell(
                                                  apkuqaList[index].objective,
                                                  150),
                                            ),
                                            onChanged: (value) {
                                              setState(() {
                                                apkuqaList[index]
                                                        .objectiveCheck =
                                                    !apkuqaList[index]
                                                        .objectiveCheck!;
                                              });
                                            },
                                            value: apkuqaList[index]
                                                .objectiveCheck,
                                          ),
                                        ),
                                        DataCell(
                                          CheckboxListTile(
                                            title: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.3,
                                                child: textCell(
                                                    apkuqaList[index].output,
                                                    150)),
                                            onChanged: (value) {
                                              setState(() {
                                                apkuqaList[index].outputCheck =
                                                    !apkuqaList[index]
                                                        .outputCheck!;
                                              });
                                            },
                                            value:
                                                apkuqaList[index].outputCheck,
                                          ),
                                        ),
                                        DataCell(
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.3,
                                            child: CheckboxListTile(
                                              title: textCell(
                                                  apkuqaList[index]
                                                      .success_metrics,
                                                  150),
                                              onChanged: (value) {
                                                setState(() {
                                                  apkuqaList[index]
                                                          .successMetricsCheck =
                                                      !apkuqaList[index]
                                                          .successMetricsCheck!;
                                                });
                                              },
                                              value: apkuqaList[index]
                                                  .successMetricsCheck,
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.3,
                                            child: CheckboxListTile(
                                              title: textCell(
                                                  apkuqaList[index]
                                                      .knowledgeManagementActivities,
                                                  150),
                                              onChanged: (value) {
                                                setState(() {
                                                  apkuqaList[index]
                                                          .knowledgeManagementActivitiesCheck =
                                                      !apkuqaList[index]
                                                          .knowledgeManagementActivitiesCheck!;
                                                });
                                              },
                                              value: apkuqaList[index]
                                                  .knowledgeManagementActivitiesCheck,
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          CheckboxListTile(
                                            title: Text(apkuqaList[index]
                                                .periodOperated),
                                            onChanged: (value) {
                                              setState(() {
                                                apkuqaList[index]
                                                        .periodOperatedCheck =
                                                    !apkuqaList[index]
                                                        .periodOperatedCheck!;
                                              });
                                            },
                                            value: apkuqaList[index]
                                                .periodOperatedCheck,
                                          ),
                                        ),
                                        DataCell(
                                            Text(apkuqaList[index].budget)),
                                        DataCell(Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(apkuqaList[index]
                                                .responsiblePerson),
                                            IconButton(
                                              icon:
                                                  const Icon(Icons.visibility),
                                              onPressed: () async {
                                                await showDialog<Widget>(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return StatefulBuilder(
                                                        builder: (context,
                                                            setState) {
                                                      return AlertDialog(
                                                        title: const Text(
                                                          'แนวทางการจัดการความรู้ที่สนับสนุนยุทธศาสตร์ หรือภาระหน้าที่ตาม KUQS ของส่วนงาน สู่ความสำเร็จ (KM Action plans)',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 20,
                                                          ),
                                                        ),
                                                        content:
                                                            SingleChildScrollView(
                                                          child: Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .all(10),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                const Text(
                                                                  'เป้าหมาย/ประเด็นการจัดการความรู้ ',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(8),
                                                                  child:
                                                                      CheckboxListTile(
                                                                    title: Text(
                                                                        apkuqaList[index]
                                                                            .target),
                                                                    onChanged:
                                                                        (value) {
                                                                      setState(
                                                                          () {
                                                                        apkuqaList[index]
                                                                            .targetCheck = !apkuqaList[
                                                                                index]
                                                                            .targetCheck!;
                                                                      });
                                                                    },
                                                                    value: apkuqaList[
                                                                            index]
                                                                        .targetCheck,
                                                                  ),
                                                                ),
                                                                const Text(
                                                                  'ความสอดคล้องกับยุทธศาสตร์ หรือภาระหน้าที่ตาม KUQS/พันธกิจ',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(8),
                                                                  child: Row(
                                                                    children: [
                                                                      Text(apkuqaList[
                                                                              index]
                                                                          .obligations),
                                                                      Container(
                                                                        padding: const EdgeInsets.fromLTRB(
                                                                            5,
                                                                            0,
                                                                            5,
                                                                            0),
                                                                        width:
                                                                            200,
                                                                        child:
                                                                            DropdownButtonHideUnderline(
                                                                          child:
                                                                              DropdownButton(
                                                                            alignment:
                                                                                Alignment.bottomRight,
                                                                            isExpanded:
                                                                                true,
                                                                            items:
                                                                                items.map<DropdownMenuItem<String>>((String value) {
                                                                              return DropdownMenuItem<String>(
                                                                                value: value,
                                                                                child: Text(value),
                                                                              );
                                                                            }).toList(),
                                                                            onChanged:
                                                                                (String? newValue) {
                                                                              setState(() {
                                                                                apkuqaList[index].obligationsCheck = newValue;
                                                                              });
                                                                            },
                                                                            value:
                                                                                apkuqaList[index].obligationsCheck,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                const Text(
                                                                  'วัตถุประสงค์',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(8),
                                                                  child:
                                                                      CheckboxListTile(
                                                                    title: Text(
                                                                        apkuqaList[index]
                                                                            .objective),
                                                                    onChanged:
                                                                        (value) {
                                                                      setState(
                                                                          () {
                                                                        apkuqaList[index]
                                                                            .objectiveCheck = !apkuqaList[
                                                                                index]
                                                                            .objectiveCheck!;
                                                                      });
                                                                    },
                                                                    value: apkuqaList[
                                                                            index]
                                                                        .objectiveCheck,
                                                                  ),
                                                                ),
                                                                const Text(
                                                                  'ผลผลิต/ผลลัพธ์ที่คาดว่าจะได้รับ(Output/Outcome)',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(8),
                                                                  child:
                                                                      CheckboxListTile(
                                                                    title: Text(
                                                                        apkuqaList[index]
                                                                            .output),
                                                                    onChanged:
                                                                        (value) {
                                                                      setState(
                                                                          () {
                                                                        apkuqaList[index]
                                                                            .outputCheck = !apkuqaList[
                                                                                index]
                                                                            .outputCheck!;
                                                                      });
                                                                    },
                                                                    value: apkuqaList[
                                                                            index]
                                                                        .outputCheck,
                                                                  ),
                                                                ),
                                                                const Text(
                                                                  'ตัวชี้วัดความสำเร็จ',
                                                                  style:
                                                                      TextStyle(
                                                                    // ignore: lines_longer_than_80_chars
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(8),
                                                                  child:
                                                                      CheckboxListTile(
                                                                    title: Text(
                                                                        apkuqaList[index]
                                                                            .success_metrics),
                                                                    onChanged:
                                                                        (value) {
                                                                      setState(
                                                                          () {
                                                                        apkuqaList[index]
                                                                            .successMetricsCheck = !apkuqaList[
                                                                                index]
                                                                            .successMetricsCheck!;
                                                                      });
                                                                    },
                                                                    value: apkuqaList[
                                                                            index]
                                                                        .successMetricsCheck,
                                                                  ),
                                                                ),
                                                                const Text(
                                                                  'กิจกรรมการจัดการความรู้',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(8),
                                                                  child:
                                                                      CheckboxListTile(
                                                                    title: Text(
                                                                        apkuqaList[index]
                                                                            .knowledgeManagementActivities),
                                                                    onChanged:
                                                                        (value) {
                                                                      setState(
                                                                          () {
                                                                        apkuqaList[index]
                                                                            .knowledgeManagementActivitiesCheck = !apkuqaList[
                                                                                index]
                                                                            .knowledgeManagementActivitiesCheck!;
                                                                      });
                                                                    },
                                                                    value: apkuqaList[
                                                                            index]
                                                                        .knowledgeManagementActivitiesCheck,
                                                                  ),
                                                                ),
                                                                const Text(
                                                                  'ระยะเวลาที่ดำเนินการ',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(8),
                                                                  child:
                                                                      CheckboxListTile(
                                                                    title: Text(
                                                                        apkuqaList[index]
                                                                            .periodOperated),
                                                                    onChanged:
                                                                        (value) {
                                                                      setState(
                                                                          () {
                                                                        apkuqaList[index]
                                                                            .periodOperatedCheck = !apkuqaList[
                                                                                index]
                                                                            .periodOperatedCheck!;
                                                                      });
                                                                    },
                                                                    value: apkuqaList[
                                                                            index]
                                                                        .periodOperatedCheck,
                                                                  ),
                                                                ),
                                                                const Text(
                                                                  'งบประมาณ',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(8),
                                                                  child: Text(
                                                                      apkuqaList[
                                                                              index]
                                                                          .budget),
                                                                ),
                                                                const Text(
                                                                  'ผู้รับผิดชอบหลัก',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(8),
                                                                  child: Text(apkuqaList[
                                                                          index]
                                                                      .responsiblePerson),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                              'ปิด',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .blue),
                                                            ),
                                                          )
                                                        ],
                                                      );
                                                    });
                                                  },
                                                );
                                                setState(() {});
                                              },
                                            )
                                          ],
                                        )),
                                      ]);
                                    })),
                              ),
                            ),
                          ),
                          const Text(
                            'หมายเหตุ',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(10),
                            child: TextFormField(
                              onChanged: (value) => apkuqaComment = value,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              minLines: 1,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
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
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            '5. การจัดการสินทรัพย์ความรู้ที่เกิดจากการดำเนินการตามแผน KM Action Plans เพื่อประโยชน์สูงสุดของส่วนงาน',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(10),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: TextTableWidget(text: 'ลำดับ'),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: TextTableWidget(
                                          text:
                                              'รายการสินทรัพย์ความรู้ที่จะได้รับจากการดำเนินการตามแผน ฯ'),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: TextTableWidget(
                                          text:
                                              'แหล่งจัดเก็บและเผยแพร่สินทรัพย์ความรู้'),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: TextTableWidget(
                                          text:
                                              'แนวทางการนำสินทรัพย์ความรู้ไปใช้ให้เกิดประโยชน์สูงสุดต่อส่วนงาน'),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: apList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      margin: const EdgeInsets.all(5),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                    (index + 1).toString()),
                                              ),
                                              Expanded(
                                                flex: 5,
                                                child: Column(
                                                  children: [
                                                    Text(apList[index]
                                                        .list_of_experiences),
                                                    Container(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(5, 0, 5, 0),
                                                      width: 200,
                                                      child:
                                                          DropdownButtonHideUnderline(
                                                        child: DropdownButton<
                                                            String>(
                                                          alignment: Alignment
                                                              .bottomRight,
                                                          isExpanded: true,
                                                          onChanged: (String?
                                                              newValue) {
                                                            setState(() {
                                                              apList[index]
                                                                      .list_of_experiencesCheck =
                                                                  newValue!;
                                                            });
                                                          },
                                                          value: apList[index]
                                                              .list_of_experiencesCheck,
                                                          items: items.map<
                                                              DropdownMenuItem<
                                                                  String>>(
                                                            (String value) {
                                                              return DropdownMenuItem<
                                                                  String>(
                                                                value: value,
                                                                child:
                                                                    Text(value),
                                                              );
                                                            },
                                                          ).toList(),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 5,
                                                //child: Text(apList[index].storage),
                                                child: Column(
                                                  children: [
                                                    Text(apList[index].storage),
                                                    Container(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(5, 0, 5, 0),
                                                      width: 200,
                                                      child:
                                                          DropdownButtonHideUnderline(
                                                        child: DropdownButton<
                                                            String>(
                                                          alignment: Alignment
                                                              .bottomRight,
                                                          isExpanded: true,
                                                          onChanged: (String?
                                                              newValue) {
                                                            setState(() {
                                                              apList[index]
                                                                      .storageCheck =
                                                                  newValue!;
                                                            });
                                                          },
                                                          value: apList[index]
                                                              .storageCheck,
                                                          items: items1.map<
                                                              DropdownMenuItem<
                                                                  String>>(
                                                            (String value) {
                                                              return DropdownMenuItem<
                                                                  String>(
                                                                value: value,
                                                                child:
                                                                    Text(value),
                                                              );
                                                            },
                                                          ).toList(),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 5,
                                                child: CheckboxListTile(
                                                  title: Text(
                                                      apList[index].guidelines),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      apList[index]
                                                              .guidelinesCheck =
                                                          value;
                                                    });
                                                  },
                                                  value: apList[index]
                                                      .guidelinesCheck,
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(
                                                    Icons.visibility),
                                                onPressed: () async {
                                                  await showDialog<Widget>(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return StatefulBuilder(
                                                          builder: (context,
                                                              setState) {
                                                        return AlertDialog(
                                                          title: const Text(
                                                            'การจัดการสินทรัพย์ความรู้ที่เกิดจากการดำเนินการตามแผน KM Action Plans เพื่อประโยชน์สูงสุดของส่วนงาน',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 20,
                                                            ),
                                                          ),
                                                          content:
                                                              SingleChildScrollView(
                                                            child: Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .all(10),
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  const Text(
                                                                    'รายการสินทรัพย์ความรู้ที่จะได้รับจากการดำเนินการตามแผน ฯ',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(8),
                                                                    child:
                                                                        CheckboxListTile(
                                                                      title: Text(
                                                                          apkuqaList[index]
                                                                              .target),
                                                                      onChanged:
                                                                          (value) {
                                                                        setState(
                                                                            () {
                                                                          apkuqaList[index].targetCheck =
                                                                              !apkuqaList[index].targetCheck!;
                                                                        });
                                                                      },
                                                                      value: apkuqaList[
                                                                              index]
                                                                          .targetCheck,
                                                                    ),
                                                                  ),
                                                                  const Text(
                                                                    'แหล่งจัดเก็บและเผยแพร่สินทรัพย์ความรู้ ',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(8),
                                                                    child: Row(
                                                                      children: [
                                                                        Text(apkuqaList[index]
                                                                            .obligations),
                                                                        Container(
                                                                          padding: const EdgeInsets.fromLTRB(
                                                                              5,
                                                                              0,
                                                                              5,
                                                                              0),
                                                                          width:
                                                                              200,
                                                                          child:
                                                                              DropdownButtonHideUnderline(
                                                                            child:
                                                                                DropdownButton(
                                                                              alignment: Alignment.bottomRight,
                                                                              isExpanded: true,
                                                                              items: items.map<DropdownMenuItem<String>>((String value) {
                                                                                return DropdownMenuItem<String>(
                                                                                  value: value,
                                                                                  child: Text(value),
                                                                                );
                                                                              }).toList(),
                                                                              onChanged: (String? newValue) {
                                                                                setState(() {
                                                                                  apList[index].storageCheck = newValue;
                                                                                });
                                                                              },
                                                                              value: apList[index].storageCheck,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  const Text(
                                                                    'แนวทางการนำสินทรัพย์ความรู้ไปใช้ให้เกิดประโยชน์สูงสุดต่อส่วนงาน',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(8),
                                                                    child:
                                                                        CheckboxListTile(
                                                                      title: Text(
                                                                          apList[index]
                                                                              .guidelines),
                                                                      onChanged:
                                                                          (value) {
                                                                        setState(
                                                                            () {
                                                                          apList[index].guidelinesCheck =
                                                                              !apList[index].guidelinesCheck!;
                                                                        });
                                                                      },
                                                                      value: apList[
                                                                              index]
                                                                          .guidelinesCheck,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: const Text(
                                                                'ปิด',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .blue),
                                                              ),
                                                            )
                                                          ],
                                                        );
                                                      });
                                                    },
                                                  );
                                                  setState(() {});
                                                },
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                const Divider(),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                          const Text(
                            'หมายเหตุ',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(10),
                            child: TextFormField(
                              onChanged: (value) => apComment = value,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              minLines: 1,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
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
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.all(10),
                                  child: OutlinedButton(
                                    child: const Text('บันทึก'),
                                    onPressed: () => showDialog<Text>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('แจ้งเตือน'),
                                          content: const Text(
                                              'ยืนยัน การบันทึก การตรวจสอบ'),
                                          actions: <Widget>[
                                            TextButton(
                                                onPressed: () async {
                                                  await updateDoc()
                                                      .whenComplete(
                                                    () =>
                                                        Navigator.push<AppBloc>(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            AdminDashboard(
                                                          userData:
                                                              widget.userData,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: const Text('ยืนยัน')),
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('ยกเลิก')),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: const Footer(),
    );
  }

  Text textCell(String t, int subEnd) {
    var text = '';
    final textLength = t.length;
    textLength < subEnd ? text = t : text = '${t.substring(0, subEnd)}...';
    return Text(text, maxLines: 3);
  }

  Card toBe() {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              '2. เป้าหมาย วิสัยทัศน์ ยุทธศาสตร์ หรือภาระหน้าที่ตาม KUQS ของส่วนงาน / หน่วยงาน (To be)',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'หมายเหตุ เป้าหมาย วิสัยทัศน์ ยุทธศาสตร์ ตาม KUQS สำหรับคณะและสถาบัน',
            ),
            const Text('หมายเหตุ ภาระหน้าที่ ตาม KUQS สำหรับสำนัก'),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.all(10),
              child: CheckboxListTile(
                title: Text(
                  tobe,
                  style: const TextStyle(fontSize: 16),
                ),
                onChanged: (value) {
                  setState(() {
                    tobeCheck = !tobeCheck;
                  });
                },
                value: tobeCheck,
              ),
            ),
            const Text(
              'keyword',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              itemCount: keywordList.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: Row(
                    children: [
                      Text(keywordList[index]),
                      IconButton(
                        onPressed: () => showDialog<Text>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('แจ้งเตือน'),
                              content: Text(
                                  'ยืนยันลบ keyword ${keywordList[index]}'),
                              actions: <Widget>[
                                TextButton(
                                    onPressed: () {
                                      setState(() {
                                        keywordList.removeAt(index);
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: const Text('ยืนยัน')),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('ยกเลิก')),
                              ],
                            );
                          },
                        ),
                        icon: const Icon(
                          Icons.close,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.all(10),
              child: Form(
                key: _form2Key,
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  minLines: 1,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'กรุณาระบุบ Keyword';
                    }
                    return null;
                  },
                  onChanged: (value) => search = value.trim(),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(20),
              child: OutlinedButton(
                onPressed: () {
                  if (_form2Key.currentState!.validate()) {
                    setState(() {
                      keywordList.add(search);
                      _form2Key.currentState!.reset();
                    });
                  }
                },
                child: const Text('เพิ่ม Keyword'),
              ),
            ),
            const Text(
              'keyword ที่ตรวจพบ',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              itemCount: keywordAwsList.length,
              itemBuilder: (context, index) {
                return Text(keywordAwsList[index]);
              },
            ),
            Container(
              margin: const EdgeInsets.all(20),
              child: OutlinedButton(
                onPressed: () {
                  setState(
                    () {
                      chackKeywordFunction(tobe);
                    },
                  );
                },
                child: const Text('ตรวจสอบ'),
              ),
            ),
            const Text(
              'หมายเหตุ',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: TextFormField(
                onChanged: (value) => tobeComment = value,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                minLines: 1,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Card organizationName(String organizationName) {
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
            Text(
              organizationName,
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void setPageTitle(String title, BuildContext context) {
  SystemChrome.setApplicationSwitcherDescription(ApplicationSwitcherDescription(
    label: title,
    primaryColor: Theme.of(context).primaryColor.value, // This line is required
  ));
}

class TextTableWidget extends StatelessWidget {
  String text;
  TextTableWidget({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      overflow: TextOverflow.fade,
    );
  }
}
