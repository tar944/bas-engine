import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/src/controllers/regionRecController.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/labelingPage/viewModels/ExplorerPartViewModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/labelingPage/views/rectanglePainter.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class ExploredPartRegion extends StatelessWidget {
  ExploredPartRegion({
    Key? key,
    required this.curObject,
    required this.isMine,
    required this.isActive,
    required this.controller,
    required this.onObjectClickCaller
  }) : super(key: key);

  ObjectModel curObject;
  ValueSetter<ObjectModel> onObjectClickCaller;
  bool isMine;
  bool isActive;
  RegionRecController controller;
  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: () => const _View(),
      viewModel:
      ExplorerPartViewModel(curObject, isMine, isActive,controller, onObjectClickCaller),
    );
  }
}

class _View extends StatelessView<ExplorerPartViewModel> {
  const _View({Key? key}) : super(key: key);

  @override
  Widget render(context, ExplorerPartViewModel vm) {

    final controller = FlyoutController();
    return SizedBox(
      width: (vm.curObject.right - vm.curObject.left).abs(),
      height: (vm.curObject.bottom - vm.curObject.top).abs()+40,
      child: Stack(
        children: [
          if(vm.controller.activeID==vm.curObject.id)
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Container(
                width: 92,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(Dimens.actionRadius)),
                    border: Border.all(color: Colors.grey[150]),
                    color: Colors.grey[190]
                ),
                child: Row(children: [
                  IconButton(icon: const Icon(FluentIcons.edit), onPressed: ()=>{}),
                  IconButton(icon: const Icon(FluentIcons.label), onPressed: ()=>{}),
                  IconButton(icon: Icon(FluentIcons.delete,color: Colors.red.dark,), onPressed: ()=>{}),
                ],),
              ),
            ),
          Positioned(
            top: 30,
            child: CustomPaint(
              painter: RectanglePainter(
                  object: ObjectModel(
                      0,
                      "",
                      0.0,
                      vm.curObject.right - vm.curObject.left,
                      0.0,
                      vm.curObject.bottom - vm.curObject.top,
                      ""
                  ),
                  isMine: vm.isMine,
                  isActive: vm.controller.activeID==vm.curObject.id
              ),
            ),
          ),
        ],
      ),
    );
  }
}
