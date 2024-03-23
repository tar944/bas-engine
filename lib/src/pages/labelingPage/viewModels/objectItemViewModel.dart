import 'package:bas_dataset_generator_engine/src/data/models/imageGroupModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:pmvvm/pmvvm.dart';

class ObjectItemViewModel extends ViewModel {

  final ObjectModel object;
  int parentGroupId =-1;
  bool showLabel=false;
  String stepStatus;
  final List<ImageGroupModel> allGroups;
  final ValueSetter<String> onActionCaller;

  ObjectItemViewModel(this.allGroups,this.stepStatus,this.object, this.onActionCaller);


  @override
  void init() {
    for(var grp in allGroups){
      if(grp.allStates.firstWhere((element) => element.id==object.id,orElse: ()=>ObjectModel(-1, "", 0.0, 0.0, 0.0, 0.0, "")).id!!=-1) {
        parentGroupId=grp.id;
        stepStatus =grp.mainState.target==null?"firstStep":"labelIt";
        notifyListeners();
        break;
      }
    }

    print(parentGroupId.toString()+stepStatus);
  }

  onMouseEnter(PointerEnterEvent e){
    showLabel=true;
    notifyListeners();
  }
  onMouseExit(PointerExitEvent e){
    showLabel=false;
    notifyListeners();
  }

  onGroupSelected(List<int> allSelected,int curGroupItem){
    if(parentGroupId!=-1){
      onActionCaller("removeFromGroup&&$curGroupItem&&${object.id}");
    }else{
      onActionCaller("addToGroup&&$curGroupItem&&${object.id}");
    }
  }
}