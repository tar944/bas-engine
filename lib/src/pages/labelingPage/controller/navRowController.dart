import 'package:bas_dataset_generator_engine/src/data/models/navModel.dart';
import 'package:fluent_ui/fluent_ui.dart';

class NavRowController extends ChangeNotifier {
  late List<NavModel> _allItems;
  late NavModel _selectedNav;
  late int _rowNumber;
  late bool _showBtn;

  List<NavModel> get allItems => _allItems;

  NavModel get selectedNav => _selectedNav;

  int get rowNumber => _rowNumber;

  bool get showBtn => _showBtn;

  visibleBtn(bool showIt){
    _showBtn=showIt;
    notifyListeners();
  }

  setAllItems(List<NavModel> allItems) {
    _allItems=allItems;
    notifyListeners(); // Notify listeners that the data has changed
  }

  setSelectedNav(NavModel nav){
    _selectedNav=nav;
    notifyListeners();
  }

  setRowNumber(int rowNum){
    _rowNumber=rowNum;
    notifyListeners();
  }
}