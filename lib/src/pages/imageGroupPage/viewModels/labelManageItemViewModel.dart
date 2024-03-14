import 'package:bas_dataset_generator_engine/src/data/models/imageGroupModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/labelModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:pmvvm/pmvvm.dart';

class LabelManageItemViewModel extends ViewModel {

  final LabelModel label;
  bool isEditMode=false;
    final ValueSetter<String> onActionCaller;
  TextEditingController? ctlTitle ;
  final controller = FlyoutController();

  LabelManageItemViewModel(this.label, this.onActionCaller);

  @override
  void init() {
    ctlTitle= TextEditingController(text: label.name);
  }

  onEditBtnHandler(){
    if(isEditMode){
      onActionCaller('edit&&${label.id}&&${ctlTitle!.text.toString()}');
      isEditMode=false;
    }else{
      isEditMode=true;
    }
    notifyListeners();
  }

}