import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/labelingPage/viewModels/regionViewModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/labelingPage/views/partRegion.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class ViewRegionExplorer extends StatelessWidget {
  ViewRegionExplorer(
      {
        Key? key,
        required this.onObjectCaller,
        required this.itsObjects,
      }) : super(key: key);


  final List<ObjectModel> itsObjects;
  final ValueSetter<String> onObjectCaller;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: () => const _View(),
      viewModel: RegionViewModel(
          itsObjects,
          onObjectCaller
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
          return Positioned(
                  top: item.top,
                  left: item.left,
                  child: PartRegion(
                    curObject: item,
                    onObjectActionCaller: (e) => vm.onObjectActionHandler(e),
                  ),
                );
        }).toList(),
      ]),
    );
  }
}
