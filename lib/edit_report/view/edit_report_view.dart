import 'dart:math';
// ignore_for_file: lines_longer_than_80_chars
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kmrs/app/app.dart';
import 'package:kmrs/edit_report/data/data.dart';
import 'package:kmrs/edit_report/widgets/widgets.dart';
import 'package:kmrs/footer/footer.dart';
import 'package:kmrs/model/action_plan_kuqs.dart';
import 'package:kmrs/model/ap.dart';
import 'package:kmrs/model/as_is.dart';
import 'package:kmrs/model/userData.dart';
import 'package:kmrs/user/view/user_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditReportForm extends StatefulWidget {
  String reportId;
  UserData userData;
  EditReportForm({Key? key, required this.userData, required this.reportId})
      : super(key: key);

  @override
  _EditReportFormState createState() => _EditReportFormState();
}

class _EditReportFormState extends State<EditReportForm> {
  CollectionReference reports =
      FirebaseFirestore.instance.collection('reports');
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  List<String> buff = [];
  List<String> buff1 = [];
  late String tobe;
  late String tobeComment ;
  late String asisComment;
  late String apkuqaComment;
  late String apComment = "ทดสอบ";
  late String swotAsIs;
  late List<Asis> asisList = [];
  late List<ApKuqs> apkuqaList = [];
  late List<Ap> apList = [];
  bool isLodeing = true;

  final _horizontalScrollController = ScrollController();

