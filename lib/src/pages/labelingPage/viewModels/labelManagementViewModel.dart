import 'package:bas_dataset_generator_engine/src/data/dao/labelDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/models/labelModel.dart';
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
  onLabelActionHandler(String action){

  }
}