import 'package:bas_dataset_generator_engine/src/data/models/pascalObjectModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/exportReviewPage/viewModels/partRegionViewModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/exportReviewPage/views/regionWidget.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class PartRegionExplorer extends StatelessWidget {
  PartRegionExplorer(
      {
        Key? key,
        required this.itsObjects,
        required this.onObjectActionCaller,
        required this.imgPath
      }) : super(key: key);

  final List<PascalObjectModel> itsObjects;
  final String imgPath;
  final ValueSetter<String> onObjectActionCaller;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: () => const _View(),
      viewModel: PartRegionViewModel(
          itsObjects,
          imgPath,
          onObjectActionCaller
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
        ...vm.itsObjects.map((item) {
          // print(item.name);
          return Positioned(
                  top: vm.getY(item.ymin!).toDouble(),
                  left: vm.getX(item.xmin!).toDouble(),
                  child: RegionWidget(
                    key: GlobalKey(),
                    width: (vm.getX(item.xmax!)-vm.getX(item.xmin!)).toDouble(),
                    height: (vm.getY(item.ymax!)-vm.getY(item.ymin!)).toDouble(),
                    curObject: item,
                    onObjectActionCaller: (e) => vm.onObjectActionCaller(e),
                  ),
                );
        }).toList(),
      ]),
    );
  }
}
