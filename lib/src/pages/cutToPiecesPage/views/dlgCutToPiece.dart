import 'dart:io';
import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/src/dialogs/flyDlgConfirm.dart';
import 'package:bas_dataset_generator_engine/src/pages/cutToPiecesPage/viewModels/dlgCutToPieceViewModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/cutToPiecesPage/views/partRegionExplorer.dart';
import 'package:bas_dataset_generator_engine/src/parts/dialogTitleBar.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class DlgCutToPiece extends StatelessWidget {
  const DlgCutToPiece(
      {Key? key,
        required this.groupId ,
        required this.partUUID,
        required this.prjUUID,
        required this.title,
        required this.onCloseCaller
      })
      : super(key: key);

  final int groupId;
  final String partUUID,prjUUID;
  final String title;
  final VoidCallback onCloseCaller;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: () => const _View(),
      viewModel: DlgCutToPieceViewModel(groupId,partUUID,prjUUID,title,onCloseCaller),
    );
  }
}

class _View extends StatelessView<DlgCutToPieceViewModel> {
  const _View({Key? key}) : super(key: key);

  @override
  Widget render(context, DlgCutToPieceViewModel vm) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
            width: Dimens.dialogXLargeWidth,
            height: Dimens.dialogXLargeHeight,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                    Radius.circular(Dimens.dialogCornerRadius)),
                color: Colors.grey[190],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  DialogTitleBar(
                    title: vm.title,
                    onActionListener: vm.onCloseClicked,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: SizedBox(
                      width: Dimens.dialogXLargeWidth,
                      height: Dimens.dialogXLargeHeight - Dimens.dialogTitleBarHeight,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: vm.imgSize.width,
                            height: vm.imgSize.height,
                            decoration: BoxDecoration(
                              image: vm.curObject!=null?DecorationImage(
                                image: Image.file(File(vm.curObject!.image.target!.path!)).image,
                                fit: (vm.imgW > MediaQuery.of(context).size.width ||
                                    vm.imgH > (MediaQuery.of(context).size.height - Dimens.dialogTitleBarHeight))
                                    ? BoxFit.fill : BoxFit.none,
                              ):null,
                            ),
                            child: vm.curObject!=null? PartRegionExplorer(
                              key: GlobalKey(),
                              mainObject: vm.curObject!,
                              minimumObjects: vm.minimizedObjects,
                              otherObjects: vm.subObject.where((element) => element.srcObject.target!=null&&element.srcObject.target!.uuid!=vm.curObject!.uuid).toList(),
                              itsObjects: vm.subObject.where((element) => element.srcObject.target!=null&&element.srcObject.target!.uuid==vm.curObject!.uuid).toList(),
                              onNewObjectCaller: vm.onNewPartCreatedHandler,
                              onObjectActionCaller: vm.onPartObjectHandler,
                              prjUUID: vm.prjUUID,
                              isSimpleAction: true,
                            ):
                            Container(),
                          ),
                          Positioned(
                            top: (Dimens.dialogXLargeHeight - Dimens.dialogTitleBarHeight-100)/2,
                            right: 10,
                            left: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: Dimens.btnWidthNormal,
                                  height: Dimens.actionBtnH,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[170].withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 5,),
                                      IconButton(
                                          style: ButtonStyle(padding: ButtonState.all(const EdgeInsets.all(8.0))),
                                          icon: const Icon(
                                            FluentIcons.chevron_left,
                                            color: Colors.white,
                                            size: 25,
                                          ),
                                          onPressed: () => vm.perviousImage()),
                                      const SizedBox(width: 5,),
                                      FlyoutTarget(
                                        key: GlobalKey(),
                                        controller: vm.confirmController,
                                        child: IconButton(
                                            style: ButtonStyle(padding: ButtonState.all(const EdgeInsets.all(8.0))),
                                            icon: Icon(
                                              FluentIcons.accept_medium,
                                              color: Colors.green.dark,
                                              size: 25,
                                            ),
                                            onPressed: () => showFlyConfirm(
                                                Strings.finishLabeling,
                                                Strings.yes,
                                                vm.confirmController,
                                                FlyoutPlacementMode.right,
                                                "confirm&&${vm.curObject!.id!}",
                                                vm.onObjectActionHandler)),
                                      ),

                                    ],
                                  ),
                                ),
                                Container(
                                  width: Dimens.actionBtnH,
                                  height: Dimens.actionBtnH,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[170].withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: IconButton(
                                      style: ButtonStyle(padding: ButtonState.all(const EdgeInsets.all(8.0))),
                                      icon: const Icon(
                                        FluentIcons.chevron_right,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                      onPressed: () => vm.nextImage()),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
