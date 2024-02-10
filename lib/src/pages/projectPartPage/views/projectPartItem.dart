import 'dart:io';
import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/assets/values/textStyle.dart';
import 'package:bas_dataset_generator_engine/src/data/models/projectPartModel.dart';
import 'package:bas_dataset_generator_engine/src/dialogs/flyDlgDelete.dart';
import 'package:bas_dataset_generator_engine/src/pages/projectPartPage/viewModels/partItemViewModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:pmvvm/pmvvm.dart';

class ProjectPartItem extends StatelessWidget {
  ProjectPartItem({Key? key, required this.part, this.onActionCaller})
      : super(key: key);

  final ProjectPartModel part;
  final ValueSetter<String>? onActionCaller;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: () => const _View(),
      viewModel: PartItemViewModel(part,onActionCaller),
    );
  }
}

class _View extends StatelessView<PartItemViewModel> {
  const _View({Key? key}) : super(key: key);

  @override
  Widget render(context, PartItemViewModel vm) {
    final controller = FlyoutController();
    return IconButton(
      onPressed: () => vm.onActionCaller!("goto&&${vm.part.id}"),
      style: ButtonStyle(
          padding: ButtonState.all(const EdgeInsets.all(0.0))),
      icon: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          borderRadius:
          const BorderRadius.all(Radius.circular(Dimens.dialogCornerRadius)),
          color: Colors.grey[170],
          border: Border.all(color: Colors.magenta, width: 1.5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                vm.part.name!,
                style: TextSystem.textL(Colors.white),
              ),
              const SizedBox(
                height: 3,
              ),
              Text(
                vm.part.description!.length < 75
                    ? vm.part.description!
                    : "${vm.part.description!.substring(0, 75)} ...",
                style: TextSystem.textS(Colors.white.withOpacity(0.7)),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Row(
                  children: [
                    FlyoutTarget(
                      key: GlobalKey(),
                      controller: controller,
                      child: IconButton(
                          icon: Icon(
                            FluentIcons.delete,
                            color: Colors.red,
                            size: 20,
                          ),
                          onPressed: () => showFlyDelete(
                              "Are you sure?",
                              "yeh",
                              controller,
                              FlyoutPlacementMode.topCenter,
                              vm.part.id,
                              vm.onActionCaller)),
                    ),
                    IconButton(
                        icon: const Icon(
                          FluentIcons.edit,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () => vm.onActionCaller!("edit&&${vm.part.id}")),
                    IconButton(
                        icon: const Icon(
                          FluentIcons.photo2_add,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () =>
                            vm.onActionCaller!("chooseImages&&${vm.part.id}")),
                    IconButton(
                        icon: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                              color: Colors.red.dark),
                        ),
                        onPressed: () => vm.onActionCaller!("record&&${vm.part.id}")),
                  ],
                ),
              ),
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 145,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                          Radius.circular(Dimens.dialogCornerRadius)),
                      color: Colors.grey[170],
                      border: Border.all(color: Colors.magenta, width: 1.5),
                      image: DecorationImage(
                        image: vm.getImagePath()==""
                            ? const AssetImage(
                            'lib/assets/testImages/testImg1.png')
                            : Image.file(
                            File(vm.getImagePath())).image,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Positioned(
                      left: 9,
                      bottom: 9,
                      child: Container(
                        width: 28,
                        height: 28,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(14)),
                            color: Colors.grey[200].withOpacity(0.7)
                        ),
                        child: Text(vm.allImagesNumber.toString(),style: TextSystem.textXs(Colors.white),),
                      )),
                  Positioned(
                      left: 5,
                      bottom: 5,
                      child: ProgressRing(
                        value: vm.donePercent,
                        backgroundColor: Colors.magenta.withOpacity(0.3),
                        activeColor: vm.donePercent==100?Colors.teal:Colors.magenta,
                      )
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
