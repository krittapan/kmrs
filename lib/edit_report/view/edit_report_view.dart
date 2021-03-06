import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kmrs/app/app.dart';
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
  late String tobeComment;
  late String asisComment;
  late String apkuqaComment;
  late String apComment;
  late String swotAsIs;
  late List<Asis> asisList = [];
  late List<ApKuqs> apkuqaList = [];
  late List<Ap> apList = [];
  bool isLodeing = true;

  Future getDoc() async {
    await FirebaseFirestore.instance
        .collection('reports')
        .doc(widget.reportId)
        .get()
        .then(
      (document) {
        if (document.exists) {
          setState(() {
            tobe = document['tobe'].toString();
            tobeComment = document['tobeComment'].toString();
            asisComment = document['asisComment'].toString();
            apkuqaComment = document['apkuqaComment'].toString();
            apComment = document['apComment'].toString();
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
      },
    ).whenComplete(() => isLodeing = false);
  }

  Future updateDoc() async {
    // Call the user's CollectionReference to add a new user
    return reports.doc(widget.reportId).update(
      {
        'status': '????????????????????????????????????????????????',
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
    final user = context.select((AppBloc bloc) => bloc.state.user);
    return Scaffold(
      backgroundColor: const Color(0xffeff5f5),
      appBar: AppBar(
        backgroundColor: const Color(0xff006664),
        title: const Text(
          '????????????????????????????????????????????????????????????????????????????????????????????????????????? ?????????????????????',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
        ),
      ),
      body: isLodeing == true
          ? const Center(
              child: CircularProgressIndicator(
                semanticsLabel: '??????????????????????????????',
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
                            '3. ????????????????????????????????????????????????????????????????????????????????? (As is)',
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
                                    // ignore: lines_longer_than_80_chars
                                    Expanded(
                                      flex: 5,
                                      child: TextTableWidget(
                                          text:
                                              '??????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????'),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: TextTableWidget(
                                          text:
                                              '?????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????'),
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
                                      child: TextTableWidget(
                                          text: '????????????????????? (Strengths)'),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: TextTableWidget(
                                          text: '????????????????????? (Weaknesses)'),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: TextTableWidget(
                                          text: '??????????????? (Opportunities)'),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: TextTableWidget(
                                          text: '????????????????????? (Threats)'),
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
                                                            '??????????????? ????????????????????????????????????????????????????????????????????????????????? (As is)'),
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
                                                                            '????????????????????? (Strengths)'),
                                                                        border:
                                                                            OutlineInputBorder(),
                                                                      ),
                                                                      validator:
                                                                          (input) {
                                                                        if (input!
                                                                            .isEmpty) {
                                                                          return '?????????????????????????????? ????????????????????? (Strengths)';
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
                                                                            '????????????????????? (Weaknesses)'),
                                                                        border:
                                                                            OutlineInputBorder(),
                                                                      ),
                                                                      validator:
                                                                          (input) {
                                                                        if (input!
                                                                            .isEmpty) {
                                                                          return '?????????????????????????????? ????????????????????? (Weaknesses)';
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
                                                                            '??????????????? (Opportunities)'),
                                                                        border:
                                                                            OutlineInputBorder(),
                                                                      ),
                                                                      validator:
                                                                          (input) {
                                                                        if (input!
                                                                            .isEmpty) {
                                                                          return '?????????????????????????????? ??????????????? (Opportunities)';
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
                                                                            '????????????????????? (Threats)'),
                                                                        border:
                                                                            OutlineInputBorder(),
                                                                      ),
                                                                      validator:
                                                                          (input) {
                                                                        if (input!
                                                                            .isEmpty) {
                                                                          return '?????????????????????????????? ????????????????????? (Threats)';
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
                                                                                const Text('??????????????????'),
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
                                                          '???????????????????????????'),
                                                      content: const Text(
                                                          '???????????????????????? SWOT'),
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
                                                                '??????????????????')),
                                                        TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                                '??????????????????')),
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
                                  '?????????????????????????????????????????????????????????????????????????????? SWOT (As is)',
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
                          const Text('???????????????????????? ???????????????????????????????????????'),
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
                            '4.  ????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????? ?????????????????????????????????????????????????????? KUQS ?????????????????????????????? ??????????????????????????????????????? (KM Action plans)',
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
                                      flex: 2,
                                      child: TextTableWidget(text: '???????????????'),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: TextTableWidget(
                                          text:
                                              '????????????????????????/????????????????????????????????????????????????????????????????????? '),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: TextTableWidget(
                                          text:
                                              '??????????????????????????????????????????????????????????????????????????? ?????????????????????????????????????????????????????? KUQS/?????????????????????'),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child:
                                          TextTableWidget(text: '????????????????????????????????????'),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: TextTableWidget(
                                          text:
                                              '??????????????????/????????????????????????????????????????????????????????????????????????(Output/Outcome)'),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: TextTableWidget(
                                          text: '?????????????????????????????????????????????????????????'),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: TextTableWidget(
                                          text: '????????????????????????????????????????????????????????????????????? '),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: TextTableWidget(
                                          text: '????????????????????????????????????????????????????????????'),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: TextTableWidget(
                                          text: '????????????????????????(???????????????)'),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: TextTableWidget(
                                          text: '????????????????????????????????????????????????'),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: Container(),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: apkuqaList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      margin: const EdgeInsets.all(5),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 3,
                                                child: Text(
                                                    (index + 1).toString()),
                                              ),
                                              Expanded(
                                                flex: 5,
                                                child: Text(
                                                    apkuqaList[index].target),
                                              ),
                                              Expanded(
                                                flex: 5,
                                                child: Text(apkuqaList[index]
                                                    .obligations),
                                              ),
                                              Expanded(
                                                flex: 5,
                                                child: Text(apkuqaList[index]
                                                    .objective),
                                              ),
                                              Expanded(
                                                flex: 5,
                                                child: Text(
                                                    apkuqaList[index].output),
                                              ),
                                              Expanded(
                                                flex: 5,
                                                child: Text(apkuqaList[index]
                                                    .success_metrics),
                                              ),
                                              Expanded(
                                                flex: 5,
                                                child: Text(apkuqaList[index]
                                                    .knowledgeManagementActivities),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Text(apkuqaList[index]
                                                    .periodOperated),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Text(
                                                    apkuqaList[index].budget),
                                              ),
                                              Expanded(
                                                flex: 5,
                                                child: Text(apkuqaList[index]
                                                    .responsiblePerson),
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
                                                            '????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????? ?????????????????????????????????????????????????????? KUQS ?????????????????????????????? ??????????????????????????????????????? (KM Action plans)'),
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
                                                                      minLines:
                                                                          1,
                                                                      decoration:
                                                                          const InputDecoration(
                                                                        label: Text(
                                                                            '????????????????????????/????????????????????????????????????????????????????????????????????? '),
                                                                        border:
                                                                            OutlineInputBorder(),
                                                                      ),
                                                                      validator:
                                                                          (input) {
                                                                        if (input!
                                                                            .isEmpty) {
                                                                          return '?????????????????????????????? ????????????????????????/????????????????????????????????????????????????????????????????????? ';
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
                                                                      minLines:
                                                                          1,
                                                                      decoration:
                                                                          const InputDecoration(
                                                                        label: Text(
                                                                            '??????????????????????????????????????????????????????????????????????????? ?????????????????????????????????????????????????????? KUQS/?????????????????????'),
                                                                        border:
                                                                            OutlineInputBorder(),
                                                                      ),
                                                                      validator:
                                                                          (input) {
                                                                        if (input!
                                                                            .isEmpty) {
                                                                          return '?????????????????????????????? ??????????????????????????????????????????????????????????????????????????? ?????????????????????????????????????????????????????? KUQS/?????????????????????';
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
                                                                      minLines:
                                                                          1,
                                                                      decoration:
                                                                          const InputDecoration(
                                                                        label: Text(
                                                                            '????????????????????????????????????'),
                                                                        border:
                                                                            OutlineInputBorder(),
                                                                      ),
                                                                      validator:
                                                                          (input) {
                                                                        if (input!
                                                                            .isEmpty) {
                                                                          return '?????????????????????????????? ????????????????????????????????????';
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
                                                                      minLines:
                                                                          1,
                                                                      decoration:
                                                                          const InputDecoration(
                                                                        label: Text(
                                                                            '??????????????????/????????????????????????????????????????????????????????????????????????(Output/Outcome)'),
                                                                        border:
                                                                            OutlineInputBorder(),
                                                                      ),
                                                                      validator:
                                                                          (input) {
                                                                        if (input!
                                                                            .isEmpty) {
                                                                          return '?????????????????????????????? ??????????????????/????????????????????????????????????????????????????????????????????????(Output/Outcome)';
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
                                                                      minLines:
                                                                          1,
                                                                      decoration:
                                                                          const InputDecoration(
                                                                        label: Text(
                                                                            '?????????????????????????????????????????????????????????'),
                                                                        border:
                                                                            OutlineInputBorder(),
                                                                      ),
                                                                      validator:
                                                                          (input) {
                                                                        if (input!
                                                                            .isEmpty) {
                                                                          return '?????????????????????????????? ?????????????????????????????????????????????????????????';
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
                                                                      minLines:
                                                                          1,
                                                                      decoration:
                                                                          const InputDecoration(
                                                                        label: Text(
                                                                            '?????????????????????????????????????????????????????????????????????'),
                                                                        border:
                                                                            OutlineInputBorder(),
                                                                      ),
                                                                      validator:
                                                                          (input) {
                                                                        if (input!
                                                                            .isEmpty) {
                                                                          return '?????????????????????????????? ?????????????????????????????????????????????????????????????????????';
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
                                                                      minLines:
                                                                          1,
                                                                      decoration:
                                                                          const InputDecoration(
                                                                        label: Text(
                                                                            '????????????????????????????????????????????????????????????'),
                                                                        border:
                                                                            OutlineInputBorder(),
                                                                      ),
                                                                      validator:
                                                                          (input) {
                                                                        if (input!
                                                                            .isEmpty) {
                                                                          return '?????????????????????????????? ????????????????????????????????????????????????????????????';
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
                                                                      minLines:
                                                                          1,
                                                                      decoration:
                                                                          const InputDecoration(
                                                                        label: Text(
                                                                            '????????????????????????(???????????????)'),
                                                                        border:
                                                                            OutlineInputBorder(),
                                                                      ),
                                                                      validator:
                                                                          (input) {
                                                                        if (input!
                                                                            .isEmpty) {
                                                                          return '?????????????????????????????? ????????????????????????(???????????????)';
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
                                                                      minLines:
                                                                          1,
                                                                      decoration:
                                                                          const InputDecoration(
                                                                        label: Text(
                                                                            '????????????????????????????????????????????????'),
                                                                        border:
                                                                            OutlineInputBorder(),
                                                                      ),
                                                                      validator:
                                                                          (input) {
                                                                        if (input!
                                                                            .isEmpty) {
                                                                          return '?????????????????????????????? ????????????????????????????????????????????????';
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
                                                                                const Text('??????????????????'),
                                                                            onPressed:
                                                                                () {
                                                                              var pass = _formKey2.currentState!.validate();
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
                                                onPressed: () =>
                                                    showDialog<Text>(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                          '???????????????????????????'),
                                                      content: const Text(
                                                          '????????????????????????'),
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
                                                                '??????????????????')),
                                                        TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                                '??????????????????')),
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
                          const Text('???????????????????????? ???????????????????????????????????????'),
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
                            '5. ??????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????? KM Action Plans ???????????????????????????????????????????????????????????????????????????????????????',
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
                                      child: TextTableWidget(text: '???????????????'),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: TextTableWidget(
                                          text:
                                              '?????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????? ???'),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: TextTableWidget(
                                          text:
                                              '?????????????????????????????????????????????????????????????????????????????????????????????????????????????????? '),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: TextTableWidget(
                                          text:
                                              '?????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????'),
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
                                                            '??????????????? ??????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????? KM Action Plans ???????????????????????????????????????????????????????????????????????????????????????'),
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
                                                                            '?????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????? ???'),
                                                                        border:
                                                                            OutlineInputBorder(),
                                                                      ),
                                                                      validator:
                                                                          (input) {
                                                                        if (input!
                                                                            .isEmpty) {
                                                                          return '?????????????????????????????? ?????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????? ???';
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
                                                                            '?????????????????????????????????????????????????????????????????????????????????????????????????????????????????? '),
                                                                        border:
                                                                            OutlineInputBorder(),
                                                                      ),
                                                                      validator:
                                                                          (input) {
                                                                        if (input!
                                                                            .isEmpty) {
                                                                          return '?????????????????????????????? ?????????????????????????????????????????????????????????????????????????????????????????????????????????????????? ';
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
                                                                                const Text('??????????????????'),
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
                                                          '???????????????????????????'),
                                                      content: const Text(
                                                          '????????????????????????'),
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
                                                                '??????????????????')),
                                                        TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                                '??????????????????')),
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
                          const Text('???????????????????????? ???????????????????????????????????????'),
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
                                    child: const Text('???????????????????????????'),
                                    onPressed: () => showDialog<Text>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('???????????????????????????'),
                                          content:
                                              const Text('?????????????????? ????????????????????????????????????'),
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
                                                child: const Text('??????????????????')),
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('??????????????????')),
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
              '2. ???????????????????????? ?????????????????????????????? ?????????????????????????????? ?????????????????????????????????????????????????????? KUQS ?????????????????????????????? / ???????????????????????? (To be)',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              '???????????????????????? ???????????????????????? ?????????????????????????????? ?????????????????????????????? ????????? KUQS ??????????????????????????????????????????????????????',
            ),
            const Text('???????????????????????? ????????????????????????????????? ????????? KUQS ?????????????????????????????????'),
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
            const Text('???????????????????????? ???????????????????????????????????????'),
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
    );
  }
}
