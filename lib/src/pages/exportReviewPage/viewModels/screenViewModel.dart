import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/pascalVOCModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class ScreenViewModel extends ViewModel {

  final PascalVOCModel object;
  final bool isSelected;
  bool showLabel=false;
  final ValueSetter<String> onActionCaller;

  ScreenViewModel(this.isSelected,this.object, this.onActionCaller);

}