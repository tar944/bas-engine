import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/src/controllers/regionRecController.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class RegionViewModel extends ViewModel {

  final ObjectModel curObject;
  final ValueSetter<String> onObjectActionCaller;

  RegionViewModel(this.curObject, this.onObjectActionCaller);

  double getSize({bool isWidth=false}){
    return isWidth?(curObject.right-curObject.left).abs():
    (curObject.bottom - curObject.top).abs();
  }
}