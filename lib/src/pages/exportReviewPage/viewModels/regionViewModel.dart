import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/src/controllers/regionRecController.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/pascalObjectModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class RegionViewModel extends ViewModel {

  final PascalObjectModel curObject;
  final ValueSetter<String> onObjectActionCaller;
  final double width,height;

  RegionViewModel(this.curObject,this.width,this.height, this.onObjectActionCaller);
}