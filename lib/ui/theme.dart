import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

const Color bluishClr = Color.fromARGB(188, 78, 140, 232);
const Color yellowClr = Color(0xFFFFB746);
const primaryClr = bluishClr;
const darkGreyClr = Color.fromARGB(255, 66, 66, 66);

class Themes {
  static final light = ThemeData.light().copyWith(
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
    ),
    primaryColor: primaryClr,
    brightness: Brightness.light,
  );

  static final dark = ThemeData.dark().copyWith(
    appBarTheme: const AppBarTheme(
      backgroundColor: darkGreyClr,
    ),
    primaryColor: darkGreyClr,
    brightness: Brightness.dark,
  );
}

TextStyle get subHeadingStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Get.isDarkMode ? Colors.grey[500] : Colors.grey));
}

TextStyle get headingStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.bold));
}
