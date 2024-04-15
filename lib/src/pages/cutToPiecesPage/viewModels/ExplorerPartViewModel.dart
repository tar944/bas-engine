import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/src/controllers/regionRecController.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class ExplorerPartViewModel extends ViewModel {

  final ObjectModel curObject,mainObject;
  final ValueSetter<String> onObjectActionCaller;
  final bool isMine,isMinimum;
  final bool isSimpleAction;
  final RegionRecController controller;

  ExplorerPartViewModel(this.curObject,this.mainObject,this.isMine,this.isMinimum,this.isSimpleAction, this.controller,this.onObjectActionCaller);

  double getSize({bool isWidth=false}){

    if(isSimpleAction){
      return isWidth?(curObject.curRight(mainObject.image.target!,context) - curObject.curLeft(mainObject.image.target!,context)).abs():
      (curObject.curBottom(mainObject.image.target!,context, Dimens.topBarHeight) - curObject.curTop(mainObject.image.target!,context, Dimens.topBarHeight)).abs();
    }else{
      return isWidth?(curObject.right-curObject.left).abs():
      (curObject.bottom - curObject.top).abs();
    }
  }
}