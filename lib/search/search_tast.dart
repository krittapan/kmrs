import 'dart:js';

import 'package:flutter/material.dart';
import 'package:kmrs/app/app.dart';
import 'package:kmrs/buttom_app_bar/buttom_app_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchTast extends StatefulWidget {
  const SearchTast({Key? key}) : super(key: key);

  @override
  _SearchTastState createState() => _SearchTastState();
}

class _SearchTastState extends State<SearchTast> {
  late String search;
  late String str;
  final _formKey = GlobalKey<FormState>();
  final _form2Key = GlobalKey<FormState>();
  List<String> keywordList = [
    'สร้างสรรค์ภูมิปัญญา',
    'นวัตกรรม',
    'มั่นคง',
  ];
  List<String> keywordAwsList = [];

  void chackKeywordFunction() {
    keywordAwsList.clear();
    for (int i = 0; i < keywordList.length; i++) {
      RegExp exp = RegExp(
        keywordList[i],
        caseSensitive: false,
      );
      if (exp.hasMatch(str)) keywordAwsList.add(keywordList[i]);
    }
  }

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
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'กรุณาระบุบ';
                              }
                              return null;
                            },
                            onChanged: (value) => str = value.trim(),
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
                      children: [
                        const Text(
                          'keyword',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 110,
                          child: ListView.builder(
                            itemCount: keywordList.length,
                            itemBuilder: (context, index) {
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
                                                      keywordList
                                                          .removeAt(index);
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
                        Center(
                          child: Container(
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
                          'keyword ที่ตรวจพบ',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 110,
                          child: ListView.builder(
                            itemCount: keywordAwsList.length,
                            itemBuilder: (context, index) {
                              return Text(keywordAwsList[index]);
                            },
                          ),
                        ),
                        Center(
                          child: Container(
                            margin: const EdgeInsets.all(20),
                            child: OutlinedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  setState(
                                    () {
                                      chackKeywordFunction();
                                    },
                                  );
                                }
                              },
                              child: const Text('ตรวจสอบ'),
                            ),
                          ),
                        ),
                      ],
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
