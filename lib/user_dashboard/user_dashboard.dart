import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmrs/app/app.dart';
import 'package:kmrs/buttom_app_bar/buttom_app_bar.dart';
import 'package:kmrs/model/userData.dart';
import 'package:kmrs/report/report_form.dart';
import 'package:kmrs/search/search_tast.dart';
import 'package:kmrs/user_dashboard/widgets/organizationname_widget.dart';

class UserDashboard extends StatefulWidget {
  UserData userData;
  UserDashboard({Key? key, required this.userData}) : super(key: key);

  @override
  _UserDashboardState createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  bool isDoc = false;
  late String isStaus;

  @override
  void initState() {
    super.initState();
    checkIfdocOrNot(widget.userData.organizationName);
  }

  Future checkIfdocOrNot(String organizationName) async {
    CollectionReference docRef =
        FirebaseFirestore.instance.collection('reports');
    DocumentSnapshot ds =
        await docRef.doc('2565').collection('1').doc(organizationName).get();
    Map<String, dynamic> data = ds.data() as Map<String, dynamic>;
    if (data['isDoc'] == true) {
      setState(() {
        isDoc = true;
      });
    } else {
      setState(() {
        isDoc = false;
      });
    }
    isStaus = data['staus'].toString();
    print(data['isDoc']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: const Text(
          'KMRS',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          ElevatedButton.icon(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.white)),
            onPressed: () async =>
                context.read<AppBloc>().add(AppLogoutRequested()),
            icon: const Icon(
              Icons.logout_outlined,
              color: Colors.red,
            ),
            label:
                const Text('ออกจากระบบ', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Align(
          alignment: const Alignment(0, -1 / 3),
          child: Column(
            children: <Widget>[
              OrganizationNameCard(
                  organizationName: widget.userData.organizationName),
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
                    margin: const EdgeInsets.all(30),
                    child: Container(
                      height: 300,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Text('ไม่พบข้อมูล'),
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Card(
                      margin: const EdgeInsets.all(10),
                      elevation: 4,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      child: Center(
                        child: Container(
                          margin: const EdgeInsets.all(30),
                          child: Column(
                            children: [
                              const Text('รายงานระดับมหาลัย'),
                              const SizedBox(height: 20),
                              Container(
                                height: 300,
                                color: Colors.grey[300],
                                child: const Center(
                                  child: Text('ไม่พบข้อมูล'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Card(
                      margin: const EdgeInsets.all(10),
                      elevation: 4,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      child: Center(
                        child: Container(
                          margin: const EdgeInsets.all(30),
                          child: Column(
                            children: [
                              Row(
                                children: const [
                                  Text('รายงานหน่วยงานประจำปีของหน่วยงาน'),
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 4,
                                    child: Card(
                                      elevation: 4,
                                      margin: const EdgeInsets.all(10),
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                      ),
                                      child: Container(
                                        height: 300,
                                        color: Colors.grey[300],
                                        child: const Center(
                                          child: Text('ไม่พบข้อมูล'),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          const Text('สถานะ'),
                                          const SizedBox(width: 10),
                                          Text(isStaus),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      ElevatedButton.icon(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.white)),
                                        onPressed: () => isDoc
                                            ? null
                                            : Navigator.push<AppBloc>(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          ReportForm(
                                                    userData: widget.userData,
                                                  ),
                                                ),
                                              ),
                                        icon: const Icon(
                                          Icons.description,
                                          color: Colors.black,
                                        ),
                                        label: isDoc
                                            ? const Text(
                                                'แก้ไขรายงานแผนประจำปี',
                                                style: TextStyle(
                                                    color: Colors.black),
                                              )
                                            : const Text(
                                                'รายงานแผนประจำปี',
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
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
      bottomNavigationBar: const ButtomAppBar(),
    );
  }
}
