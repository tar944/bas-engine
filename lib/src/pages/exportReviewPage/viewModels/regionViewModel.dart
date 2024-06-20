import 'package:bas_dataset_generator_engine/src/data/models/pascalObjectModel.dart';
import 'package:bas_dataset_generator_engine/src/utility/enum.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class RegionViewModel extends ViewModel {

  final PascalObjectModel curObject;
  final ValueSetter<String> onObjectActionCaller;
  final double width,height;
  bool isHover=false;
  String regionStatus;

  RegionViewModel(this.curObject,this.regionStatus,this.width,this.height, this.onObjectActionCaller);

  onHoverHandler(bool isHover){
    this.isHover = isHover;
    onObjectActionCaller("hover&&${curObject.objUUID}");
    notifyListeners();
  }

  onClickHandler(){
    regionStatus=regionStatus=='none'?'active':'none';
    onObjectActionCaller("${curObject.objUUID}&&$regionStatus");
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
    if(regionStatus == 'active'){
      print('it is active');
    }
  }
}