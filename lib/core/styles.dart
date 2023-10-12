import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/theme.dart';

class AppStyles {
  static TextStyle heading1 = TextStyle(
      fontSize: 32,
      fontFamily: GoogleFonts.poppins().fontFamily,
      fontWeight: FontWeight.w800);
  static TextStyle sectionSubheading = TextStyle(
      color: Pallete.black,
      fontSize: 16,
      fontWeight: FontWeight.w900,
      fontFamily: GoogleFonts.poppins().fontFamily);

  static TextStyle sectionHeading = TextStyle(
    fontSize: 20,
    color: const Color.fromARGB(255, 52, 51, 51),
    fontFamily: GoogleFonts.poppins(fontWeight: FontWeight.w700).fontFamily,
  );

  static TextStyle paragraph1 = TextStyle(
      fontSize: 16,
      fontFamily: GoogleFonts.poppins().fontFamily,
      fontWeight: FontWeight.w400);

  static TextStyle paragraph2 = TextStyle(
      fontSize: 18,
      fontFamily: GoogleFonts.poppins().fontFamily,
      fontWeight: FontWeight.w400);
}
