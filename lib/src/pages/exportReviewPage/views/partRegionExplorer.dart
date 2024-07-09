import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/pascalObjectModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/exportReviewPage/viewModels/partRegionViewModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/exportReviewPage/views/regionWidget.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class PartRegionExplorer extends StatelessWidget {
  PartRegionExplorer(
      {
        Key? key,
        required this.allObjects,
        required this.mainObject,
        required this.isSelectionMode,
        required this.onActionCaller,
        required this.imgPath,
        required this.isKeyActive
      }) : super(key: key);

  final List<PascalObjectModel> allObjects;
  final String imgPath;
  final bool isSelectionMode,isKeyActive;
  final ObjectModel mainObject;
  final ValueSetter<String> onActionCaller;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: () => const _View(),
      viewModel: PartRegionViewModel(
          allObjects,
          imgPath,
          isSelectionMode,
          isKeyActive,
          onActionCaller,
          mainObject
      ),
    );
  }
}

class _View extends StatelessView<PartRegionViewModel> {
  const _View({Key? key}) : super(key: key);

  @override
  Widget render(context, PartRegionViewModel vm) {
    return Listener(
      child: Stack(children: [
        ...vm.allObjects.map((item) {
          // print(item.name);
          return Positioned(
                  top: vm.getY(item.ymin!).toDouble(),
                  left: vm.getX(item.xmin!).toDouble(),
                  child: RegionWidget(
                    key: GlobalKey(),
                    mainObjUUID: vm.mainObject.uuid,
                    width: (vm.getX(item.xmax!)-vm.getX(item.xmin!)).toDouble(),
                    height: (vm.getY(item.ymax!)-vm.getY(item.ymin!)).toDouble(),
                    activeObjUUID:vm.isSelectionMode?Strings.notSet:vm.activeObjUUID,
                    curObject: item,
                    onObjectActionCaller: vm.onObjectHandler,
                  ),
                );
        }).toList(),
      ]),
    );
  }
}
