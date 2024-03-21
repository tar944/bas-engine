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
    required this.rowNumber,
    required this.onNavSelectedCaller
  }) : super(key: key);

  List<NavModel> allNavs;
  NavModel selectedNav;
  int rowNumber;
  ValueSetter<NavModel> onNavSelectedCaller;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: () => const _View(),
      viewModel: NavigationRowViewModel(allNavs,selectedNav,rowNumber,onNavSelectedCaller),
    );
  }
}

class _View extends StatelessView<NavigationRowViewModel> {
  const _View({Key? key}) : super(key: key);

  @override
  Widget render(context, NavigationRowViewModel vm) {

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
              itemCount: vm.allNavs.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return NavItem(
                    navItem: vm.allNavs[index],
                    selectStatus: vm.findSelectedStatus(vm.allNavs[index]),
                    onItemSelectedCaller: vm.onItemSelectHandler);
              }),
          ),
        ),
      ),
    );
  }
}
