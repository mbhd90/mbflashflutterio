import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';

// final defaultTextTheme = TextTheme(
//   headline1: GoogleFonts.raleway(
//       fontSize: 88, fontWeight: FontWeight.w300, letterSpacing: -1.5),
//   headline2: GoogleFonts.raleway(
//       fontSize: 55, fontWeight: FontWeight.w300, letterSpacing: -0.5),
//   headline3: GoogleFonts.raleway(fontSize: 45, fontWeight: FontWeight.w400),
//   headline4: GoogleFonts.raleway(
//       fontSize: 32, fontWeight: FontWeight.w400, letterSpacing: 0.25),
//   headline5: GoogleFonts.raleway(fontSize: 23, fontWeight: FontWeight.w400),
//   headline6: GoogleFonts.raleway(
//       fontSize: 20, fontWeight: FontWeight.w700, letterSpacing: 0.15),
//   subtitle1: GoogleFonts.raleway(
//       fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15),
//   subtitle2: GoogleFonts.raleway(
//       fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
//   bodyText1: GoogleFonts.raleway(
//       fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
//   bodyText2: GoogleFonts.raleway(
//       fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
//   button: GoogleFonts.raleway(
//       fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 1.2),
//   caption: GoogleFonts.raleway(
//       fontSize: 13, fontWeight: FontWeight.w400, letterSpacing: 0.4),
//   overline: GoogleFonts.raleway(
//       fontSize: 11, fontWeight: FontWeight.w400, letterSpacing: 1.5),
// );

class MyTheme {
  static final borderRadius = BorderRadius.circular(0);
  static final theme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: Colors.white,
    // bottomSheetTheme: const BottomSheetThemeData(backgroundColor: primaryColor),
    colorScheme: const ColorScheme.light(secondary: lightningYellowColor),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      centerTitle: true,
      titleTextStyle: TextStyle(
          color: blackColor, fontSize: 20, fontWeight: FontWeight.bold),
      iconTheme: IconThemeData(color: blackColor),
      elevation: 0,
    ),
    textTheme: GoogleFonts.interTextTheme(
      const TextTheme(
        caption: TextStyle(fontSize: 12, height: 1.83),
        bodyText1:
            TextStyle(fontSize: 16, fontWeight: FontWeight.w500, height: 1.375),
        bodyText2: TextStyle(fontSize: 14, height: 1.5714),
        button: TextStyle(fontSize: 16, height: 2, fontWeight: FontWeight.w600),
        // titleLarge: const TextStyle(
        //     fontSize: 16, height: 2, fontWeight: FontWeight.w600),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 64), backgroundColor: lightningYellowColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      elevation: 3,
      backgroundColor: Color(0x00ffffff),
      selectedLabelStyle:
          TextStyle(color: lightningYellowColor, fontSize: 14.0),
      unselectedLabelStyle: TextStyle(color: paragraphColor, fontSize: 12.0),
      selectedItemColor: lightningYellowColor,
      unselectedItemColor: paragraphColor,
      showUnselectedLabels: true,
    ),
    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      hintStyle: TextStyle(color: grayColor),
      labelStyle: TextStyle(color: grayColor, fontSize: 16),
      border: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: const BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: const BorderSide(color: lightningYellowColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: const BorderSide(color: borderColor),
      ),
      fillColor: inputFieldBgColor,
      filled: true,
      focusColor: inputFieldBgColor,
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: blackColor,
      selectionColor: blackColor,
      selectionHandleColor: blackColor,
    ),
  );
}
