import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/src/controllers/regionRecController.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/pascalObjectModel.dart';
import 'package:bas_dataset_generator_engine/src/utility/enum.dart';
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
    exportParts=allSelected;
    notifyListeners();
  }

  void onBtnConfirmListener() {
    var finalName="";
    for(var str in exportParts){
      finalName +="**$str";
    }
    onActionCaller("confirm&&$finalName");
    onCloseClicked();
  }
}