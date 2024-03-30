import 'package:bas_dataset_generator_engine/src/data/models/navModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class NavigationRowViewModel extends ViewModel {

  List<NavModel> allNavs;
  int rowNumber;
  NavModel selectedNav;
  NavModel showAll=NavModel(-2, -1, "", "", "","","");
  ValueSetter<NavModel> onNavSelectedCaller;
  NavigationRowViewModel(this.allNavs,this.selectedNav,this.rowNumber,this.onNavSelectedCaller);

  onItemSelectHandler(NavModel curNav){
    selectedNav=curNav;
    curNav.rowNumber=rowNumber;
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