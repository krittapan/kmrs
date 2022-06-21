import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmrs/admin/widgets/widgets.dart';
import 'package:kmrs/app/app.dart';
import 'package:kmrs/footer/footer.dart';
import 'package:kmrs/model/userData.dart';

class AdminDashboard extends StatefulWidget {
  UserData userData;
  AdminDashboard({Key? key, required this.userData}) : super(key: key);

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  void setPageTitle(String title, BuildContext context) {
    SystemChrome.setApplicationSwitcherDescription(
      ApplicationSwitcherDescription(
        label: title,
        primaryColor:
            Theme.of(context).primaryColor.value, // This line is required
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    setPageTitle('เจ้าหน้าที่', context);
    return Scaffold(
      backgroundColor: const Color(0xffeff5f5),
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Image.asset(
            'ku_logo.png',
            color: Colors.white,
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(widget.userData.segmentNameTH),
          ],
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        backgroundColor: const Color(0xff006664),
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(7),
            child: ElevatedButton.icon(
              label: const Text('ออกจากระบบ',
                  style: TextStyle(color: Colors.black)),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white)),
              icon: const Icon(
                Icons.logout_outlined,
                color: Colors.red,
              ),
              onPressed: () async =>
                  context.read<AppBloc>().add(AppLogoutRequested()),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Align(
          alignment: const Alignment(0, -1 / 3),
          child: Column(
            children: <Widget>[
              const DataDashboard(),
              Card(
                margin: const EdgeInsets.all(20),
                elevation: 4,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Center(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const SizedBox(height: 20),
                        const Text('รายงานประจำปี 2565',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 22)),
                        DefaultTabController(
                          length: 3, // length of tabs
                          initialIndex: 0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Container(
                                child: const TabBar(
                                  labelColor: Colors.green,
                                  unselectedLabelColor: Colors.black,
                                  tabs: [
                                    Tab(text: 'รายงานแผน'),
                                    Tab(text: 'รายงานผล 6 เดือน'),
                                    Tab(text: 'รายงานผล 12 เดือน'),
                                  ],
                                ),
                              ),
                              Container(
                                height: 30,
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
                                      flex: 2,
                                      child: Text(
                                        'สถานะ',
                                        style: TextStyle(color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 600, //height of TabBarView
                                decoration: const BoxDecoration(
                                    border: Border(
                                        top: BorderSide(
                                            color: Colors.grey, width: 0.5))),
                                child: TabBarView(
                                  children: <Widget>[
                                    Container(
                                      child: SegmentList(
                                        userData: widget.userData,
                                        year: '1/2565',
                                      ),
                                    ),
                                    Container(
                                      child: SegmentList(
                                        userData: widget.userData,
                                        year: '2/2565',
                                      ),
                                    ),
                                    Container(
                                      child: SegmentList(
                                        userData: widget.userData,
                                        year: '3/2565',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
      bottomNavigationBar: const Footer(),
    );
  }
}
