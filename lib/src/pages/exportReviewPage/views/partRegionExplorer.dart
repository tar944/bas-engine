import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/src/data/models/imageModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
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
        required this.curImage
      }) : super(key: key);

  final List<ObjectModel> itsObjects;
  final ImageModel curImage;
  final ValueSetter<String> onObjectActionCaller;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: () => const _View(),
      viewModel: PartRegionViewModel(
          itsObjects,
          curImage,
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
          return Positioned(
                  top: item.curTop(vm.curImage,context,Dimens.topBarHeight),
                  left: item.curLeft(vm.curImage,context),
                  child: RegionWidget(
                    key: GlobalKey(),
                    curObject: item,
                    onObjectActionCaller: (e) => vm.onObjectActionHandler(e),
                  ),
                );
        }).toList(),
      ]),
    );
  }
}
