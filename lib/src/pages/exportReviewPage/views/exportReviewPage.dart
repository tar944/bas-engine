import 'dart:io';
import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/assets/values/textStyle.dart';
import 'package:bas_dataset_generator_engine/src/pages/exportReviewPage/viewModels/exportReviewViewModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/exportReviewPage/views/partRegionExplorer.dart';
import 'package:bas_dataset_generator_engine/src/pages/exportReviewPage/views/screenItem.dart';
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
              title: '${Strings.exportReview} (${vm.indexImage+1} of ${vm.curStates.length})',
              needBack: true,
              needHelp: true,
              onBackCaller: vm.onBackClicked,
            ),
              vm.mainObject!=null?
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - (Dimens.topBarHeight),
                color: Colors.grey[180],
                child:Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        image: vm.allStates.isNotEmpty?DecorationImage(
                          image: Image.file(File(vm.curStates[vm.indexImage].path!)).image,
                          fit: BoxFit.fill,
                        ):null,
                      ),
                      child: vm.allStates.isNotEmpty? PartRegionExplorer(
                        key: GlobalKey(),
                        imgPath:vm.allStates[vm.indexImage].path! ,
                        mainObject: vm.mainObject!,
                        allObjects: vm.curObjects,
                        isKeyActive:vm.isPartKeyActive,
                        onActionCaller: vm.onPartActionHandler,
                        isSelectionMode:vm.isSelection
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
                            width: Dimens.btnWidthNormal,
                            height: Dimens.actionBtnH,
                            decoration: BoxDecoration(
                              color: Colors.grey[170].withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 5,),
                                Focus(
                                  canRequestFocus: false,
                                  descendantsAreFocusable: false,
                                  child: IconButton(
                                    style: ButtonStyle(padding: ButtonState.all(const EdgeInsets.all(8.0))),
                                    icon: const Icon(
                                      FluentIcons.chevron_left,
                                      color: Colors.white,
                                      size: 25,
                                    ),
                                    onPressed: vm.indexImage==0?null:() => vm.perviousImage()),
                                ),
                                const SizedBox(width: 5,),
                                Focus(
                                  canRequestFocus: false,
                                  descendantsAreFocusable: false,
                                  child: IconButton(
                                      style: ButtonStyle(padding: ButtonState.all(const EdgeInsets.all(8.0))),
                                      icon: Icon(
                                        FluentIcons.cloud_import_export,
                                        color: Colors.teal,
                                        size: 25,
                                      ),
                                      onPressed:()=> vm.onExportBtnHandler()),
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
                                const SizedBox(width: 8,),
                                Focus(
                                  canRequestFocus: false,
                                  descendantsAreFocusable: false,
                                  child: IconButton(
                                    style: ButtonStyle(padding: ButtonState.all(const EdgeInsets.all(10.0))),
                                    onPressed: vm.onChangeState,
                                    icon: Icon(FluentIcons.delete,size: 22,color: vm.isBinState?Colors.black:Colors.red.dark,),
                                  ),
                                ),
                                const SizedBox(width: 5,),
                                Focus(
                                  canRequestFocus: false,
                                  descendantsAreFocusable: false,
                                  child: IconButton(
                                    style: ButtonStyle(padding: ButtonState.all(const EdgeInsets.all(8.0))),
                                    icon: const Icon(
                                      FluentIcons.chevron_right,
                                      color: Colors.white,
                                      size: 25,
                                    ),
                                    onPressed: vm.allStates.length-1==vm.indexImage?null:() => vm.nextImage()),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if(vm.processedNumber!=-1)
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[190].withOpacity(.7)
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(vm.processedNumber==-2?Strings.waitToUploadFile:Strings.waitToGenerateFile,style: TextSystem.textL(Colors.white),),

                            const SizedBox(height: 30,),
                            SizedBox(
                              width: 300,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: vm.processedNumber==-2?
                                    const ProgressRing():
                                    ProgressBar(
                                      key: GlobalKey(),
                                      value: vm.percent.toDouble(),
                                      activeColor: Colors.teal.dark,
                                    ),
                                  ),
                                  if(vm.processedNumber!=-2)
                                    ...[
                                      const SizedBox(width: 10,),
                                      Text("( ${vm.processedNumber} of ${vm.allStates.length})",style: TextSystem.textS(Colors.grey[100]),)
                                    ]
                                ],
                              ),
                            )
                          ],),
                        )),
                    Positioned(
                      left: 10,
                        right: 10,
                        bottom: vm.isListUp?10:-170,
                        child: SizedBox(
                          height: 210,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Row(
                                children: [
                                  Focus(
                                    canRequestFocus: false,
                                    descendantsAreFocusable: false,
                                    child: IconButton(
                                      style: ButtonStyle(
                                        padding: ButtonState.all(EdgeInsets.zero)
                                      ),
                                      onPressed: vm.changeListPosition,
                                      icon: Container(
                                        height: Dimens.btnHeightBig,
                                        width: Dimens.btnWidthNormal+(vm.isListUp?15:0),
                                        decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                                        color: Colors.grey[180]
                                      ),
                                        child: Row(
                                        children: [
                                          const SizedBox(width: 10,),
                                          Text(vm.isListUp?Strings.pressDown:Strings.pressUp),
                                          const SizedBox(width: 10,),
                                          Icon(vm.isListUp?FluentIcons.down:FluentIcons.up)
                                        ],
                                      ),
                                    ),
                            ),
                                  ),
                                  const SizedBox(width: 5,),
                                  IconButton(
                                      style: ButtonStyle(
                                          padding: ButtonState.all(EdgeInsets.zero)
                                      ),
                                      icon: Container(
                                        width: Dimens.btnHeightBig-5,
                                        height: Dimens.btnHeightBig-5,
                                        decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(Radius.circular(5)),
                                            color: Colors.grey[180]
                                        ),
                                        child: const Icon(FluentIcons.view_list),
                                      ),
                                      onPressed: vm.onExportNameHandler),
                                  const SizedBox(width: 5,),
                                  if(vm.isListUp)
                                    Container(
                                      height: Dimens.btnHeightBig-10,
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(Radius.circular(7)),
                                          color: Colors.grey[180]
                                      ),
                                      child: Row(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(left: 7,right: 5),
                                            child: Text(Strings.pageMode),
                                          ),
                                          Focus(
                                            canRequestFocus: false,
                                            descendantsAreFocusable: false,
                                            child: IconButton(
                                                style: ButtonStyle(
                                                  padding: ButtonState.all(EdgeInsets.zero)
                                                ),
                                                icon: Container(
                                                  width: Dimens.btnWidthNormal-20,
                                                  decoration: vm.isSelection?BoxDecoration(
                                                    color: Colors.teal.dark,
                                                    borderRadius: const BorderRadius.all(Radius.circular(4))
                                                  ):null,
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(top: 3,bottom: 3),
                                                    child: Text(Strings.selection,style: TextSystem.textXs(Colors.white),),
                                                  ),
                                                ),
                                                onPressed: vm.changePageType),
                                          ),
                                          const SizedBox(width: 5,),
                                          Focus(
                                            canRequestFocus: false,
                                            descendantsAreFocusable: false,
                                            child: IconButton(
                                                style: ButtonStyle(
                                                    padding: ButtonState.all(EdgeInsets.zero)
                                                ),
                                                icon: Container(
                                                  width: Dimens.btnWidthNormal-20,
                                                  decoration: !vm.isSelection?BoxDecoration(
                                                      color: Colors.teal.dark,
                                                      borderRadius: const BorderRadius.all(Radius.circular(4))
                                                  ):null,
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(top: 3,bottom: 3),
                                                    child: Text(Strings.division,style: TextSystem.textXs(Colors.white),),
                                                  ),
                                                ),
                                                onPressed: vm.changePageType),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              )),
                            Container(
                              height: 170,
                              width:  MediaQuery.of(context).size.width-20,
                              decoration: BoxDecoration(
                                color: Colors.grey[180],
                                borderRadius: BorderRadius.circular(10)
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width:220,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Focus(
                                            canRequestFocus: false,
                                            descendantsAreFocusable: false,
                                            child: IconButton(
                                                icon: const Icon(FluentIcons.chevron_left),
                                                onPressed: vm.groupIndex==0?null:vm.perviousGroup),
                                          ),
                                          Text(vm.getGroupName(),style: TextSystem.textM(Colors.white),),
                                          Focus(
                                            canRequestFocus: false,
                                            descendantsAreFocusable: false,
                                            child: IconButton(
                                                icon: const Icon(FluentIcons.chevron_right),
                                                onPressed: vm.groupIndex+1==vm.mainGroups.length?null:vm.nextGroup),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10,left: 10),
                                    child: Container(
                                      width:  MediaQuery.of(context).size.width-30,
                                      height: 110,
                                      decoration: BoxDecoration(
                                          color: Colors.grey[170],
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: vm.mainObject!=null?ListView.builder(
                                          itemCount: vm.curStates.length,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            return ScreenItem(
                                              key: GlobalKey(),
                                              isSelected:vm.curStates[index].objUUID==vm.mainObject!.uuid,
                                              object: vm.curStates[index],
                                              showObject: !vm.banStatesUUID.contains('${vm.curStates[index].objUUID!}&&'),
                                              onActionCaller: vm.onObjectActionHandler,
                                            );
                                          }):Container(),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ]),
                        )
                    )
                  ],
                ),
              ):
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height - (Dimens.topBarHeight),
                    color: Colors.grey[180],
                    alignment: Alignment.center,
                    child: Column(children: [
                      const SizedBox(height: 200,),
                      Text(Strings.waiting,style: TextSystem.textM(Colors.white))
                    ],),
                  )
          ]),
        ));
  }
}