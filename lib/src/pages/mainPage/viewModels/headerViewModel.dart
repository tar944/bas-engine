import 'package:bas_dataset_generator_engine/src/utility/enum.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class HeaderViewModel extends ViewModel {
  HeaderTabs curTab = HeaderTabs.project;

  final ValueSetter<HeaderTabs> onActionCaller;
  final String guideText;

  HeaderViewModel(this.onActionCaller, this.guideText);

  onTabChanged(HeaderTabs tab) {
    if (tab != HeaderTabs.addProject && tab != HeaderTabs.addPart) {
      curTab = tab;
      notifyListeners();
    }
    onActionCaller(tab);
  }

  bool showTab(HeaderTabs tab) {
    if (curTab == tab) {
      return true;
    } else if (tab == HeaderTabs.projectParts &&
        (curTab == HeaderTabs.objectLabeling ||
            curTab == HeaderTabs.imageGroups)) {
      return true;
    } else if (tab == HeaderTabs.objectLabeling &&
        curTab == HeaderTabs.imageGroups) {
      return true;
    }
    return false;
  }
}
