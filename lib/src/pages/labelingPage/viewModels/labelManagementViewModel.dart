import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/labelDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/objectDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/models/labelModel.dart';
import 'package:bas_dataset_generator_engine/src/dialogs/toast.dart';
import 'package:bas_dataset_generator_engine/src/pages/labelingPage/views/dlgLevel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class LabelManagementViewModel extends ViewModel {

  List<LabelModel> allLabels;
  List<String> allLevels=[];
  int curIndex=0;
  final ValueSetter<String> onActionCaller;

  LabelManagementViewModel(this.allLabels, this.onActionCaller);


  @override
  void init() {
    for(var lbl in allLabels){
      if(!allLevels.contains(lbl.levelName)){
        allLevels.add(lbl.levelName);
      }
    }
    notifyListeners();
  }

  void onCloseClicked() {
    Navigator.pop(context);
  }

  void onActionHandler(String action)async{
    var actions = action.split('&&');
    switch (actions[0]) {
      case 'save':
        LabelModel? label =
        await LabelDAO().getLabel(int.parse(actions[1]));
        label!.name = actions[2];
        await LabelDAO().updateLabel(label);
        break;
      case 'delete':
        await LabelDAO().deleteLabel(int.parse(actions[1]));
        break;
      case 'create':
        await LabelDAO().addLabel(LabelModel(0, actions[1],""));
        break;
    }
    allLabels=await LabelDAO().getLabelList("");
  }

  onTabChanged(int index){
    curIndex=index;
    notifyListeners();
  }

  onTabClosed(String lvl){
    if(allLabels.where((element) => element.levelName==lvl).toList().isNotEmpty){
      Toast(Strings.lvlError, false).showWarning(context);
    }else{
      allLevels.remove(lvl);
      notifyListeners();
    }
  }

  onNewLevelHandler(){
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) =>
          DlgLevel(onActionCaller: saveLevelHandler, title: ""),
    );
  }

  saveLevelHandler(String name){
    allLevels.add(name);
    notifyListeners();
  }
  onLabelActionHandler(String action)async{
    var act=action.split('&&');
    switch(act[0]){
      case "create":
        if(act[1]==""){
          Toast(Strings.emptyNameError,false).showWarning(context);
        }else{
          if(allLabels.firstWhere((element) => element.name==act[1],orElse: ()=>LabelModel(-1,"","")).id!=-1){
            Toast(Strings.lblDuplicateError,false).showWarning(context);
          }else{
            var newLabel = LabelModel(-1, act[1], allLevels[curIndex]);
            newLabel.id=await LabelDAO().addLabel(newLabel);
            allLabels.add(newLabel);
            notifyListeners();
          }
        }
        break;
      case "delete":
        var objects =await ObjectDAO().getByLabel(int.parse(act[1]));
        if(objects!.isNotEmpty){
          Toast(Strings.lblError,false).showWarning(context);
        }else{
          await LabelDAO().deleteLabel(int.parse(act[1]));
          allLabels.removeWhere((element) => element.id==int.parse(act[1]));
          notifyListeners();
        }
        break;
      case "edit":
        int index=allLabels.indexWhere((element) => element.id==int.parse(act[1]));
        allLabels[index].name=act[2];
        await LabelDAO().updateLabel(allLabels[index]);
        notifyListeners();
        break;
    }
  }
}