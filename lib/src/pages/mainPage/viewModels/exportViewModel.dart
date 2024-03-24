import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class ExportViewModel extends ViewModel {
  int curIndex=0;
  final pathController = TextEditingController();
  final domainController = TextEditingController();
  final tokenController = TextEditingController();
  final String prjName;


  ExportViewModel(this.prjName);

  onTabChanged(int index){
    curIndex=index;
    notifyListeners();
  }

  void onCloseClicked() {
    Navigator.pop(context);
  }
}