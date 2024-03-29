import 'package:fluent_ui/fluent_ui.dart';

class HeaderController extends ChangeNotifier {
  late String _guideText="";

  String get guideText => _guideText;

  void updateGuide(String text) {
    _guideText=text;
    notifyListeners(); // Notify listeners that the data has changed
  }
}