import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class ExportViewModel extends ViewModel {
  int curIndex=0;
  final pathController = TextEditingController();
  final domainController = TextEditingController();
  final tokenController = TextEditingController();
  final String prjName;
  bool needBackup=false;
  String exportPath="";


  ExportViewModel(this.prjName);

  onTabChanged(int index){
    curIndex=index;
    notifyListeners();
  }

  saveInPcHandler(String action)async{
    switch(action){
      case "backupOn":
        needBackup = true;
        notifyListeners();
        break;
      case "backupOff":
        needBackup=false;
        notifyListeners();
        break;
      case "chosePath":
        String? result = await FilePicker.platform.getDirectoryPath(dialogTitle: Strings.dirPath);
        if (result != null) {
          print(result);
          exportPath=result;
          pathController.text=exportPath;
          notifyListeners();
        }
        break;
    }
  }

  void onCloseClicked() {
    Navigator.pop(context);
  }
}