import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class ObjectItemViewModel extends ViewModel {

  final ObjectModel object;
  final bool isSelected;
  final ValueSetter<String>? onActionCaller;

  ObjectItemViewModel(this.isSelected,this.object, this.onActionCaller);

  @override
  void init() async {
  }
}