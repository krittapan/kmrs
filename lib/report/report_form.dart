import 'package:flutter/material.dart';
import 'package:kmrs/buttom_app_bar/buttom_app_bar.dart';
import 'package:kmrs/model/as_is.dart';
import 'package:kmrs/model/userData.dart';

class ReportForm extends StatefulWidget {
  UserData userData;
  ReportForm({Key? key, required this.userData}) : super(key: key);

  @override
  _ReportFormState createState() => _ReportFormState();
}

class _ReportFormState extends State<ReportForm> {
  List<Asis> asisList = <Asis>[
    Asis(
        strengths:
            'S1 – มีหลักสูตรและบุคลากรที่มีความสามารถด้านเทคโนโลยีดิจิทัลเป็นที่ต้องการของตลาดแรงงาน สอดคล้องกับการพัฒนาประเทศ',
        weaknesses:
            'W1 – ความรู้ ทักษะ ที่ใช้ในการเรียนการสอนขาดการรับรองจากมาตรฐานในระดับสากล ไม่อยู่ในระดับที่อุสาหกรรมคาดหวัง (Demand Driven for EEC)',
        opportunities:
            'O1 – ความต้องการทักษะระดับสากลของเขตพัฒนาพิเศษภาคตะวันออก (EEC) ตามแผนยุทธศาสตร์ภายใต้ไทยแลนด์ 4.0 ',
        threatsl:
            'T1 – คู่แข่งขันที่มีหลักสูตรในลักษณะเดียวกันมีจำนวนมาก (หลักสูตรเดิมของคณะฯ) เกิดสภาพการแย่งชิงผู้เรียนที่รุนแรง'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: const Text(
          'รายงานแผนการจัดการความรู้ของส่วนงาน ประจำปี',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 26),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            organizationName(widget.userData.organizationName),
            toBe(),
            Card(
              margin: const EdgeInsets.all(10),
              elevation: 4,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              child: Container(
                margin: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: const [
                        Text(
                          '3. การวิเคราะห์ตนเองของส่วนงาน (As is)',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              TextTableWidget(
                                  text:
                                      'ปัจจัยภายในที่สนับสนุนและอุปสรรคที่มีผลต่อการจัดการความรู้ให้สำเร็จตามเป้าหมาย'),
                              const SizedBox(width: 30),
                              TextTableWidget(
                                  text:
                                      'ปัจจัยภายนอกที่สนับสนุนและอุปสรรคที่มีผลต่อการจัดการความรู้ให้สำเร็จตามเป้าหมาย'),
                            ],
                          ),
                          const Divider(),
                          DataTable(
                            columns: [
                              DataColumn(
                                label: TextTableWidget(
                                    text: 'จุดแข็ง (Strengths)'),
                              ),
                              DataColumn(
                                label: TextTableWidget(
                                    text: 'จุดอ่อน (Weaknesses)'),
                              ),
                              DataColumn(
                                label: TextTableWidget(
                                    text: 'โอกาส (Opportunities)'),
                              ),
                              DataColumn(
                                label:
                                    TextTableWidget(text: 'อุปสรรค (Threats)'),
                              ),
                            ],
                            rows: asisList
                                .map(
                                  (asis) => DataRow(
                                    cells: [
                                      DataCell(
                                        TextTableWidget(text: asis.strengths),
                                      ),
                                      DataCell(
                                        TextTableWidget(text: asis.weaknesses),
                                      ),
                                      DataCell(
                                        TextTableWidget(
                                            text: asis.opportunities),
                                      ),
                                      DataCell(
                                        TextTableWidget(text: asis.threatsl),
                                      ),
                                    ],
                                  ),
                                )
                                .toList(),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const ButtomAppBar(),
    );
  }

  Card toBe() {
    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 4,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(5),
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
    );
  }

  Card organizationName(String organizationName) {
    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 4,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.all(20),
        child: Row(
          children: [
            const Text(
              '1. หน่วยงาน',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(width: 10),
            Text(organizationName),
          ],
        ),
      ),
    );
  }
}

class TextTableWidget extends StatelessWidget {
  String text;
  TextTableWidget({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(text, textAlign: TextAlign.center),
    );
  }
}
