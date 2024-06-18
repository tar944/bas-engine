import 'dart:io';

import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/src/data/models/imageGroupModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/labelingPage/viewModels/viewObjectsViewModel.dart';
import 'package:bas_dataset_generator_engine/src/parts/dialogTitleBar.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class DlgViewObjects extends StatelessWidget {
  const DlgViewObjects(
      {Key? key,
        required this.dlgW,
        required this.dlgH,
        required this.grpUUID,
        required this.subGroups,
        required this.allObjects,
        required this.showSubObjects,
        required this.showObjectId,
        required this.onActionCaller
      })
      : super(key: key);

  final List<ObjectModel> allObjects;
  final int showObjectId;
  final bool showSubObjects;
  final String grpUUID;
  final List<ImageGroupModel> subGroups;
  final double dlgW,dlgH;
  final ValueSetter<String> onActionCaller;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: () => const _View(),
      viewModel: ViewObjectsViewModel(grpUUID,dlgW,dlgH,subGroups,showSubObjects,allObjects,showObjectId),
    );
  }
}

class _View extends StatelessView<ViewObjectsViewModel> {
  const _View({Key? key}) : super(key: key);

  @override
  Widget render(context, ViewObjectsViewModel vm) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
            width: (vm.dlgW<430?430:vm.dlgW)+60,
            height: vm.dlgH+120,
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
                    title: Strings.dlgViewStates,
                    onActionListener: vm.onCloseClicked,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Container(
                      width: vm.dlgW<430?430:vm.dlgW,
                      height: vm.dlgH,
                      alignment: Alignment.center,
                      child: PageView(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: vm.controller,
                        children: vm.allObjects.map((e) {
                          return Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: Image.file(File(e.image.target!.path!)).image,
                                fit: BoxFit.contain,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
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
                            SizedBox(width: vm.dlgW<300?70:140,),
                            IconButton(
                                style: ButtonStyle(
                                    padding: ButtonState.all(const EdgeInsets.all(15))
                                ),
                                icon: const Icon(FluentIcons.chevron_left,size: 20,),
                                onPressed: ()=>vm.previousImage()),
                            const SizedBox(width: 10,),
                            SmoothPageIndicator(
                                controller: vm.controller,
                                count: vm.allObjects.length,
                                effect: ScrollingDotsEffect(dotWidth: 10,dotHeight: 10,spacing:5,activeDotColor: Colors.teal.dark)
                            ),
                            const SizedBox(width: 10,),
                            IconButton(
                                style: ButtonStyle(
                                padding: ButtonState.all(const EdgeInsets.all(15))
                              ),
                                icon: const Icon(FluentIcons.chevron_right,size: 20,),
                                onPressed: ()=>vm.nextImage()
                            ),
                            SizedBox(width:vm.dlgW<300?30: 100,),
                            IconButton(
                                style: ButtonStyle(
                                    padding: ButtonState.all(const EdgeInsets.all(15))
                                ),
                                icon: Icon(FluentIcons.delete,color: Colors.red,size: 20,),
                                onPressed: ()=>vm.onRemoveHandler()
                            ),
                          ],
                        ),
                      )
                  )
                ],
              ),
            )),
      ],
    );
  }
}
