import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/assets/values/textStyle.dart';
import 'package:bas_dataset_generator_engine/src/pages/mainPage/viewModels/headerViewModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/mainPage/views/headerBtn.dart';
import 'package:bas_dataset_generator_engine/src/utility/enum.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class HeaderPart extends StatelessWidget {
  const HeaderPart({
    Key? key,
    required this.onActionCaller, required this.guideText,
  }) : super(key: key);

  final ValueSetter<HeaderTabs> onActionCaller;
  final String guideText;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: () => const _View(),
      viewModel: HeaderViewModel(onActionCaller,guideText),
    );
  }
}

class _View extends StatelessView<HeaderViewModel> {
  const _View({Key? key}) : super(key: key);

  @override
  Widget render(context, HeaderViewModel vm) {
    return Container(
      width: double.infinity,
      height: Dimens.mainHeaderH,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              HeaderBtn(
                  isFirst: true,
                  text: Strings.software,
                  tabKind: HeaderTabs.project,
                  onPressed: vm.onTabChanged,
                  status: vm.curTab.name == HeaderTabs.project.name
                      ? "active"
                      : "notActive"),
              if (vm.curTab == HeaderTabs.project)
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                  child: Button(
                    style:ButtonStyle(
                      padding: ButtonState.all(EdgeInsets.zero)
                    ),
                      child: Container(
                          width: Dimens.tabHeightSmall+10,
                          height: Dimens.tabHeightSmall+10,
                          child: Icon(FluentIcons.add,size: 17,color: Colors.teal,)),
                      onPressed: ()=>vm.onTabChanged(HeaderTabs.addProject)),
                ),
              if (vm.showTab(HeaderTabs.projectParts))
                HeaderBtn(
                    isFirst: false,
                    text: Strings.groups,
                    tabKind: HeaderTabs.projectParts,
                    onPressed: vm.onTabChanged,
                    status: vm.curTab.name == HeaderTabs.projectParts.name
                        ? "active"
                        : "notActive"),
              if (vm.curTab == HeaderTabs.projectParts)
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                  child: Button(
                      style:ButtonStyle(
                          padding: ButtonState.all(EdgeInsets.zero),
                      ),
                      child: Container(
                          width: Dimens.tabHeightSmall+10,
                          height: Dimens.tabHeightSmall+10,
                          child: Icon(FluentIcons.add,size: 17,color: Colors.teal,)),
                      onPressed: ()=>vm.onTabChanged(HeaderTabs.addPart)),
                ),
              if (vm.showTab(HeaderTabs.imageGroups))
                HeaderBtn(
                    isFirst: false,
                    text: Strings.screenLabeling,
                    tabKind: HeaderTabs.imageGroups,
                    onPressed: vm.onTabChanged,
                    status: vm.curTab.name == HeaderTabs.objectLabeling.name
                        ? "active"
                        : "notActive"),
              if (vm.showTab(HeaderTabs.objectLabeling))
                HeaderBtn(
                    isFirst: false,
                    text: Strings.partLabeling,
                    tabKind: HeaderTabs.objectLabeling,
                    onPressed: vm.onTabChanged,
                    status: vm.curTab.name == HeaderTabs.objectLabeling.name
                        ? "active"
                        : "notActive"),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(vm.guideText,style:TextSystem.textM(Colors.white)),
          )
        ],
      ),
    );
  }
}