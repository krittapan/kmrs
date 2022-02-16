import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final theme = ThemeData(
  textTheme: GoogleFonts.openSansTextTheme(),
  primaryColorDark: const Color(0xFF0097A7),
  primaryColorLight: const Color(0xFF009688),
  primaryColor: const Color.fromRGBO(0, 102, 102, 1),
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF009688),
    secondary: Color.fromRGBO(0, 102, 102, 1),
  ),
  scaffoldBackgroundColor: Colors.white,
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
);
