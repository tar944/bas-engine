import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/src/data/preferences/preferencesData.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class ExportViewModel extends ViewModel {
  int curIndex=0;
  final pathController = TextEditingController();
  final domainController = TextEditingController();
  final tokenController = TextEditingController();
  final String prjName,prjUUID;
  bool needBackup=false;
  String exportPath="";
  final ValueSetter<String> onExportCaller;


  ExportViewModel(this.prjUUID,this.prjName,this.onExportCaller);

  onTabChanged(int index){
    curIndex=index;
    notifyListeners();
  }

  onExportBtnHandler()async{
    if(curIndex==0){
      await Preference().setExportPath(prjUUID, pathController.text.toString());
      onExportCaller("savePC");
    }else{
      await Preference().setUploadLink(prjUUID, domainController.text.toString());
      await Preference().setAuthToken(prjUUID, tokenController.text.toString());
      onExportCaller("saveInServer");
    }
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