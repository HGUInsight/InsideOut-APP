import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';

class Style {
  static ThemeData lightThemeData = themeData();

  static ThemeData themeData() {
    final base = ThemeData.light();
    return base.copyWith(
      textTheme: _buildTextTheme(base.textTheme),
    );
  }

  static TextTheme _buildTextTheme(TextTheme base) {
    return base.copyWith(
        titleLarge: GoogleFonts.robotoSlab(textStyle: base.titleLarge),
        bodyMedium: GoogleFonts.nanumGothic(textStyle: base.bodyMedium));
  }
}

class MyTextStyles {
  static const TextStyle miniTextStyle =
  TextStyle(fontSize: 15, fontWeight: FontWeight.bold,
      color: ColorStyle.mainColor1
    // Additional style options can be set here
    // Example: fontWeight: FontWeight.bold, color: Colors.black
  );
  static const TextStyle titleTextStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold
          // Additional style options can be set here
          // Example: fontWeight: FontWeight.bold, color: Colors.black
          );
  static const TextStyle subtitleTextStyle =
  TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
    color: ColorStyle.mainColor1
    // Additional style options can be set here
    // Example: fontWeight: FontWeight.bold, color: Colors.black
  );
  static const TextStyle buttonTextStyle = TextStyle(color: Color(0xffFFFFFF));
  static const TextStyle selectTextStyle =
      TextStyle(color: Colors.black, fontSize: 15);
  static const TextStyle selectedTextStyle =
      TextStyle(color: Color(0xffFFFFFF), fontSize: 15);
  static const TextStyle smallTitleTextStyle =
      TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold);
}

class BoxDecorationStyle {
  static BoxDecoration graphBox1 = BoxDecoration(
      color: Color(0xffFFFFFF),
      borderRadius: BorderRadius.all(Radius.circular(10)),
      border: Border.all(width: 1, color: Colors.black));
  static BoxDecoration graphBox2 = BoxDecoration(
      color: Color(0xffFFFFFF),
      borderRadius: BorderRadius.all(Radius.circular(10)),
      border: Border.all(width: 0.5, color: Colors.grey));
}

class ColorStyle {
  static const Color mainColor1 = Color(0xff689BB0);
  static const Color mainColor2 = Color(0xffBCDDE1);
  static const Color mainColor3 = Color(0xffECF1F2);
  static const Color bgColor1 = Color(0xffF7F4F2);
  static const Color bgColor2 = Color(0xffFFFFFF);
  static const Color impactColor1 = Color(0xff9BB168);
  static const Color impactColor2 = Color(0xffF6C34C);
  static const Color impactColor3 = Color(0xffFF8E9D);
  static const Color impactColor4 = Color(0xffED8D1C);
  static const Color impactColor5 = Color(0xffA694F5);
}
