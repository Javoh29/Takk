import 'package:flutter/material.dart';

abstract class AppColors {
  const AppColors._();

  static const Color accentColor = Color(0xFF00CE8D);
  static const Color scaffoldColor = Color(0xFFf8f8f8);
  static const Color deletedItemBorder = Color(0xFFF1A9A9);
  static const Color warningColor = Colors.orange;
  static const Color red = Colors.red;
  static const Color customGreen = Color(0x3500845A);
  static const Color secondaryGreen = Color(0xFF1EC892);


  
  static getPrimaryColor(int num) => Color(int.parse('0x${num}00845A'));

  static PrimaryColor primaryLight = const PrimaryColor(
    0xFF00845A,
    <int, Color>{
      100: Color(0xFF00845A),
      50: Color(0xFFF2FDF5),
    },
  );

  static BaseColor baseLight = BaseColor(
    0xFF16A249,
    <int, Color>{
      100: Colors.white,
      50: const Color(0xFFF4F4F4),
      80: Colors.white.withOpacity(.8),
      40: Colors.white.withOpacity(.4),
      20: Colors.white.withOpacity(.2),
      60: Colors.white.withOpacity(.6),
    },
  );

  static TextColor textColor = TextColor();
}

class BaseColor extends ColorSwatch<int> {
  const BaseColor(super.primary, super.swatch);

  Color get shade100 => this[100]!;

  Color get shade50 => this[50]!;

  Color get shade40 => this[40]!;

  Color get shade80 => this[80]!;

  Color get shade20 => this[20]!;

  Color get shade60 => this[60]!;
}

class PrimaryColor extends ColorSwatch<int> {
  const PrimaryColor(super.primary, super.swatch);

  Color get shade100 => this[100]!;

  Color get shade50 => this[50]!;
}

class TextColor extends ColorSwatch<int> {
  TextColor()
      : super(
          0xFF332f2e,
          <int, Color>{
            1: const Color(0xFF332f2e),
            2: const Color(0xFFADB4B9),
            3: const Color(0xffe8e8e8),
            54: Colors.black54,
            26: Colors.black26,
          },
        );

  Color get shade1 => this[1]!;
  Color get shade2 => this[2]!;
  Color get shade3 => this[3]!;
  Color get shade54 => this[54]!;
  Color get shade26 => this[26]!;
}
