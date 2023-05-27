import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

//my color palette
//https://coolors.co/palette/0b090a-161a1d-660708-a4161a-ba181b-e5383b-b1a7a6-d3d3d3-f5f3f4-ffffff

class Themes {
  static ThemeData lightTheme = FlexThemeData.light(
    primary: const Color(0xff660708), // Blood Red
    background: const Color(0xffD3D3D3), //Timberwolf
    secondary: const Color(0xffA4161A), // Cornell Red
    scaffoldBackground: const Color(0xffD3D3D3), // Isabelline
    appBarBackground: const Color(0xff660708), // Blood Red
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        color: Colors.black,
      ),
      bodyMedium: TextStyle(
        color: Colors.black,
      ),
      bodySmall: TextStyle(
        color: Colors.black,
      ),
    ),
  );

  static ThemeData darkTheme = FlexThemeData.dark(
    primary: const Color(0xff660708), // Blood Red
    background: const Color(0xff161A1D), //Eerie Black
    secondary: const Color(0xffA4161A), // Cornell Red
    scaffoldBackground: const Color(0xff161A1D), //Eerie Black
    appBarBackground: const Color(0xff660708), // Blood Red
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        color: Colors.white,
      ),
      bodyMedium: TextStyle(
        color: Colors.white,
      ),
      bodySmall: TextStyle(
        color: Colors.white,
      ),
    ),
  );
}
