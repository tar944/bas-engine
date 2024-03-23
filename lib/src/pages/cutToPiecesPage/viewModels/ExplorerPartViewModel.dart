import 'package:bas_dataset_generator_engine/src/controllers/regionRecController.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class ExplorerPartViewModel extends ViewModel {

  ObjectModel curObject,mainObject;
  ValueSetter<String> onObjectActionCaller;
  bool isMine;
  bool isSimpleAction;
  bool isMaximize=true;
  RegionRecController controller;

  ExplorerPartViewModel(this.curObject,this.mainObject,this.isMine,this.isSimpleAction, this.controller,this.onObjectActionCaller);

  onShowHandler()async{
    isMaximize= !isMaximize;
    notifyListeners();
  }
}