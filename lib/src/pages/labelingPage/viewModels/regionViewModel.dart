import 'package:bas_dataset_generator_engine/src/data/dao/objectDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:pmvvm/pmvvm.dart';

class RegionViewModel extends ViewModel {
  List<ObjectModel> itsObjects;

  RegionViewModel(
      this.itsObjects);

  onObjectActionHandler(String action)async{
    var act=action.split("&&");
    var curObj= await ObjectDAO().getDetails(int.parse(act[1]));
    curObj!.isNavTool=!curObj.isNavTool;
    await ObjectDAO().update(curObj);
    notifyListeners();
  }
}
