import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:bas_dataset_generator_engine/src/dialogs/flyDlgConfirm.dart';
import 'package:bas_dataset_generator_engine/src/pages/labelingPage/viewModels/regionViewModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/labelingPage/views/partRegion.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class ViewRegionExplorer extends StatelessWidget {
  ViewRegionExplorer(
      {
        Key? key,
        required this.itsObjects,
      }) : super(key: key);


  final List<ObjectModel> itsObjects;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: () => const _View(),
      viewModel: RegionViewModel(
          itsObjects
      ),
    );
  }
}

class _View extends StatelessView<RegionViewModel> {
  const _View({Key? key}) : super(key: key);

  @override
  Widget render(context, RegionViewModel vm) {
    return Listener(
      child: Stack(children: [
        ...vm.itsObjects.map((item) {
          final controller = FlyoutController();
          return FlyoutTarget(
              key: GlobalKey(),
              controller: controller,
              child:Positioned(
                top: item.top,
                left: item.left,
                child: PartRegion(
                      objId: item.id!,
                      onObjectActionCaller: () {
                        showFlyConfirm(
                            item.isNavTool?Strings.removeFromNavObject:Strings.setAsNavObject,
                            Strings.yes,
                            controller,
                            FlyoutPlacementMode.topCenter,
                            "addAsMain&&${item.id}",
                            vm.onObjectActionHandler);
                      },
                    ),
                  ),
              );
        }).toList(),
      ]),
    );
  }
}
