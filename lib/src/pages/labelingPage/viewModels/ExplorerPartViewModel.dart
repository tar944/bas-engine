import 'package:bas_dataset_generator_engine/src/controllers/regionRecController.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class ExplorerPartViewModel extends ViewModel {

  ObjectModel curObject;
  ValueSetter<String> onObjectActionCaller;
  bool isMine;
  bool isActive;
  RegionRecController controller;

  ExplorerPartViewModel(this.curObject,this.isMine, this.isActive,this.controller,this.onObjectActionCaller);


  @override
  void init() {
  }

}