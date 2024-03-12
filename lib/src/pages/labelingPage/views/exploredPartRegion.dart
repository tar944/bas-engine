import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/src/controllers/regionRecController.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:bas_dataset_generator_engine/src/dialogs/flyDlgDelete.dart';
import 'package:bas_dataset_generator_engine/src/pages/labelingPage/viewModels/ExplorerPartViewModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/labelingPage/views/rectanglePainter.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class ExploredPartRegion extends StatelessWidget {
  ExploredPartRegion({
    Key? key,
    required this.curObject,
    required this.mainObject,
    required this.isMine,
    required this.isActive,
    required this.controller,
    required this.onObjectActionCaller,
  }) : super(key: key);

  ObjectModel curObject,mainObject;
  ValueSetter<String> onObjectActionCaller;
  bool isMine;
  bool isActive;
  RegionRecController controller;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: () => const _View(),
      viewModel: ExplorerPartViewModel(
          curObject,mainObject, isMine, isActive, controller, onObjectActionCaller),
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
      height: (vm.curObject.bottom - vm.curObject.top).abs() + 40,
      child: Stack(
        children: [
          if (vm.controller.activeID == vm.curObject.id)
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Container(
                width: vm.curObject.label.target==null? 62:vm.isMine?130:250,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                        Radius.circular(Dimens.actionRadius)),
                    border: Border.all(color: Colors.grey[150]),
                    color: Colors.grey[190]),
                child: Row(
                  children: [
                    if(vm.curObject.label.target==null)
                      ...[
                        IconButton(
                            icon: const Icon(FluentIcons.label),
                            onPressed: () => vm.onObjectActionCaller("labelManag&&${vm.curObject.id}")),
                        FlyoutTarget(
                            key: GlobalKey(),
                            controller: controller,
                            child: IconButton(
                                icon: Icon(
                                  FluentIcons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => showFlyDelete(
                                    Strings.deleteObject,
                                    Strings.yes,
                                    controller,
                                    FlyoutPlacementMode.topCenter,
                                    vm.curObject.id!,
                                    vm.onObjectActionCaller))),
                      ],
                    if(vm.curObject.label.target!=null&&vm.isMine)
                      ...[
                        IconButton(
                            icon: Icon(FluentIcons.calculator_multiply,color: Colors.red,),
                            onPressed: ()=>vm.onLabelHandler("remove")
                        ),
                        const SizedBox(width: 5,),
                        Text(vm.curObject.label.target!.name)
                      ],
                    if(vm.curObject.label.target!=null&&!vm.isMine)
                      ...[
                        const SizedBox(width: 5,),
                        vm.curObject.validObjects.contains(vm.mainObject)?
                          Text(vm.curObject.label.target!.name):
                          Text("Is label «${vm.curObject.label.target!.name}» valid here?"),
                        const Spacer(),
                        vm.curObject.validObjects.contains(vm.mainObject)?
                          IconButton(
                              icon: Icon(FluentIcons.remove_link,color: Colors.red.dark,size: 18,),
                              onPressed: ()=>vm.onLabelHandler("removeValidObject")
                          ):
                          IconButton(
                              icon: const Icon(FluentIcons.link,size: 18,),
                              onPressed: ()=>vm.onLabelHandler("addValidObject")
                          ),
                      ],
                  ],
                ),
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
                      ""),
                  color: vm.getColor(),
                  isActive: vm.controller.activeID == vm.curObject.id),
            ),
          ),
        ],
      ),
    );
  }
}
