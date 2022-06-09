import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmrs/admin_dashboard/admin_dashboard.dart';
import 'package:kmrs/app/app.dart';
import 'package:kmrs/model/userData.dart';
import 'package:kmrs/user_dashboard/user_dashboard.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: HomePage());

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  @override
  Widget build(BuildContext context) {
    final user = context.select((AppBloc bloc) => bloc.state.user);
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(user.id).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text('Document does not exist');
        }

        if (snapshot.connectionState == ConnectionState.done) {
          final userData = UserData.fromDocument(snapshot.requireData);
          switch (userData.type) {
            case 'user':
              return UserDashboard(
                userData: userData,
              );
            case 'admin':
              return AdminDashboard(userData: userData);
          }
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
