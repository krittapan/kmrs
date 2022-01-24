import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmrs/app/app.dart';
import 'package:kmrs/home/home.dart';
import 'package:kmrs/theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: HomePage());

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final user = context.select((AppBloc bloc) => bloc.state.user);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        title: const Text('Home'),
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
      body: Align(
        alignment: const Alignment(0, -1 / 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Avatar(photo: user.photo),
            const SizedBox(height: 4),
            Text(user.email ?? '', style: textTheme.headline6),
            const SizedBox(height: 4),
            Text(user.name ?? '', style: textTheme.headline5),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}
