import 'package:bas_dataset_generator_engine/src/data/models/imageGroupModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:pmvvm/pmvvm.dart';

class ExplorerPartViewModel extends ViewModel {

  ObjectModel curObject;
  ValueSetter<ObjectModel> onObjectClickCaller;
  bool isMine;
  bool isActive;
  String activeState="";

  ExplorerPartViewModel(this.curObject,this.isMine, this.isActive,this.onObjectClickCaller);


  @override
  void init() {
    activeState =isActive ? "active":"deActive";
    notifyListeners();
  }

  onMouseEnter(PointerEnterEvent e){
    activeState="active";
    notifyListeners();
  }
  onMouseExit(PointerExitEvent e){
    if(activeState=="active") {
      activeState="deActive";
    }
    notifyListeners();
  }

}