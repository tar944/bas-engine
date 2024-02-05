import 'package:bas_dataset_generator_engine/src/utility/enum.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class HeaderViewModel extends ViewModel {
  HeaderTabs curTab=HeaderTabs.partLabel;

  final ValueSetter<HeaderTabs> onActionCaller;

  HeaderViewModel(this.onActionCaller);
  @override
  void init() async {
  }
  onTabChanged(HeaderTabs tab){
    curTab =tab;
    onActionCaller(tab);
    notifyListeners();
  }
  bool showTab(HeaderTabs tab){
    if(curTab==tab){
      return true;
    }else if(tab==HeaderTabs.groups&&(curTab==HeaderTabs.screenLabel||curTab==HeaderTabs.partLabel)){
      return true;
    }else if(tab == HeaderTabs.screenLabel&&curTab==HeaderTabs.partLabel){
      return true;
    }
    return false;
  }
}