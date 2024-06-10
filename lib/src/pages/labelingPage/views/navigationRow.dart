import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/src/data/models/navModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/labelingPage/viewModels/navigationRowViewModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/labelingPage/views/navItem.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:pmvvm/pmvvm.dart';

class NavigationRow extends StatelessWidget {
  NavigationRow({
    Key? key,
    required this.allNavs,
    required this.selectedNav,
    required this.curRowNumber,
    required this.onNavSelectedCaller,
    required this.onAddNewShapeCaller,
    required this.onSelectShapeCaller
  }) : super(key: key);

  final List<NavModel> allNavs;
  final NavModel selectedNav;
  final int curRowNumber;
  ValueSetter<NavModel> onNavSelectedCaller;
  ValueSetter<NavModel> onAddNewShapeCaller;
  ValueSetter<int> onSelectShapeCaller;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: () => const _View(),
      viewModel: NavigationRowViewModel(
          allNavs,
          selectedNav,
          curRowNumber,
          onNavSelectedCaller,
          onAddNewShapeCaller,
          onSelectShapeCaller
      ),
    );
  }
}

class _View extends StatelessView<NavigationRowViewModel> {
  const _View({Key? key}) : super(key: key);

  @override
  Widget render(context, NavigationRowViewModel vm) {
    print("row data => ${vm.selectedNav.id} ** ${vm.selectedNav.rowNumber}");
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          color: Colors.grey[180]
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width-(65+Dimens.navH*1.8),
            height: Dimens.navH,
            child: ListView.builder(
              key: GlobalKey(),
              itemCount: vm.allNavs.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return NavItem(
                    navItem: vm.allNavs[index],
                    showAddBtn: vm.selectedNav.rowNumber==vm.curRowNumber,
                    selectStatus: vm.findSelectedStatus(vm.allNavs[index]),
                    onItemSelectedCaller: vm.onItemSelectHandler,
                  onAddNewShapeCaller: vm.onAddNewShapeCaller,
                  onSelectShapeCaller: vm.onSelectShapeCaller,
                );
              }),
          ),
        ),
      ),
    );
  }
}
