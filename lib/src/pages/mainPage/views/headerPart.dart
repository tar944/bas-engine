import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/src/pages/mainPage/viewModels/headerViewModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/mainPage/views/headerBtn.dart';
import 'package:bas_dataset_generator_engine/src/utility/enum.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class HeaderPart extends StatelessWidget {
  const HeaderPart({
    Key? key,
    required this.onActionCaller,
  }) : super(key: key);

  final ValueSetter<HeaderTabs> onActionCaller;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: () => const _View(),
      viewModel: HeaderViewModel(onActionCaller),
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
                  tabKind: HeaderTabs.software,
                  onPressed: vm.onTabChanged,
                  status: vm.curTab.name == HeaderTabs.software.name
                      ? "active"
                      : "notActive"),
              if (vm.curTab == HeaderTabs.software)
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
                      onPressed: () {}),
                ),
              if (vm.showTab(HeaderTabs.groups))
                HeaderBtn(
                    isFirst: false,
                    text: Strings.groups,
                    tabKind: HeaderTabs.groups,
                    onPressed: vm.onTabChanged,
                    status: vm.curTab.name == HeaderTabs.groups.name
                        ? "active"
                        : "notActive"),
              if (vm.curTab == HeaderTabs.groups)
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
                      onPressed: () {}),
                ),
              if (vm.showTab(HeaderTabs.screenLabel))
                HeaderBtn(
                    isFirst: false,
                    text: Strings.screenLabeling,
                    tabKind: HeaderTabs.screenLabel,
                    onPressed: vm.onTabChanged,
                    status: vm.curTab.name == HeaderTabs.screenLabel.name
                        ? "active"
                        : "notActive"),
              if (vm.showTab(HeaderTabs.partLabel))
                HeaderBtn(
                    isFirst: false,
                    text: Strings.partLabeling,
                    tabKind: HeaderTabs.partLabel,
                    onPressed: vm.onTabChanged,
                    status: vm.curTab.name == HeaderTabs.partLabel.name
                        ? "active"
                        : "notActive"),
            ],
          ),
          Text("some string")
        ],
      ),
    );
  }
}
