
import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/labelDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/projectDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/models/labelModel.dart';
import 'package:bas_dataset_generator_engine/src/dialogs/toast.dart';
import 'package:bas_dataset_generator_engine/src/pages/labelingPage/views/dlgLevel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';
import 'package:uuid/uuid.dart';

class LabelManagementViewModel extends ViewModel {

  List<LabelModel> allLabels;
  List<String> allLevels=[];
  int curIndex=0;
  LabelModel? selectedLabel;
  String prjUUID,returnAction,actValue="none";
  var ctlName = TextEditingController();
  final ValueSetter<String> onActionCaller;

  LabelManagementViewModel(this.prjUUID,this.allLabels,this.returnAction, this.onActionCaller);

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
          DlgTitle(onActionCaller: saveLevelHandler, title: "",dlgTitle: Strings.dlgLevel,),
    );
  }

  saveLevelHandler(String name){
    allLevels.add(name);
    notifyListeners();
  }
  onLabelActionHandler(String action)async{
    var act=action.split('&&');
    switch(act[0]){
      case "saveName":
        onActionCaller("$returnAction&&${selectedLabel!.id}&&${act[1]}");
        onCloseClicked();
        break;
      case "create":
        if(allLabels.firstWhere((element) => element.name==act[1],orElse: ()=>LabelModel(-1,"","","","")).id!=-1){
          Toast(Strings.lblDuplicateError,false).showWarning(context);
        }else{
          var newLabel = LabelModel(-1,const Uuid().v4(), act[1], allLevels[curIndex],act.length==3?act[2]:"");
          newLabel.uuid=const Uuid().v4();
          newLabel.id=await LabelDAO().addLabel(newLabel);
          await ProjectDAO().addALabel(prjUUID, newLabel);
          allLabels.add(newLabel);
          notifyListeners();
        }
        break;
      case "delete":
        await LabelDAO().deleteLabel(int.parse(act[1]));
        allLabels.removeWhere((element) => element.id==int.parse(act[1]));
        notifyListeners();
        break;
      case "clicked":
        selectedLabel=allLabels.firstWhere((element) => element.id==int.parse(act[1]));
        notifyListeners();
        break;
      case "finalSelect":
        onActionCaller("$returnAction&&${act[1]}&&");
        onCloseClicked();
        break;
    }
  }
}