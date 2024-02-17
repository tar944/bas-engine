import 'dart:io';

import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/src/pages/labelingPage/viewModels/labelingViewModel.dart';
import 'package:bas_dataset_generator_engine/src/parts/topBarPanel.dart';
import 'package:bas_dataset_generator_engine/src/widgets/partRegionExplorer.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:pmvvm/pmvvm.dart';


class LabelingPage extends StatelessWidget {
  int groupId;
  String partUUID,prjUUID;
  String title;

  LabelingPage({
    super.key,
    required this.groupId ,
    required this.partUUID,
    required this.prjUUID,
    required this.title});

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: () => const _View(),
      viewModel: LabelingViewModel(partUUID,prjUUID,groupId,title),
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
                        image: DecorationImage(
                          image: Image.file(File(vm.curObject!.image.target!.path!)).image,
                          fit: (vm.imgW > MediaQuery.of(context).size.width ||
                              vm.imgH >
                                  (MediaQuery.of(context).size.height -
                                      Dimens.topBarHeight))
                              ? BoxFit.fill
                              : BoxFit.none,
                        ),
                      ),
                      child: PartRegionExplorer(
                        otherObjects: vm.subObjects.where((element) => element.uuid!=vm.curObject!.uuid).toList(),
                        itsObjects: vm.subObjects.where((element) => element.parentUUID==vm.curObject!.uuid).toList(),
                        onNewObjectHandler: vm.onNewPartCreatedHandler,
                      ),
                    ),
                    Positioned(
                      top: 350,
                      right: 0,
                      left: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              icon: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[170].withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Center(
                                      child: Icon(
                                        CupertinoIcons.left_chevron,
                                        color: Colors.white,
                                        size: 40,
                                      ))),
                              onPressed: () => vm.perviousImage()),
                          IconButton(
                              icon: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[170].withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Center(
                                      child: Icon(
                                        CupertinoIcons.right_chevron,
                                        color: Colors.white,
                                        size: 40,
                                      ))),
                              onPressed: () => vm.nextImage()),
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