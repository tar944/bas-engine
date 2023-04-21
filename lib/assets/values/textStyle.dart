import 'dart:core';

import 'package:fluent_ui/fluent_ui.dart';

class TextSystem {
  static TextStyle textT(Color color) {
    return TextStyle(fontSize: 10, fontWeight: FontWeight.normal, color: color,);
  }

  static TextStyle textXs(Color color) {
    return TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: color);
  }

  static TextStyle textS(Color color) {
    return TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: color);
  }

  static TextStyle textM(Color color) {
    return TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: color);
  }

  static TextStyle textMB(Color color) {
    return TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color);
  }

  static  textL(Color color) {
    return TextStyle(fontSize: 18, fontWeight: FontWeight.normal, color: color);
  }

  static  textLB(Color color) {
    return TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color);
  }

  static TextStyle textXsBold(Color color) {
    return TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color);
  }

  static TextStyle subtitle2(Color color) {
    return TextStyle(fontSize: 20, fontWeight: FontWeight.normal, color: color);
  }

  static TextStyle subtitle3(Color color) {
    return TextStyle(fontSize: 18, fontWeight: FontWeight.normal, color: color);
  }
}