  Future getDoc() async {
    await FirebaseFirestore.instance
        .collection('reports')
        .doc(widget.reportId)
        .get()
        .then((document) {
      if (document.exists) {
        setState(() {
          tobe = document['tobe'].toString();
          swotAsIs = document['swotAsIs'].toString();
          apComment = document['apComment'].toString();
          tobeComment = document['tobeComment'].toString();
          asisComment = document['asisComment'].toString();
          apkuqaComment = document['apkuqaComment'].toString();
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
    return reports.doc(widget.reportId).update(
      {
        'status': 2,
        'tobe': tobe,
        'swotAsIs': swotAsIs,
        'editTime': DateTime.now(),
        'asIs': asisList.map((e) => e.toJson()).toList(),
        'apkuqa': apkuqaList.map((e) => e.toJson()).toList(),
        'ap': apList.map((e) => e.toJson()).toList(),
      },
    );
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
    final size = MediaQuery.of(context).size.width * 0.3;
    final user = context.select((AppBloc bloc) => bloc.state.user);
    return Scaffold(
      backgroundColor: const Color(0xffeff5f5),
      appBar: AppBar(
        backgroundColor: const Color(0xff006664),
        title: const Text(
          'รายงานแผนการจัดการความรู้ของส่วนงาน ประจำปี',
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
                  OrganizationName(
                      organizationName: widget.userData.segmentNameTH),
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
                                      child: TextColumnWidget(
                                          text:
                                              'ปัจจัยภายในที่สนับสนุนและอุปสรรคที่มีผลต่อการจัดการความรู้ให้สำเร็จตามเป้าหมาย'),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: TextColumnWidget(
                                          text:
                                              'ปัจจัยภายนอกที่สนับสนุนและอุปสรรคที่มีผลต่อการจัดการความรู้ให้สำเร็จตามเป้าหมาย'),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 5,
                                      child: TextColumnWidget(
                                          text: 'จุดแข็ง (Strengths)'),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: TextColumnWidget(
                                          text: 'จุดอ่อน (Weaknesses)'),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: TextColumnWidget(
                                          text: 'โอกาส (Opportunities)'),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: TextColumnWidget(
                                          text: 'อุปสรรค (Threats)'),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: asisList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      margin: const EdgeInsets.all(5),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 5,
                                                child: Text(
                                                    asisList[index].strengths),
                                              ),
                                              Expanded(
                                                flex: 5,
                                                child: Text(
                                                    asisList[index].weaknesses),
                                              ),
                                              Expanded(
                                                flex: 5,
                                                child: Text(asisList[index]
                                                    .opportunities),
                                              ),
                                              Expanded(
                                                flex: 5,
                                                child: Text(
                                                    asisList[index].threatsl),
                                              ),
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.edit,
                                                  color: Colors.black,
                                                ),
                                                onPressed: () async {
                                                  await showDialog<Widget>(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: const Text(
                                                            'แก้ไข การวิเคราะห์ตนเองของส่วนงาน (As is)'),
                                                        content:
                                                            SingleChildScrollView(
                                                          child: Form(
                                                            key: _formKey1,
                                                            child: Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .all(10),
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(8),
                                                                    child:
                                                                        TextFormField(
                                                                      initialValue:
                                                                          asisList[index]
                                                                              .strengths,
                                                                      keyboardType:
                                                                          TextInputType
                                                                              .multiline,
                                                                      maxLines:
                                                                          null,
                                                                      minLines:
                                                                          1,
                                                                      decoration:
                                                                          const InputDecoration(
                                                                        label: Text(
                                                                            'จุดแข็ง (Strengths)'),
                                                                        border:
                                                                            OutlineInputBorder(),
                                                                      ),
                                                                      validator:
                                                                          (input) {
                                                                        if (input!
                                                                            .isEmpty) {
                                                                          return 'กรุณาระบุบ จุดแข็ง (Strengths)';
                                                                        }
                                                                        buff.insert(
                                                                            0,
                                                                            input);
                                                                        return null;
                                                                      },
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(8),
                                                                    child:
                                                                        TextFormField(
                                                                      initialValue:
                                                                          asisList[index]
                                                                              .weaknesses,
                                                                      keyboardType:
                                                                          TextInputType
                                                                              .multiline,
                                                                      maxLines:
                                                                          null,
                                                                      minLines:
                                                                          1,
                                                                      decoration:
                                                                          const InputDecoration(
                                                                        label: Text(
                                                                            'จุดอ่อน (Weaknesses)'),
                                                                        border:
                                                                            OutlineInputBorder(),
                                                                      ),
                                                                      validator:
                                                                          (input) {
                                                                        if (input!
                                                                            .isEmpty) {
                                                                          return 'กรุณาระบุบ จุดอ่อน (Weaknesses)';
                                                                        }
                                                                        buff.insert(
                                                                            1,
                                                                            input);
                                                                        return null;
                                                                      },
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(8),
                                                                    child:
                                                                        TextFormField(
                                                                      initialValue:
                                                                          asisList[index]
                                                                              .opportunities,
                                                                      keyboardType:
                                                                          TextInputType
                                                                              .multiline,
                                                                      maxLines:
                                                                          null,
                                                                      minLines:
                                                                          1,
                                                                      decoration:
                                                                          const InputDecoration(
                                                                        label: Text(
                                                                            'โอกาส (Opportunities)'),
                                                                        border:
                                                                            OutlineInputBorder(),
                                                                      ),
                                                                      validator:
                                                                          (input) {
                                                                        if (input!
                                                                            .isEmpty) {
                                                                          return 'กรุณาระบุบ โอกาส (Opportunities)';
                                                                        }
                                                                        buff.insert(
                                                                            2,
                                                                            input);
                                                                        return null;
                                                                      },
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(8),
                                                                    child:
                                                                        TextFormField(
                                                                      initialValue:
                                                                          asisList[index]
                                                                              .threatsl,
                                                                      keyboardType:
                                                                          TextInputType
                                                                              .multiline,
                                                                      maxLines:
                                                                          null,
                                                                      minLines:
                                                                          1,
                                                                      decoration:
                                                                          const InputDecoration(
                                                                        label: Text(
                                                                            'อุปสรรค (Threats)'),
                                                                        border:
                                                                            OutlineInputBorder(),
                                                                      ),
                                                                      validator:
                                                                          (input) {
                                                                        if (input!
                                                                            .isEmpty) {
                                                                          return 'กรุณาระบุบ อุปสรรค (Threats)';
                                                                        }
                                                                        buff.insert(
                                                                            3,
                                                                            input);
                                                                        return null;
                                                                      },
                                                                    ),
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Expanded(
                                                                        child:
                                                                            Container(
                                                                          margin:
                                                                              const EdgeInsets.all(10),
                                                                          child:
                                                                              OutlinedButton(
                                                                            child:
                                                                                const Text('บันทึก'),
                                                                            onPressed:
                                                                                () {
                                                                              var pass = _formKey1.currentState!.validate();
                                                                              if (pass) {
                                                                                setState(() {
                                                                                  asisList[index] = Asis(strengths: buff[0], weaknesses: buff[1], opportunities: buff[2], threatsl: buff[3]);
                                                                                });
                                                                                buff.clear();
                                                                                Navigator.pop(context);
                                                                              }
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                              IconButton(
                                                onPressed: () =>
                                                    showDialog<Text>(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                          'แจ้งเตือน'),
                                                      content: const Text(
                                                          'ยืนยันลบ SWOT'),
                                                      actions: <Widget>[
                                                        TextButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                asisList
                                                                    .removeAt(
                                                                        index);
                                                              });
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                                'ยืนยัน')),
                                                        TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                                'ยกเลิก')),
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
                                  child: TextFormField(
                                    onChanged: (value) => swotAsIs = value,
                                    initialValue: swotAsIs,
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
                          const Text('หมายเหตุ จากเจ้าหน้าที'),
                          const SizedBox(height: 10),
                          Container(
                            margin: const EdgeInsets.all(10),
                            child: Text(
                              asisComment,
                              maxLines: null,
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
                              controller: _horizontalScrollController,
                              interactive: true,
                              child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  controller: _horizontalScrollController,
                                  child: DataTable(
                                    dataRowHeight: 86,
                                    columns: List.generate(
                                        colName_table4.length,
                                        (index) => DataColumn(
                                                label: Expanded(
                                              child: TextColumnWidget(
                                                  text: colName_table4[index]),
                                            ))),
                                    rows: List.generate(apkuqaList.length,
                                        (index) {
                                      return DataRow(cells: [
                                        DataCell(Text(
                                          (index + 1).toString(),
                                        )),
                                        DataCell(SizedBox(
                                            width: size,
                                            child: TextRowWidget(
                                              text: apkuqaList[index].target,
                                            ))),
                                        DataCell(SizedBox(
                                            width: size,
                                            child: TextRowWidget(
                                              text:
                                                  apkuqaList[index].obligations,
                                            ))),
                                        DataCell(SizedBox(
                                            width: size,
                                            child: TextRowWidget(
                                              text: apkuqaList[index].objective,
                                            ))),
                                        DataCell(SizedBox(
                                            width: size,
                                            child: TextRowWidget(
                                              text: apkuqaList[index].output,
                                            ))),
                                        DataCell(SizedBox(
                                            width: size,
                                            child: TextRowWidget(
                                                text: apkuqaList[index]
                                                    .success_metrics))),
                                        DataCell(SizedBox(
                                            width: size,
                                            child: TextRowWidget(
                                              text: apkuqaList[index]
                                                  .knowledgeManagementActivities,
                                            ))),
                                        DataCell(SizedBox(
                                          width: size,
                                          child: TextRowWidget(
                                            text: apkuqaList[index]
                                                .periodOperated,
                                          ),
                                        )),
                                        DataCell(SizedBox(
                                          width: size,
                                          child: TextRowWidget(
                                            text: apkuqaList[index].budget,
                                          ),
                                        )),
                                        DataCell(SizedBox(
                                          width: size,
                                          child: TextRowWidget(
                                            text: apkuqaList[index]
                                                .responsiblePerson,
                                          ),
                                        )),
                                        DataCell(Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(
                                                Icons.edit,
                                                color: Colors.black,
                                              ),
                                              onPressed: () async {
                                                await showDialog<Widget>(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                          'แนวทางการจัดการความรู้ที่สนับสนุนยุทธศาสตร์ หรือภาระหน้าที่ตาม KUQS ของส่วนงาน สู่ความสำเร็จ (KM Action plans)'),
                                                      content:
                                                          SingleChildScrollView(
                                                        child: Form(
                                                          key: _formKey2,
                                                          child: Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .all(10),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(8),
                                                                  child:
                                                                      TextFormField(
                                                                    initialValue:
                                                                        apkuqaList[index]
                                                                            .target,
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .multiline,
                                                                    maxLines:
                                                                        null,
                                                                    minLines: 1,
                                                                    decoration:
                                                                        const InputDecoration(
                                                                      label: Text(
                                                                          'เป้าหมาย/ประเด็นการจัดการความรู้ '),
                                                                      border:
                                                                          OutlineInputBorder(),
                                                                    ),
                                                                    validator:
                                                                        (input) {
                                                                      if (input!
                                                                          .isEmpty) {
                                                                        return 'กรุณาระบุบ เป้าหมาย/ประเด็นการจัดการความรู้ ';
                                                                      }
                                                                      buff.insert(
                                                                          0,
                                                                          input);
                                                                      return null;
                                                                    },
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(8),
                                                                  child:
                                                                      TextFormField(
                                                                    initialValue:
                                                                        apkuqaList[index]
                                                                            .obligations,
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .multiline,
                                                                    maxLines:
                                                                        null,
                                                                    minLines: 1,
                                                                    decoration:
                                                                        const InputDecoration(
                                                                      label: Text(
                                                                          'ความสอดคล้องกับยุทธศาสตร์ หรือภาระหน้าที่ตาม KUQS/พันธกิจ'),
                                                                      border:
                                                                          OutlineInputBorder(),
                                                                    ),
                                                                    validator:
                                                                        (input) {
                                                                      if (input!
                                                                          .isEmpty) {
                                                                        return 'กรุณาระบุบ ความสอดคล้องกับยุทธศาสตร์ หรือภาระหน้าที่ตาม KUQS/พันธกิจ';
                                                                      }
                                                                      buff.insert(
                                                                          1,
                                                                          input);
                                                                      return null;
                                                                    },
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(8),
                                                                  child:
                                                                      TextFormField(
                                                                    initialValue:
                                                                        apkuqaList[index]
                                                                            .objective,
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .multiline,
                                                                    maxLines:
                                                                        null,
                                                                    minLines: 1,
                                                                    decoration:
                                                                        const InputDecoration(
                                                                      label: Text(
                                                                          'วัตถุประสงค์'),
                                                                      border:
                                                                          OutlineInputBorder(),
                                                                    ),
                                                                    validator:
                                                                        (input) {
                                                                      if (input!
                                                                          .isEmpty) {
                                                                        return 'กรุณาระบุบ วัตถุประสงค์';
                                                                      }
                                                                      buff.insert(
                                                                          2,
                                                                          input);
                                                                      return null;
                                                                    },
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(8),
                                                                  child:
                                                                      TextFormField(
                                                                    initialValue:
                                                                        apkuqaList[index]
                                                                            .output,
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .multiline,
                                                                    maxLines:
                                                                        null,
                                                                    minLines: 1,
                                                                    decoration:
                                                                        const InputDecoration(
                                                                      label: Text(
                                                                          'ผลผลิต/ผลลัพธ์ที่คาดว่าจะได้รับ(Output/Outcome)'),
                                                                      border:
                                                                          OutlineInputBorder(),
                                                                    ),
                                                                    validator:
                                                                        (input) {
                                                                      if (input!
                                                                          .isEmpty) {
                                                                        return 'กรุณาระบุบ ผลผลิต/ผลลัพธ์ที่คาดว่าจะได้รับ(Output/Outcome)';
                                                                      }
                                                                      buff.insert(
                                                                          3,
                                                                          input);
                                                                      return null;
                                                                    },
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(8),
                                                                  child:
                                                                      TextFormField(
                                                                    initialValue:
                                                                        apkuqaList[index]
                                                                            .success_metrics,
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .multiline,
                                                                    maxLines:
                                                                        null,
                                                                    minLines: 1,
                                                                    decoration:
                                                                        const InputDecoration(
                                                                      label: Text(
                                                                          'ตัวชี้วัดความสำเร็จ'),
                                                                      border:
                                                                          OutlineInputBorder(),
                                                                    ),
                                                                    validator:
                                                                        (input) {
                                                                      if (input!
                                                                          .isEmpty) {
                                                                        return 'กรุณาระบุบ ตัวชี้วัดความสำเร็จ';
                                                                      }
                                                                      buff.insert(
                                                                          4,
                                                                          input);
                                                                      return null;
                                                                    },
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(8),
                                                                  child:
                                                                      TextFormField(
                                                                    initialValue:
                                                                        apkuqaList[index]
                                                                            .knowledgeManagementActivities,
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .multiline,
                                                                    maxLines:
                                                                        null,
                                                                    minLines: 1,
                                                                    decoration:
                                                                        const InputDecoration(
                                                                      label: Text(
                                                                          'กิจกรรมการจัดการความรู้'),
                                                                      border:
                                                                          OutlineInputBorder(),
                                                                    ),
                                                                    validator:
                                                                        (input) {
                                                                      if (input!
                                                                          .isEmpty) {
                                                                        return 'กรุณาระบุบ กิจกรรมการจัดการความรู้';
                                                                      }
                                                                      buff.insert(
                                                                          5,
                                                                          input);
                                                                      return null;
                                                                    },
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(8),
                                                                  child:
                                                                      TextFormField(
                                                                    initialValue:
                                                                        apkuqaList[index]
                                                                            .periodOperated,
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .multiline,
                                                                    maxLines:
                                                                        null,
                                                                    minLines: 1,
                                                                    decoration:
                                                                        const InputDecoration(
                                                                      label: Text(
                                                                          'ระยะเวลาที่ดำเนินการ'),
                                                                      border:
                                                                          OutlineInputBorder(),
                                                                    ),
                                                                    validator:
                                                                        (input) {
                                                                      if (input!
                                                                          .isEmpty) {
                                                                        return 'กรุณาระบุบ ระยะเวลาที่ดำเนินการ';
                                                                      }
                                                                      buff.insert(
                                                                          6,
                                                                          input);
                                                                      return null;
                                                                    },
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(8),
                                                                  child:
                                                                      TextFormField(
                                                                    initialValue:
                                                                        apkuqaList[index]
                                                                            .budget,
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .multiline,
                                                                    maxLines:
                                                                        null,
                                                                    minLines: 1,
                                                                    decoration:
                                                                        const InputDecoration(
                                                                      label: Text(
                                                                          'งบประมาณ(ถ้ามี)'),
                                                                      border:
                                                                          OutlineInputBorder(),
                                                                    ),
                                                                    validator:
                                                                        (input) {
                                                                      if (input!
                                                                          .isEmpty) {
                                                                        return 'กรุณาระบุบ งบประมาณ(ถ้ามี)';
                                                                      }
                                                                      buff.insert(
                                                                          7,
                                                                          input);
                                                                      return null;
                                                                    },
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(8),
                                                                  child:
                                                                      TextFormField(
                                                                    initialValue:
                                                                        apkuqaList[index]
                                                                            .responsiblePerson,
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .multiline,
                                                                    maxLines:
                                                                        null,
                                                                    minLines: 1,
                                                                    decoration:
                                                                        const InputDecoration(
                                                                      label: Text(
                                                                          'ผู้รับผิดชอบหลัก'),
                                                                      border:
                                                                          OutlineInputBorder(),
                                                                    ),
                                                                    validator:
                                                                        (input) {
                                                                      if (input!
                                                                          .isEmpty) {
                                                                        return 'กรุณาระบุบ ผู้รับผิดชอบหลัก';
                                                                      }
                                                                      buff.insert(
                                                                          8,
                                                                          input);
                                                                      return null;
                                                                    },
                                                                  ),
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Container(
                                                                        margin:
                                                                            const EdgeInsets.all(10),
                                                                        child:
                                                                            OutlinedButton(
                                                                          child:
                                                                              const Text('บันทึก'),
                                                                          onPressed:
                                                                              () {
                                                                            var pass =
                                                                                _formKey2.currentState!.validate();
                                                                            if (pass) {
                                                                              setState(() {
                                                                                apkuqaList[index] = ApKuqs(target: buff[0], obligations: buff[1], objective: buff[2], output: buff[3], success_metrics: buff[4], knowledgeManagementActivities: buff[5], periodOperated: buff[6], budget: buff[7], responsiblePerson: buff[8]);
                                                                              });
                                                                              buff.clear();
                                                                              Navigator.pop(context);
                                                                            }
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                            IconButton(
                                              onPressed: () => showDialog<Text>(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title:
                                                        const Text('แจ้งเตือน'),
                                                    content:
                                                        const Text('ยืนยันลบ'),
                                                    actions: <Widget>[
                                                      TextButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              apkuqaList
                                                                  .removeAt(
                                                                      index);
                                                            });
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: const Text(
                                                              'ยืนยัน')),
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: const Text(
                                                              'ยกเลิก')),
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
                                        )),
                                      ]);
                                    }),
                                  )),
                            ),
                          ),
                          const Text('หมายเหตุ จากเจ้าหน้าที'),
                          const SizedBox(height: 10),
                          Container(
                            margin: const EdgeInsets.all(10),
                            child: Text(
                              asisComment,
                              maxLines: null,
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
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: TextColumnWidget(text: 'ลำดับ'),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: TextColumnWidget(
                                          text:
                                              'รายการสินทรัพย์ความรู้ที่จะได้รับจากการดำเนินการตามแผน ฯ'),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: TextColumnWidget(
                                          text:
                                              'แหล่งจัดเก็บและเผยแพร่สินทรัพย์ความรู้ '),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: TextColumnWidget(
                                          text:
                                              'แนวทางการนำสินทรัพย์ความรู้ไปใช้ให้เกิดประโยชน์สูงสุดต่อส่วนงาน'),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(),
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
                                                child: Text(apList[index]
                                                    .list_of_experiences),
                                              ),
                                              Expanded(
                                                flex: 5,
                                                child:
                                                    Text(apList[index].storage),
                                              ),
                                              Expanded(
                                                flex: 5,
                                                child: Text(
                                                    apList[index].guidelines),
                                              ),
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.edit,
                                                  color: Colors.black,
                                                ),
                                                onPressed: () async {
                                                  await showDialog<Widget>(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: const Text(
                                                            'แก้ไข การจัดการสินทรัพย์ความรู้ที่เกิดจากการดำเนินการตามแผน KM Action Plans เพื่อประโยชน์สูงสุดของส่วนงาน'),
                                                        content:
                                                            SingleChildScrollView(
                                                          child: Form(
                                                            key: _formKey3,
                                                            child: Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .all(10),
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(8),
                                                                    child:
                                                                        TextFormField(
                                                                      initialValue:
                                                                          apList[index]
                                                                              .list_of_experiences,
                                                                      keyboardType:
                                                                          TextInputType
                                                                              .multiline,
                                                                      maxLines:
                                                                          null,
                                                                      minLines:
                                                                          1,
                                                                      decoration:
                                                                          const InputDecoration(
                                                                        label: Text(
                                                                            'รายการสินทรัพย์ความรู้ที่จะได้รับจากการดำเนินการตามแผน ฯ'),
                                                                        border:
                                                                            OutlineInputBorder(),
                                                                      ),
                                                                      validator:
                                                                          (input) {
                                                                        if (input!
                                                                            .isEmpty) {
                                                                          return 'กรุณาระบุบ รายการสินทรัพย์ความรู้ที่จะได้รับจากการดำเนินการตามแผน ฯ';
                                                                        }
                                                                        buff.insert(
                                                                            0,
                                                                            input);
                                                                        return null;
                                                                      },
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(8),
                                                                    child:
                                                                        TextFormField(
                                                                      initialValue:
                                                                          apList[index]
                                                                              .storage,
                                                                      keyboardType:
                                                                          TextInputType
                                                                              .multiline,
                                                                      maxLines:
                                                                          null,
                                                                      minLines:
                                                                          1,
                                                                      decoration:
                                                                          const InputDecoration(
                                                                        label: Text(
                                                                            'แหล่งจัดเก็บและเผยแพร่สินทรัพย์ความรู้ '),
                                                                        border:
                                                                            OutlineInputBorder(),
                                                                      ),
                                                                      validator:
                                                                          (input) {
                                                                        if (input!
                                                                            .isEmpty) {
                                                                          return 'กรุณาระบุบ แหล่งจัดเก็บและเผยแพร่สินทรัพย์ความรู้ ';
                                                                        }
                                                                        buff.insert(
                                                                            1,
                                                                            input);
                                                                        return null;
                                                                      },
                                                                    ),
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Expanded(
                                                                        child:
                                                                            Container(
                                                                          margin:
                                                                              const EdgeInsets.all(10),
                                                                          child:
                                                                              OutlinedButton(
                                                                            child:
                                                                                const Text('บันทึก'),
                                                                            onPressed:
                                                                                () {
                                                                              var pass = _formKey3.currentState!.validate();
                                                                              if (pass) {
                                                                                setState(() {
                                                                                  apList[index] = Ap(list_of_experiences: buff[0], storage: buff[1], guidelines: buff[2]);
                                                                                });
                                                                                buff.clear();
                                                                                Navigator.pop(context);
                                                                              }
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                              IconButton(
                                                onPressed: () =>
                                                    showDialog<Text>(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                          'แจ้งเตือน'),
                                                      content: const Text(
                                                          'ยืนยันลบ'),
                                                      actions: <Widget>[
                                                        TextButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                apList.removeAt(
                                                                    index);
                                                              });
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                                'ยืนยัน')),
                                                        TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                                'ยกเลิก')),
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
                          const Text('หมายเหตุ จากเจ้าหน้าที'),
                          const SizedBox(height: 10),
                          Container(
                            margin: const EdgeInsets.all(10),
                            child: Text(
                              asisComment,
                              maxLines: null,
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
                                    child: const Text('ส่งรายงาน'),
                                    onPressed: () => showDialog<Text>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('แจ้งเตือน'),
                                          content:
                                              const Text('ยืนยัน การส่งรายงาน'),
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
                                                            UserDashboard(
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
              child: TextFormField(
                onChanged: (value) => tobe = value,
                initialValue: tobe,
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
            const Text('หมายเหตุ จากเจ้าหน้าที'),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.all(10),
              child: Text(
                tobeComment,
                maxLines: null,
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
}
