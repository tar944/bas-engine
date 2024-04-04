import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/assets/values/textStyle.dart';
import 'package:bas_dataset_generator_engine/src/controllers/regionRecController.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:bas_dataset_generator_engine/src/dialogs/flyDlgConfirm.dart';
import 'package:bas_dataset_generator_engine/src/pages/cutToPiecesPage/viewModels/ExplorerPartViewModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/cutToPiecesPage/views/rectanglePainter.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class ExploredPartRegion extends StatelessWidget {
  ExploredPartRegion({
    Key? key,
    required this.curObject,
    required this.mainObject,
    required this.isMine,
    required this.isSimpleAction,
    required this.controller,
    required this.onObjectActionCaller,
  }) : super(key: key);

  final ObjectModel curObject, mainObject;
  final ValueSetter<String> onObjectActionCaller;
  final bool isMine,isSimpleAction;
  final RegionRecController controller;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: () => const _View(),
      viewModel: ExplorerPartViewModel(curObject, mainObject, isMine,isSimpleAction,
          controller, onObjectActionCaller),
    );
  }
}

class _View extends StatelessView<ExplorerPartViewModel> {
  const _View({Key? key}) : super(key: key);

  @override
  Widget render(context, ExplorerPartViewModel vm) {
    final controller = FlyoutController();
    return SizedBox(
      width: vm.isMaximize?(vm.curObject.right - vm.curObject.left).abs():40,
      height: vm.isMaximize?(vm.curObject.bottom - vm.curObject.top).abs():40,
      child: Opacity(
        opacity: vm.isMaximize?1.0:0.3,
        child: Stack(
          children: [
            CustomPaint(
              painter: RectanglePainter(
                  object: ObjectModel(0, "", 0.0,
                      vm.isMaximize?vm.curObject.right - vm.curObject.left:40,
                      0.0,
                      vm.isMaximize?vm.curObject.bottom - vm.curObject.top:40,
                  ),
                  color: vm.isMine?Colors.blue.dark:Colors.orange.dark,
                  isActive: vm.controller.activeID == vm.curObject.id),
            ),
            if(vm.isSimpleAction)
              Positioned(
                  right: 5,
                  bottom: 5,
                  child: Row(
                    children: [
                      vm.isMaximize&&vm.isMine?
                      FlyoutTarget(
                        key: GlobalKey(),
                        controller: controller,
                        child:
                        IconButton(
                          style: ButtonStyle(
                            backgroundColor: ButtonState.all(Colors.grey[180].withOpacity(.7))
                          ),
                            icon: Icon(
                              FluentIcons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () => showFlyConfirm(
                                Strings.deleteObject,
                                Strings.yes,
                                controller,
                                FlyoutPlacementMode.topCenter,
                                "delete&&${vm.curObject.id!}",
                                vm.onObjectActionCaller)),
                      ):
                      Container(),
                      const SizedBox(width: 5,),
                      IconButton(
                          style: ButtonStyle(
                              backgroundColor: ButtonState.all(Colors.grey[180].withOpacity(.7))
                          ),
                          icon: Icon(
                            vm.isMaximize?FluentIcons.arrow_up_right_mirrored8:FluentIcons.arrow_down_right8,
                            color: Colors.white,
                          ),
                          onPressed: () => vm.onShowHandler())
                    ],
                  )),
            if(!vm.isSimpleAction)
              Positioned(
                  left: 5,
                  top: 5,
                  child: Container(
                    width: 300,
                    height: 120,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[170]),
                      borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                      color: Colors.grey[190]
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width:350,child: Text(Strings.selectAsMainRectangle,style: TextSystem.textM(Colors.white),)),
                          const SizedBox(height: 10,),
                          Row(
                            children: [
                            Button(
                                style:ButtonStyle(
                                    padding: ButtonState.all(EdgeInsets.zero)
                                ),
                                child: Container(
                                    width: Dimens.btnWidthNormal,
                                    height: Dimens.btnHeightBig,
                                    alignment: Alignment.center,
                                    child: const Text(Strings.cancel)),
                                onPressed: ()=> vm.onObjectActionCaller("removeRegion")),
                            const SizedBox(width: 10,),
                            Button(
                                style:ButtonStyle(
                                    padding: ButtonState.all(EdgeInsets.zero)
                                ),
                                child: Container(
                                    width: Dimens.btnWidthNormal,
                                    height: Dimens.btnHeightBig,
                                    color: Colors.teal.dark,
                                    alignment: Alignment.center,
                                    child: Text(Strings.yes)),
                                onPressed: ()=>vm.onObjectActionCaller("confirmRegion")),
                          ],)
                        ],
                      ),
                    ),
                  ))
          ],
        ),
      ),
    );
  }
}
