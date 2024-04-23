import 'dart:io';
import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/src/pages/cutToPiecesPage/views/flyImagesList.dart';
import 'package:bas_dataset_generator_engine/src/pages/exportReviewPage/viewModels/exportReviewViewModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/exportReviewPage/views/flyScreensList.dart';
import 'package:bas_dataset_generator_engine/src/pages/exportReviewPage/views/partRegionExplorer.dart';
import 'package:bas_dataset_generator_engine/src/parts/topBarPanel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:pmvvm/pmvvm.dart';

class ExportReviewPage extends StatelessWidget {
  String prjUUID;

  ExportReviewPage({
    super.key,
    required this.prjUUID});

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: () => const _View(),
      viewModel: ExportReviewViewModel(prjUUID),
    );
  }
}

class _View extends StatelessView<ExportReviewViewModel> {
  const _View({Key? key}) : super(key: key);

  @override
  Widget render(context, ExportReviewViewModel vm) {
    return ScaffoldPage(
        padding: const EdgeInsets.only(top: 0, bottom: 0),
        content: SizedBox.expand(
          child: Column(children: [
            TopBarPanel(
              title: Strings.exportReview,
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
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          image: vm.mainStates.isNotEmpty?DecorationImage(
                            image: Image.file(File(vm.mainStates[vm.indexImage].path!)).image,
                            fit: BoxFit.fill,
                          ):null,
                        ),
                        child: vm.mainStates.isNotEmpty? PartRegionExplorer(
                          key: GlobalKey(),
                          imgPath:vm.mainStates[vm.indexImage].path! ,
                          itsObjects: vm.mainStates[vm.indexImage].objects,
                          onObjectActionCaller: vm.onObjectActionHandler,
                        ):
                        Container(),
                      ),
                      Positioned(
                        top: (MediaQuery.sizeOf(context).height/2)-Dimens.actionBtnH/2,
                        right: 10,
                        left: 10,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: Dimens.actionBtnH,
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
                                    onPressed: vm.indexImage==0?null:() => vm.perviousImage()),
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
                                        onPressed: () => showFlyScreensList(
                                            vm.mainStates,
                                            vm.mainStates[vm.indexImage].objUUID!,
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
                                    onPressed: vm.mainStates.length-1==vm.indexImage?null:() => vm.nextImage()),
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