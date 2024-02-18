import 'dart:io';

import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/src/dialogs/flyDlgDelete.dart';
import 'package:bas_dataset_generator_engine/src/pages/labelingPage/viewModels/labelingViewModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/labelingPage/views/flyImagesList.dart';
import 'package:bas_dataset_generator_engine/src/parts/topBarPanel.dart';
import 'package:bas_dataset_generator_engine/src/widgets/partRegionExplorer.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:pmvvm/pmvvm.dart';


class LabelingPage extends StatelessWidget {
  int groupId,objId;
  String partUUID,prjUUID;
  String title;

  LabelingPage({
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
      viewModel: LabelingViewModel(objId,partUUID,prjUUID,groupId,title),
    );
  }
}

class _View extends StatelessView<LabelingViewModel> {
  const _View({Key? key}) : super(key: key);

  @override
  Widget render(context, LabelingViewModel vm) {
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
                child:Stack(
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
                      child: PartRegionExplorer(
                        otherObjects: vm.subObjects.where((element) => element.uuid!=vm.curObject!.uuid).toList(),
                        itsObjects: vm.subObjects.where((element) => element.parentUUID==vm.curObject!.uuid).toList(),
                        onNewObjectHandler: vm.onNewPartCreatedHandler,
                      ),
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
                                          "Are you sure?",
                                          "yeh",
                                          vm.deleteController,
                                          FlyoutPlacementMode.right,
                                          vm.curObject!.id!,
                                          vm.doScreenAction)),
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
                                        FluentIcons.more,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                      onPressed: () => showFlyImagesList(
                                          vm.group!.allObjects,
                                          vm.curObject!.id!,
                                          vm.moreController,
                                          FlyoutPlacementMode.left,
                                          vm.doScreenAction),
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
              )
          ]),
        ));
  }
}