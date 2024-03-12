import 'package:bas_dataset_generator_engine/main.dart';
import 'package:bas_dataset_generator_engine/src/controllers/regionRecController.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/objectDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class ExplorerPartViewModel extends ViewModel {

  ObjectModel curObject,mainObject;
  ValueSetter<String> onObjectActionCaller;
  bool isMine;
  bool isActive;
  RegionRecController controller;

  ExplorerPartViewModel(this.curObject,this.mainObject,this.isMine, this.isActive,this.controller,this.onObjectActionCaller);

  onLabelHandler(String action)async{
    if(action=="remove"){
      curObject.label.target=null;
      await ObjectDAO().update(curObject);
    }else if(action=="addValidObject"){
      curObject.validObjects.add(mainObject);
      await ObjectDAO().update(curObject);
    }else{
      curObject.validObjects.removeWhere((element) => element.id==mainObject.id);
      await ObjectDAO().update(curObject);
    }
    notifyListeners();
  }

  Color getColor(){
    if(isMine){
      return curObject.label.target==null?Colors.blue.dark:Colors.teal.dark;
    }else{
      return Colors.orange.normal;
    }
  }
}