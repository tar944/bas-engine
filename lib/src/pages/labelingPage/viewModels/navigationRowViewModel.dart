import 'package:bas_dataset_generator_engine/src/data/models/navModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/labelingPage/controller/navRowController.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class NavigationRowViewModel extends ViewModel {

  NavRowController rowController;
  NavModel showAll=NavModel(-2, -1,"", "", "","","",[]);
  ValueSetter<NavModel> onNavSelectedCaller;
  ValueSetter<NavModel> onAddNewShapeCaller;
  ValueSetter<NavModel> onSelectShapeCaller;
  NavigationRowViewModel(
      this.rowController,
      this.onNavSelectedCaller,
      this.onAddNewShapeCaller,
      this.onSelectShapeCaller);

  onItemSelectHandler(NavModel curNav){
    rowController.setSelectedNav(curNav);
    onNavSelectedCaller(curNav);
    notifyListeners();
  }

  String findSelectedStatus(NavModel curNav){
    if(rowController.selectedNav.id==-1){
      return "waiting";
    }else if(curNav.id==rowController.selectedNav.id){
      return "selected";
    }else{
      return "notSelected";
    }
  }
}