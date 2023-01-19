// ignore_for_file: lines_longer_than_80_chars

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kmrs/admin/widgets/alert_dialog.dart';

class SystemStatus extends StatefulWidget {
  const SystemStatus({Key? key}) : super(key: key);
  @override
  State<SystemStatus> createState() => _SystemStatusState();
}

class _SystemStatusState extends State<SystemStatus> {
  TextEditingController yearController = TextEditingController();

  List<String> cycle = ['รอบ', '1', '2', '3'];
  String currentCycle = 'รอบ';
  CollectionReference systemStatus =
      FirebaseFirestore.instance.collection('systemStatus');

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    Future addDoc(String addYear, String addCycle) async {
      // Call the user's CollectionReference to add a new user
      return systemStatus.add({
        'createAt': FieldValue.serverTimestamp(),
        'cycle': addCycle,
        'year': addYear
      }).whenComplete(() {
        yearController.clear();
        currentCycle = 'รอบ';
        final snackBar = SnackBar(
          content: const Text('สำเร็จ'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.fromLTRB(0, 0, 0, size.height / 1.277),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        setState(() {});
      });
    }

    return Card(
      margin: const EdgeInsets.all(20),
      elevation: 4,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('สถานะของระบบ', style: TextStyle(fontSize: 22)),
              const SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 300,
                    child: TextField(
                      onChanged: (value) {
                        setState(() {});
                      },
                      maxLength: 4,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      controller: yearController,
                      decoration: const InputDecoration(
                        hintText: '2565',
                        border: OutlineInputBorder(),
                        labelText: 'กรอกปี',
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                    width: 100,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        alignment: Alignment.bottomRight,
                        isExpanded: true,
                        items:
                            cycle.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 20)),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            currentCycle = newValue!;
                          });
                        },
                        value: currentCycle,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: (currentCycle != 'รอบ' &&
                                yearController.value.text.length == 4)
                            ? null
                            : Colors.grey,
                      ),
                      onPressed: () async {
                        dynamic isconfirm;
                        if (yearController.value.text.length == 4 &&
                            currentCycle != 'รอบ') {
                          isconfirm = await confirmDialog(context,
                              'คุณต้องการเปลี่ยนรอบของระบบเป็น รอบ $currentCycle ปี ${yearController.value.text}');
                          if (isconfirm == 'true') {
                            await addDoc(
                                yearController.value.text, currentCycle);
                          }
                        }
                      },
                      child: const Text(
                        'ยืนยัน',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
