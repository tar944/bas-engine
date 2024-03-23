import 'dart:io';

import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/src/dialogs/flyDlgDelete.dart';
import 'package:bas_dataset_generator_engine/src/pages/cutToPiecesPage/viewModels/cutToPiecesViewModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/cutToPiecesPage/views/flyImagesList.dart';
import 'package:bas_dataset_generator_engine/src/pages/cutToPiecesPage/views/partRegionExplorer.dart';
import 'package:bas_dataset_generator_engine/src/parts/topBarPanel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:pmvvm/pmvvm.dart';

class CutToPiecesPage extends StatelessWidget {
  int groupId,objId;
  String partUUID,prjUUID;
  String title;

  CutToPiecesPage({
    super.key,
    required this.groupId ,
    required this.objId,
    required this.partUUID,
    required this.prjUUID,
    required this.title});

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: () => const _View(),
      viewModel: CutToPiecesViewModel(objId,partUUID,prjUUID,groupId,title),
    );
  }
}

class _View extends StatelessView<CutToPiecesViewModel> {
  const _View({Key? key}) : super(key: key);

  @override
  Widget render(context, CutToPiecesViewModel vm) {
    return ScaffoldPage(
        padding: const EdgeInsets.only(top: 0, bottom: 0),
        content: SizedBox.expand(
          child: Column(children: [
            TopBarPanel(
              title: vm.title,
              needBack: true,
              needHelp: false,
              onBackCaller: vm.onBackClicked,
            ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - (Dimens.topBarHeight),
                color: Colors.grey[180],
                child:Listener(
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
                                vm.imgH >
                                    (MediaQuery.of(context).size.height -
                                        Dimens.topBarHeight))
                                ? BoxFit.fill
                                : BoxFit.none,
                          ):null,
                        ),
                        child: vm.curObject!=null?PartRegionExplorer(
                          key: GlobalKey(),
                          mainObject: vm.curObject!,
                          otherObjects: vm.otherStates.where((element) => element.parentUUID!=vm.curObject!.uuid).toList(),
                          itsObjects: vm.otherStates.where((element) => element.parentUUID==vm.curObject!.uuid).toList(),
                          onNewObjectCaller: vm.onNewPartCreatedHandler,
                          onRegionActionCaller: vm.onRegionActionHandler,
                          prjUUID: vm.prjUUID,
                          isSimpleAction: vm.pageDuty!="drawMainRectangle",
                        ):Container(),
                      ),
                      Positioned(
                        top: (MediaQuery.sizeOf(context).height/2)-Dimens.actionBtnH/2,
                        right: 10,
                        left: 10,
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
                                    controller: vm.deleteController,
                                    child: IconButton(
                                        style: ButtonStyle(padding: ButtonState.all(const EdgeInsets.all(8.0))),
                                        icon: Icon(
                                          FluentIcons.delete,
                                          color: Colors.red,
                                          size: 25,
                                        ),
                                        onPressed: () => showFlyDelete(
                                            Strings.deleteScreen,
                                            Strings.yes,
                                            vm.deleteController,
                                            FlyoutPlacementMode.right,
                                            vm.curObject!.id!,
                                            vm.onObjectActionHandler)),
                                  ),

                                ],
                              ),
                            ),
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
                                  FlyoutTarget(
                                    key: GlobalKey(),
                                    controller: vm.moreController,
                                    child: IconButton(
                                        style: ButtonStyle(padding: ButtonState.all(const EdgeInsets.all(8.0))),
                                        icon: const Icon(
                                          FluentIcons.password_field,
                                          color: Colors.white,
                                          size: 25,
                                        ),
                                        onPressed: () => showFlyImagesList(
                                            vm.group!.otherStates,
                                            vm.curObject!.id!,
                                            vm.moreController,
                                            FlyoutPlacementMode.left,
                                            vm.onObjectActionHandler),
                                    ),
                                  ),
                                  const SizedBox(width: 5,),
                                  IconButton(
                                    style: ButtonStyle(padding: ButtonState.all(const EdgeInsets.all(8.0))),
                                    icon: const Icon(
                                      FluentIcons.chevron_right,
                                      color: Colors.white,
                                      size: 25,
                                    ),
                                    onPressed: () => vm.nextImage()),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
          ]),
        ));
  }
}