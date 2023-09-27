import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/theme.dart';

class AppStyles {
  static TextStyle sectionSubheading = TextStyle(
      color: Pallete.black,
      fontSize: 16,
      fontWeight: FontWeight.w900,
      fontFamily: GoogleFonts.dmSans().fontFamily);

  static TextStyle sectionHeading = TextStyle(
      fontSize: 18,
      fontFamily: GoogleFonts.dmSans().fontFamily,
      fontWeight: FontWeight.w600);

  static TextStyle paragraph1 = TextStyle(
      fontSize: 16,
      fontFamily: GoogleFonts.poppins().fontFamily,
      fontWeight: FontWeight.w400);

  static TextStyle paragraph2 = TextStyle(
      fontSize: 18,
      fontFamily: GoogleFonts.poppins().fontFamily,
      fontWeight: FontWeight.w400);
}
