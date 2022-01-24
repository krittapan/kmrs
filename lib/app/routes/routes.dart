import 'package:flutter/widgets.dart';
import 'package:kmrs/app/app.dart';
import 'package:kmrs/home/home.dart';
import 'package:kmrs/login/login.dart';

List<Page> onGenerateAppViewPages(AppStatus state, List<Page<dynamic>> pages) {
  switch (state) {
    case AppStatus.authenticated:
      return [HomePage.page()];
    case AppStatus.unauthenticated:
      return [LoginPage.page()];
    default:
      return [LoginPage.page()];
  }
}
