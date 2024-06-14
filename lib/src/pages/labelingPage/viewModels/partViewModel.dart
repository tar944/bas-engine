import 'package:bas_dataset_generator_engine/src/data/dao/objectDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class PartViewModel extends ViewModel {

  final int objId;
  ObjectModel? curObject;
  VoidCallback onObjectActionCaller;

  PartViewModel(this.objId,this.onObjectActionCaller);

  @override
  void init() async{
    curObject =await ObjectDAO().getDetails(objId);
    notifyListeners();
  }
}