import 'package:bas_dataset_generator_engine/src/providers/headerProvider.dart';
import 'package:bas_dataset_generator_engine/src/utility/enum.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class HeaderViewModel extends ViewModel {
  HeaderTabs curTab;

  final ValueSetter<HeaderTabs> onActionCaller;
  String guideText="";

  final HeaderController controller;

  HeaderViewModel(this.onActionCaller,this.curTab,this.controller);

  onTabChanged(HeaderTabs tab) {
    if (tab != HeaderTabs.addProject && tab != HeaderTabs.addPart&&tab!=HeaderTabs.addGroup) {
      curTab = tab;
      notifyListeners();
    }
    onActionCaller(tab);
  }

  setGuideText(String text){
    guideText = text;
    notifyListeners();
  }

  bool showTab(HeaderTabs tab) {
    if (curTab == tab) {
      return true;
    } else if (tab == HeaderTabs.projectParts && (curTab == HeaderTabs.objectLabeling || curTab == HeaderTabs.imageGroups)) {
      return true;
    }else if(tab == HeaderTabs.imageGroups&&curTab==HeaderTabs.objectLabeling){
      return true;
    }
    return false;
  }
}
