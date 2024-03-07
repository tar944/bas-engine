import 'package:fluent_ui/fluent_ui.dart';

class RegionRecController extends ChangeNotifier {
  late int _activeID=-1;

  int get activeID => _activeID;

  void setActiveID(int activeID) {
    _activeID=activeID;
    print("activeId is => $activeID");
    notifyListeners(); // Notify listeners that the data has changed
  }
}