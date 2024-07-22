import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/src/dialogs/toast.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class ExportObjectsViewModel extends ViewModel {

  final List<String> objNames;
  var exportNames =<String>[];
  ValueSetter<List<String>> onObjectSelectCaller;

  ExportObjectsViewModel(this.objNames,this.onObjectSelectCaller);

  onSelectNameHandler(String name){
    if(exportNames.contains(name)){
      exportNames.removeWhere((element) => element==name);
    }else{
      exportNames.add(name);
    }
    notifyListeners();
  }

  void onCloseClicked() {
    Navigator.pop(context);
  }

  void onNextLevelHandler(){
    if(exportNames.isEmpty){
      Toast(Strings.errEmptyName, false).showError(context);
    }else{
      onObjectSelectCaller(exportNames);
      onCloseClicked();
    }
  }
}