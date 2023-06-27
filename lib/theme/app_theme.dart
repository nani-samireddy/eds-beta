import 'package:eds_beta/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData getAppTheme({required BuildContext context}) {
    return ThemeData.light().copyWith(
      useMaterial3: true,
      appBarTheme: const AppBarTheme(elevation: 0),
      scaffoldBackgroundColor: Pallete.backgroundColor,
      textTheme: GoogleFonts.nunitoSansTextTheme(Theme.of(context).textTheme),
    );
  }
}
