import 'dart:io';

import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/assets/values/textStyle.dart';
import 'package:bas_dataset_generator_engine/src/pages/imageGroupPage/viewModels/imageGroupViewModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/imageGroupPage/views/imageGroupItem.dart';
import 'package:bas_dataset_generator_engine/src/pages/imageGroupPage/views/objectItem.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

typedef GroupController = void Function(BuildContext context, void Function() methodOfGroup);

class ImageGroups extends StatelessWidget {
  ImageGroups(
      {super.key, required this.partId, required this.onGroupActionCaller, required this.controller});

  int partId;
  ValueSetter<String> onGroupActionCaller;
  final GroupController controller;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: () => _View(controller: controller),
      viewModel: ImageGroupsViewModel(partId, onGroupActionCaller),
    );
  }
}

class _View extends StatelessView<ImageGroupsViewModel> {
  const _View({Key? key, required this.controller}) : super(key: key);

  final GroupController controller;

  @override
  Widget render(context, ImageGroupsViewModel vm) {
    controller.call(context, vm.createGroup);

    return SizedBox(
      height: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 90,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                    Radius.circular(Dimens.dialogCornerRadius)),
                border: Border.all(color: Colors.grey[170], width: 1.5),
                color: Colors.grey[210],
              ),
              child: Row(
                children: [
                  if (vm.objects.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(left: 6.0),
                      child: IconButton(
                        onPressed: vm.onBackClickHandler,
                        style: ButtonStyle(
                            padding: ButtonState.all(EdgeInsets.zero)),
                        icon: Container(
                            width: 140,
                            height: 75,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(
                                      Dimens.dialogCornerRadius - 3)),
                              border: Border.all(color: Colors.grey[150]),
                              image: vm.curGroup != null
                                  ? DecorationImage(
                                image: Image.file(File(vm.curGroup!.allObjects[0].image.target!.path!)).image,
                                fit: BoxFit.fill,
                              )
                                  : null,
                            ),
                            child: vm.curGroup == null
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("${vm.curGroup==null?vm.objects.length:0} ${Strings.images}"),
                                      const Text(Strings.remindImages),
                                    ],
                                  )
                                : Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(Radius.circular(Dimens.dialogCornerRadius - 3)),
                                        color: Colors.grey[190].withOpacity(0.7)),
                                    child: Row(
                                      children: [
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        const Icon(
                                          FluentIcons.back,
                                          size: 20,
                                        ),
                                        const SizedBox(
                                          width: 18,
                                        ),
                                        Text(
                                          Strings.back,
                                          style: TextSystem.textM(Colors.white),
                                        )
                                      ],
                                    ),
                                  )),
                      ),
                    ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 6.0, right: 6.0),
                      child: Container(
                          width: double.infinity,
                          height: 75,
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(Dimens.dialogCornerRadius - 3)),
                            color: Colors.grey[180],
                            border: Border.all(color: Colors.grey[150]),
                          ),
                          child: vm.groups.isEmpty ?
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(Strings.emptyGroup,
                              style: TextSystem.textL(Colors.white.withOpacity(0.7)),),
                          ) : Padding(
                            padding: const EdgeInsets.only(top: 5.0,bottom: 5.0,right: 5.0),
                            child: ListView.builder(
                              key: GlobalKey(),
                              itemCount: vm.groups.length,
                              controller: ScrollController(),
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return ImageGroupItem(
                                  group: vm.groups[index],
                                  onActionCaller: vm.onGroupSelect,
                                );
                              },
                            ),
                          ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: vm.objects.isNotEmpty
                  ? GridView(
                controller: ScrollController(keepScrollOffset: false),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                gridDelegate:
                const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 300,
                    childAspectRatio: 3.2 / 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20),
                children: vm.objects
                    .map((item) =>
                    ObjectItem(
                      key: GlobalKey(),
                      allGroups: vm.curGroup==null?vm.groups:[vm.curGroup!],
                      object: item,
                      isSubGroup:vm.curGroup!=null,
                      onActionCaller: vm.onObjectActionHandler,
                    ))
                    .toList(),
              )
                  : Column(
                      children: [
                        const SizedBox(
                          height: 150,
                        ),
                        Container(
                          height: 350,
                          width: 350,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image:
                                  AssetImage('lib/assets/images/emptyBox.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        Text(
                          Strings.emptyUnSortObjects,
                          style: TextSystem.textL(Colors.white),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
