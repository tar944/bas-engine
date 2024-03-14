import 'package:bas_dataset_generator_engine/src/data/models/imageGroupModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:pmvvm/pmvvm.dart';

class FlyObjectViewModel extends ViewModel {

  final ObjectModel object;
  final bool isSelected;
  bool showLabel=false;
  final ValueSetter<String> onActionCaller;

  FlyObjectViewModel(this.isSelected,this.object, this.onActionCaller);

}