import 'package:bas_dataset_generator_engine/src/data/models/navModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class NavigationRowViewModel extends ViewModel {

  List<NavModel> allNavs;
  int curRowNumber;
  NavModel selectedNav;
  NavModel showAll=NavModel(-2, -1,0, "", "", "","","",[]);
  ValueSetter<NavModel> onNavSelectedCaller;
  ValueSetter<NavModel> onAddNewShapeCaller;
  ValueSetter<int> onSelectShapeCaller;
  NavigationRowViewModel(
      this.allNavs,
      this.selectedNav,
      this.curRowNumber,
      this.onNavSelectedCaller,
      this.onAddNewShapeCaller,
      this.onSelectShapeCaller);

  onItemSelectHandler(NavModel curNav){
    selectedNav=curNav;
    onNavSelectedCaller(curNav);
    notifyListeners();
  }

  String findSelectedStatus(NavModel curNav){
    if(selectedNav.id==-1){
      return "waiting";
    }else if(curNav.id==selectedNav.id){
      return "selected";
    }else{
      return "notSelected";
    }
  }
}