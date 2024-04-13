import 'package:bas_dataset_generator_engine/src/controllers/regionRecController.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class ExplorerPartViewModel extends ViewModel {

  final ObjectModel curObject,mainObject;
  final ValueSetter<String> onObjectActionCaller;
  final bool isMine,isMinimum;
  final bool isSimpleAction;
  final RegionRecController controller;

  ExplorerPartViewModel(this.curObject,this.mainObject,this.isMine,this.isMinimum,this.isSimpleAction, this.controller,this.onObjectActionCaller);
}