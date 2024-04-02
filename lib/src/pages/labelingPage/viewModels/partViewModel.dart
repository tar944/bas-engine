import 'package:bas_dataset_generator_engine/src/controllers/regionRecController.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class PartViewModel extends ViewModel {

  ObjectModel curObject;
  ValueSetter<String> onObjectActionCaller;
  bool isMaximize=true;

  PartViewModel(this.curObject,this.onObjectActionCaller);

  onShowHandler()async{
    isMaximize= !isMaximize;
    notifyListeners();
  }
}