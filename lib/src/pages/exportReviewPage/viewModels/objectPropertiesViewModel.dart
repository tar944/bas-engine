
import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/src/data/models/pascalObjectModel.dart';
import 'package:bas_dataset_generator_engine/src/dialogs/toast.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class ObjectPropertiesViewModel extends ViewModel {

  final PascalObjectModel object;
  final ValueSetter<String> onActionCaller;
  List<String> nameParts=[];
  List<String> exportParts=[];
  ObjectPropertiesViewModel(this.object, this.onActionCaller);


  @override
  void init() {
    nameParts= object.name!.split("**");
    exportParts=object.exportName!.split("**");
    notifyListeners();
  }

  void onCloseClicked() {
    Navigator.pop(context);
  }

  onNamePartSelected(List<String> allSelected, String curName) {
    if (exportParts.contains(curName)){
      exportParts.removeWhere((element) => element==curName);
    }else{
      exportParts.add(curName);
    }
    notifyListeners();
  }

  onBtnDeleteHandler(){
    onActionCaller("delete&&${object.objUUID}&&${object.lvlKind}");
    onCloseClicked();
  }

  void onBtnConfirmListener() {
    var finalName="";
    for(int i=exportParts.length-1;i>=0;i--){
      finalName +="${exportParts[i]}**";
    }
    if(object.lvlKind=="objects"){
      Toast(Strings.objectWarn, false).showWarning(context);
    }else{
      onActionCaller("confirm&&${object.objUUID}&&$finalName");
    }
    onCloseClicked();
  }
}