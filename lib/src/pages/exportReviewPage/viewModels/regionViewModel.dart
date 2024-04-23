import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/src/controllers/regionRecController.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/pascalObjectModel.dart';
import 'package:bas_dataset_generator_engine/src/utility/enum.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class RegionViewModel extends ViewModel {

  final PascalObjectModel curObject;
  final ValueSetter<String> onObjectActionCaller;
  final double width,height;
  bool isHover=false;

  RegionViewModel(this.curObject,this.width,this.height, this.onObjectActionCaller);
  onHoverHandler(bool isHover){
    if(curObject.state!=ExportState.deActive.name) {
      this.isHover = isHover;
      onObjectActionCaller("hover&&${curObject.objUUID}");
      notifyListeners();
    }
  }

  onRightClickHandler(){
    if(curObject.state==ExportState.none.name){
      curObject.state=ExportState.active.name;
    }else if(curObject.state==ExportState.active.name){
      curObject.state=ExportState.deActive.name;
      isHover=false;
    }else{
      curObject.state=ExportState.none.name;
    }
    onObjectActionCaller("rightClick&&${curObject.objUUID}&&${curObject.state}");
    notifyListeners();
  }
}