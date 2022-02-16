import 'dart:html';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmrs/app/app.dart';
import 'package:kmrs/buttom_app_bar/buttom_app_bar.dart';

class ReportForm extends StatefulWidget {
  Map<String, dynamic> userData;
  ReportForm({Key? key, required this.userData}) : super(key: key);

  @override
  State<ReportForm> createState() => _ReportFormState();
}

class _ReportFormState extends State<ReportForm> {
  CollectionReference _reportCollection =
      FirebaseFirestore.instance.collection('reposts');
  List<String> as_isList = [];
  List<String> as_is_supList = [];
  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  List<String> formlist = [];

  @override
  Widget build(BuildContext context) {
    final user = context.select((AppBloc bloc) => bloc.state.user);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: const Text(
          'รายงานแผนการจัดการความรู้ของส่วนงาน ประจำปีงบประมาณ 2565',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 26),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Card(
                margin: const EdgeInsets.all(10),
                elevation: 4,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                child: Center(
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
                        Container(
                          margin: const EdgeInsets.all(10),
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
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                margin: const EdgeInsets.all(10),
                elevation: 4,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                child: Center(
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
                            children: [
                              Table(
                                border: TableBorder.all(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    topRight: Radius.circular(5),
                                  ),
                                ),
                                children: const [
                                  TableRow(
                                    children: [
                                      TableCell(
                                        child: Center(
                                          child: Text(
                                              'ปัจจัยภายในที่สนับสนุนและอุปสรรคที่มีผลต่อการจัดการความรู้ให้สำเร็จตามเป้าหมาย'),
                                        ),
                                      ),
                                      TableCell(
                                        child: Center(
                                          child: Text(
                                              'ปัจจัยภายนอกที่สนับสนุนและอุปสรรคที่มีผลต่อการจัดการความรู้ให้สำเร็จตามเป้าหมาย'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Table(
                                border: const TableBorder(
                                  left: BorderSide(),
                                  right: BorderSide(),
                                  verticalInside: BorderSide(),
                                  bottom: BorderSide(),
                                ),
                                children: const [
                                  TableRow(
                                    children: [
                                      Center(
                                        child: Text('จุดแข็ง (Strengths)'),
                                      ),
                                      Center(
                                        child: Text('จุดอ่อน (Weaknesses)'),
                                      ),
                                      Center(
                                        child: Text('โอกาส (Opportunities)'),
                                      ),
                                      Center(
                                        child: Text('อุปสรรค (Threats)'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Form(
                          key: _formKey1,
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    child: const TextField(
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                      minLines: 1,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: const TextField(
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                      minLines: 1,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: const TextField(
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                      minLines: 1,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: const TextField(
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                      minLines: 1,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Container(
                            margin: const EdgeInsets.all(20),
                            child: OutlinedButton(
                              onPressed: () {},
                              child: const Text('เพิ่ม'),
                            ),
                          ),
                        ),
                        Row(
                          children: const [
                            SizedBox(width: 10),
                            Text(
                              'ผลสรุปการวิเคราะห์ตนเองจาก SWOT (As is)',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.all(10),
                          child: TextFormField(
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            minLines: 1,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                margin: const EdgeInsets.all(10),
                elevation: 4,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                child: Center(
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
                        Container(
                          margin: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Table(
                                border: TableBorder.all(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    topRight: Radius.circular(5),
                                  ),
                                ),
                                children: const [
                                  TableRow(
                                    children: [
                                      TableCell(
                                        child: Center(
                                          child: Text('ลำดับ'),
                                        ),
                                      ),
                                      TableCell(
                                        child: Center(
                                          child: Text(
                                              'เป้าหมาย/ประเด็นการจัดการความรู้'),
                                        ),
                                      ),
                                      TableCell(
                                        child: Center(
                                          child: Text('วัตถุประสงค์'),
                                        ),
                                      ),
                                      TableCell(
                                        child: Center(
                                          child: Text(
                                              'ผลผลิต/ผลลัพธ์ที่คาดว่าจะได้รับ(Output/Outcome)'),
                                        ),
                                      ),
                                      TableCell(
                                        child: Center(
                                          child: Text('ตัวชี้วัดความสำเร็จ'),
                                        ),
                                      ),
                                      TableCell(
                                        child: Center(
                                          child:
                                              Text('กิจกรรมการจัดการความรู้'),
                                        ),
                                      ),
                                      TableCell(
                                        child: Center(
                                          child: Text('ระยะเวลาที่ดำเนินการ'),
                                        ),
                                      ),
                                      TableCell(
                                        child: Center(
                                          child: Text('งบประมาณ(ถ้ามี)'),
                                        ),
                                      ),
                                      TableCell(
                                        child: Center(
                                          child: Text('ผู้รับผิดชอบหลัก'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  child: const TextField(
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    minLines: 1,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: const TextField(
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    minLines: 1,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: const TextField(
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    minLines: 1,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: const TextField(
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    minLines: 1,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: const TextField(
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    minLines: 1,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: const TextField(
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    minLines: 1,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: const TextField(
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    minLines: 1,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: const TextField(
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    minLines: 1,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: const TextField(
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    minLines: 1,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Center(
                          child: Container(
                            margin: const EdgeInsets.all(20),
                            child: OutlinedButton(
                              onPressed: () {},
                              child: const Text('เพิ่ม'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                margin: const EdgeInsets.all(10),
                elevation: 4,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                child: Center(
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
                            children: [
                              Table(
                                border: TableBorder.all(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    topRight: Radius.circular(5),
                                  ),
                                ),
                                children: const [
                                  TableRow(
                                    children: [
                                      TableCell(
                                        child: Center(
                                          child: Text('ลำดับ'),
                                        ),
                                      ),
                                      TableCell(
                                        child: Center(
                                          child: Text(
                                              'รายการสินทรัพย์ความรู้ที่จะได้รับจากการดำเนินการตามแผน ฯ'),
                                        ),
                                      ),
                                      TableCell(
                                        child: Center(
                                          child: Text(
                                              'แหล่งจัดเก็บและเผยแพร่สินทรัพย์ความรู้'),
                                        ),
                                      ),
                                      TableCell(
                                        child: Center(
                                          child: Text(
                                              'แนวทางการนำสินทรัพย์ความรู้ไปใช้ให้เกิดประโยชน์สูงสุดต่อส่วนงาน'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                margin: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        child: const TextField(
                                          keyboardType: TextInputType.multiline,
                                          maxLines: null,
                                          minLines: 1,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: const TextField(
                                          keyboardType: TextInputType.multiline,
                                          maxLines: null,
                                          minLines: 1,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: const TextField(
                                          keyboardType: TextInputType.multiline,
                                          maxLines: null,
                                          minLines: 1,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: const TextField(
                                          keyboardType: TextInputType.multiline,
                                          maxLines: null,
                                          minLines: 1,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Center(
                          child: Container(
                            margin: const EdgeInsets.all(20),
                            child: OutlinedButton(
                              onPressed: () {},
                              child: const Text('เพิ่ม'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                margin: const EdgeInsets.all(10),
                elevation: 4,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    child: OutlinedButton(
                      onPressed: () {},
                      child: const Text('ส่งรายงาน'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const ButtomAppBar(),
    );
  }
}
