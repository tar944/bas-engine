import 'package:fluent_ui/fluent_ui.dart';

class RegionRecController extends ChangeNotifier {
  late bool _isHover=false;

  bool get isHover => _isHover;

  void setHover(bool isHover) {
    _isHover=isHover;
    notifyListeners(); // Notify listeners that the data has changed
  }
}