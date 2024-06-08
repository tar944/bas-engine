import 'package:bas_dataset_generator_engine/src/data/models/navModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class NavigationRowViewModel extends ViewModel {

  List<NavModel> allNavs;
  int curRowNumber;
  NavModel selectedNav;
  NavModel showAll=NavModel(-2, -1,0, "", "", "","","");
  ValueSetter<NavModel> onNavSelectedCaller;
  ValueSetter<NavModel> onAddNewShapeCaller;
  NavigationRowViewModel(this.allNavs,this.selectedNav,this.curRowNumber,this.onNavSelectedCaller,this.onAddNewShapeCaller);

  onItemSelectHandler(NavModel curNav){
    print("selected item ==> ${curNav.id}");
    selectedNav=curNav;
    onNavSelectedCaller(curNav);
    notifyListeners();
  }

  String findSelectedStatus(NavModel curNav){
    print("${curNav.id} && ${selectedNav.id}");
    if(selectedNav.id==-1){
      return "waiting";
    }else if(curNav.id==selectedNav.id){
      return "selected";
    }else{
      return "notSelected";
    }
  }
}