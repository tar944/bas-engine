import 'dart:io';

import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/assets/values/textStyle.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/labelingPage/viewModels/checkOtherStateViewModel.dart';
import 'package:bas_dataset_generator_engine/src/parts/dialogTitleBar.dart';
import 'package:bas_dataset_generator_engine/src/utility/enum.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class DlgCheckOtherState extends StatelessWidget {
  const DlgCheckOtherState(
      {Key? key,
        required this.allObjects,
        required this.srcObjects,
        required this.grpID,
        required this.prjUUID,
        required this.partUUID
      })
      : super(key: key);

  final List<ObjectModel> allObjects;
  final List<ObjectModel> srcObjects;
  final int grpID;
  final String prjUUID,partUUID;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: () => const _View(),
      viewModel: CheckOtherStateViewModel(allObjects, srcObjects,prjUUID,partUUID,grpID),
    );
  }
}

class _View extends StatelessView<CheckOtherStateViewModel> {
  const _View({Key? key}) : super(key: key);

  @override
  Widget render(context, CheckOtherStateViewModel vm) {
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
                    title: Strings.dlgOtherStateTitle,
                    onActionListener: vm.onCloseClicked,
                  ),
                  vm.allImages.isNotEmpty?
                  Stack(children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: SizedBox(
                        width: Dimens.dialogXLargeWidth - 40,
                        height: Dimens.dialogXLargeHeight - 160,
                        child: PageView(
                          physics: const NeverScrollableScrollPhysics(),
                          controller: vm.controller,
                          children: vm.allObjects.map((e) {
                            return Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[170]),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10.0))),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: vm.bigImage == "both" ? 1 : vm.bigImage == "src" ? 25 : 5,
                                      child: IconButton(
                                        onPressed: ()=>vm.changeImageSize("src"),
                                        icon: Stack(
                                          children: [
                                            Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: Image.file(File(vm.srcObjects[vm.curSrc].image.target!.path!)).image,
                                                fit: BoxFit.fitWidth,
                                              ),),),
                                            const Positioned(
                                              top:0.0,
                                              child: Text(Strings.srcState),)
                                          ]
                                        ),
                                      )),
                                  Expanded(
                                      flex: vm.bigImage == "both" ? 1 : vm.bigImage == "curState" ? 25 : 5,
                                      child: IconButton(
                                        onPressed: ()=>vm.changeImageSize("curState"),
                                        icon: Stack(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: Image.memory(vm.allImages[vm.curImage]).image,
                                                fit: BoxFit.fitWidth,
                                              ),
                                            ),
                                          ),
                                            const Positioned(
                                              top:0.0,
                                              child: Text(Strings.curState),)
                                          ]
                                        ),
                                      )),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    Positioned(
                        bottom: 10,
                        left: 460,
                        child: SmoothPageIndicator(
                          controller: vm.controller,
                          count: vm.allObjects.length,
                          effect: ScrollingDotsEffect(dotWidth: 10,dotHeight: 10,spacing:5,activeDotColor: Colors.teal.dark)
                        )
                    )
                  ]):
                  const SizedBox(
                    width: Dimens.dialogXLargeWidth - 40,
                    height: Dimens.dialogXLargeHeight - 160,
                    child: Expanded(
                      child: Column(
                        children: [
                          ProgressRing(),
                          SizedBox(height: 20,),
                          Text(Strings.waitingForImageProgressing)
                        ],
                      ),
                    ),
                  ),
                  vm.allImages.isNotEmpty?
                  Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10.0),bottomRight: Radius.circular(10.0)),
                          color: Colors.grey[190]
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                                style: ButtonStyle(
                                    padding: ButtonState.all(const EdgeInsets.all(15))
                                ),
                                icon: const Icon(FluentIcons.chevron_left,size: 20,),
                                onPressed: ()=>vm.previousImage()),
                            if(!vm.isObjectDone())
                              ...[
                                Padding(
                                  padding: const EdgeInsets.only(left:10.0,right: 10.0),
                                  child: Button(
                                    onPressed: () =>vm.actionBtnHandler("no"),
                                    style: ButtonStyle(
                                      backgroundColor: ButtonState.all(Colors.grey[160]),
                                    ),
                                    child: Container(
                                      height: Dimens.tabHeightSmall,
                                      width: Dimens.btnWidthNormal,
                                      alignment: Alignment.center,
                                      child: Text(
                                        Strings.no,
                                        style: TextSystem.textM(Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0,right: 10.0),
                                  child: Button(
                                    onPressed: ()=>vm.actionBtnHandler("yes"),
                                    style: ButtonStyle(
                                      backgroundColor: ButtonState.all(Colors.orange),
                                    ),
                                    child: Container(
                                      height: Dimens.tabHeightSmall,
                                      width: Dimens.btnWidthNormal,
                                      alignment: Alignment.center,
                                      child: Text(
                                        Strings.yes,
                                        style: TextSystem.textM(Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            if(vm.isObjectDone())
                              Padding(
                                padding: const EdgeInsets.only(left: 30,right: 30),
                                child: Text(Strings.objectSorted,style: TextSystem.textM(Colors.white),),
                              ),
                            IconButton(
                                style: ButtonStyle(
                                padding: ButtonState.all(const EdgeInsets.all(15))
                              ),
                                icon: const Icon(FluentIcons.chevron_right,size: 20,),
                                onPressed: ()=>vm.nextImage()
                            ),
                          ],
                        ),
                      )
                  ):
                  Container()
                ],
              ),
            )),
      ],
    );
  }
}
