import 'package:bas_dataset_generator_engine/src/controllers/regionRecController.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/labelDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/objectDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/models/labelModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';
import 'package:uuid/uuid.dart';

class RegionViewModel extends ViewModel {
  List<ObjectModel> itsObjects;
  ObjectModel? curObject;
  final ValueSetter<String> onObjectCaller;

  RegionViewModel(
      this.itsObjects,
      this.onObjectCaller);

  onObjectActionHandler(String action)async{
  }

}
