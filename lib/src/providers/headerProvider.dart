import 'package:flutter/material.dart';

class HeaderProvider extends ChangeNotifier {
  late String _guideText;

  String get guideText => _guideText;

  void updateGuide(String text) {
    _guideText=text;
    notifyListeners(); // Notify listeners that the data has changed
  }
}