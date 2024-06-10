import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/src/data/models/imageGroupModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:bas_dataset_generator_engine/src/dialogs/toast.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:pmvvm/pmvvm.dart';

class ObjectItemViewModel extends ViewModel {
  final ObjectModel object;
  int parentGroupId = -1;
  bool showLabel = false;
  String stepStatus;
  final bool isState;
  final List<ImageGroupModel> subGroups;
  final List<ImageGroupModel> otherShapes;
  final ValueSetter<String> onActionCaller;

  ObjectItemViewModel(this.subGroups,this.otherShapes,this.isState, this.stepStatus, this.object, this.onActionCaller);

  @override
  void init() {
    if (stepStatus == "hide") {
      for (var grp in subGroups) {
        if (grp.allStates.firstWhere((element) => element.id == object.id, orElse: () => ObjectModel(-1, "", 0.0, 0.0, 0.0, 0.0)).id! != -1) {
          parentGroupId = grp.id;
          // stepStatus = grp.state == GroupState.findMainState.name
          //     ? "firstStep"
          //     : "labelIt";
          notifyListeners();
          break;
        }
      }
    }
  }

  onMouseEnter(PointerEnterEvent e) {
    showLabel = true;
    notifyListeners();
  }

  onMouseExit(PointerExitEvent e) {
    showLabel = false;
    notifyListeners();
  }

  List<ImageGroupModel> getGroupList(){
    if(stepStatus=="firstStep"&&isState){
      return otherShapes;
    }else if(isState==false){
      return subGroups;
    }
    return [];
  }

  onGroupSelected(List<int> allSelected, int curGroupItem) {
    if(object.isMainObject){
      Toast(Strings.warnRemoveMainObject, false).showWarning(context);
      return;
    }
    if(isState){
      if (parentGroupId != -1) {
        onActionCaller("removeFromShape&&$curGroupItem&&${object.id}");
      } else {
        onActionCaller("addToShape&&$curGroupItem&&${object.id}");
      }
    }else{
      if (parentGroupId != -1) {
        onActionCaller("removeFromGroup&&$curGroupItem&&${object.id}");
      } else {
        onActionCaller("addToGroup&&$curGroupItem&&${object.id}");
      }
    }
  }
}
