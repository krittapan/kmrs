import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmrs/app/app.dart';
import 'package:kmrs/buttom_app_bar/buttom_app_bar.dart';
import 'package:kmrs/keyword/keyword_setting.dart';
import 'package:kmrs/model/userData.dart';
import 'package:kmrs/search/search_tast.dart';

class AdminDashboard extends StatefulWidget {
  UserData userData;
  AdminDashboard({Key? key, required this.userData}) : super(key: key);

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text(
          widget.userData.organizationName,
          style: const TextStyle(color: Colors.black),
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
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'ประจำปี',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 10),
                            Text('1/2565'),
                          ],
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Card(
                            elevation: 4,
                            margin: const EdgeInsets.all(10),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            child: Container(
                              width: double.infinity,
                              color: Colors.grey[300],
                              child: Column(
                                children: [
                                  Container(
                                    height: 30,
                                    color: Colors.black,
                                    child: Row(
                                      children: const [
                                        SizedBox(width: 300),
                                        Text(
                                          'ขื่อหน่วยงาน',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        SizedBox(width: 400),
                                        Text(
                                          'สถานะ',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white)),
                          onPressed: () => Navigator.push<AppBloc>(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const SearchTast(),
                            ),
                          ),
                          icon: const Icon(
                            Icons.search,
                            color: Colors.black,
                          ),
                          label: const Text('ทดสอบระบบค้นหา คำ',
                              style: TextStyle(color: Colors.black)),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white)),
                          onPressed: () => Navigator.push<AppBloc>(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const SettingKeyword(),
                            ),
                          ),
                          icon: const Icon(
                            Icons.keyboard_control,
                            color: Colors.black,
                          ),
                          label: const Text('จัดการ คีย์เวิร์ด',
                              style: TextStyle(color: Colors.black)),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: const ButtomAppBar(),
    );
  }
}
