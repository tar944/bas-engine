import 'package:bas_dataset_generator_engine/src/data/dao/objectDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/models/pascalObjectModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class RegionViewModel extends ViewModel {

  final PascalObjectModel curObject;
  final ValueSetter<String> onObjectActionCaller;
  final double width,height;
  final String mainObjUUID;
  bool isHover=false;
  String regionStatus='none';

  RegionViewModel(this.mainObjUUID,this.curObject,this.width,this.height, this.onObjectActionCaller);

  @override
  void init() async{
    var obj = await ObjectDAO().getDetailsByUUID(curObject.objUUID!);
    if(obj!.isGlobalObject){
      regionStatus='global';
    }else{
      var mainObject = await ObjectDAO().getDetailsByUUID(mainObjUUID);
      for(var obj in mainObject!.labelObjects){
        if(obj.uuid==curObject.objUUID){
          regionStatus= "active";
          break;
        }
      }
      if(regionStatus!='active'){
        for(var obj in mainObject.banObjects){
          if(obj.uuid==curObject.objUUID){
            regionStatus= "banned";
            break;
          }
        }
      }
    }
    notifyListeners();
  }

  onHoverHandler(bool isHover){
    this.isHover = isHover;
    notifyListeners();
  }

  onClickHandler(){
    switch(regionStatus){
      case 'none':
        regionStatus='active';
        onObjectActionCaller("${curObject.objUUID}&&active");
        break;
      case'global':
        regionStatus='none';
        onObjectActionCaller("${curObject.objUUID}&&setGlobal");
        break;
      case 'active':
        regionStatus='none';
        onObjectActionCaller("${curObject.objUUID}&&none");
        break;
      default:
        regionStatus='none';
    }
    notifyListeners();
  }

  onMiddleHandler(){
    if(regionStatus=="banned"){
      onObjectActionCaller("${curObject.objUUID}&&unBanned");
    }else{
      if(regionStatus=='active'){
        onObjectActionCaller("${curObject.objUUID}&&none");
        regionStatus='deActive';
        notifyListeners();
      }else if(regionStatus=='deActive'){
        onObjectActionCaller("${curObject.objUUID}&&banned");
      }else{
        regionStatus='deActive';
        notifyListeners();
      }
    }
  }

  onRightClickHandler(){
    if(['global','active'].contains(regionStatus)){
      onObjectActionCaller('${curObject.objUUID}&&showProperties');
    }else{
      onObjectActionCaller('${curObject.objUUID}&&setGlobal');
    }

  }
}