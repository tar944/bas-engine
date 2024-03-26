import 'dart:io';
import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/assets/values/textStyle.dart';
import 'package:bas_dataset_generator_engine/src/data/models/imageGroupModel.dart';
import 'package:bas_dataset_generator_engine/src/dialogs/flyDlgConfirm.dart';
import 'package:bas_dataset_generator_engine/src/pages/labelingPage/viewModels/imageItemViewModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:pmvvm/pmvvm.dart';

class ImageItem extends StatelessWidget {
  ImageItem({Key? key, required this.group, this.onActionCaller})
      : super(key: key);

  final ImageGroupModel group;
  final ValueSetter<String>? onActionCaller;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: () => const _View(),
      viewModel: ImageItemViewModel(group,onActionCaller),
    );
  }
}

class _View extends StatelessView<ImageItemViewModel> {
  const _View({Key? key}) : super(key: key);

  @override
  Widget render(context, ImageItemViewModel vm) {
    final controller = FlyoutController();
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: IconButton(
        onPressed: () => vm.onActionCaller!("goto&&${vm.group.id}"),
        style: ButtonStyle(
            padding: ButtonState.all(const EdgeInsets.all(0.0))),
        icon: Container(
          width: 100,
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius:
            const BorderRadius.all(Radius.circular(Dimens.dialogCornerRadius-3)),
            border: Border.all(color: Colors.grey[150], width: 1.0),
            image: DecorationImage(
              image: vm.group.subObjects.isEmpty
                  ? const AssetImage(
                  'lib/assets/testImages/testImg1.png')
                  : Image.file(
                  File(vm.group.subObjects[0].image.target!.path!)).image,
              fit: BoxFit.fill,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                  top:0,
                  left:0,
                  right:0,
                  bottom:0,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(Dimens.dialogCornerRadius-3)),
                      color: Colors.grey[170].withOpacity(.7),
                    ),
                  )
              ),
              Padding(
                padding: const EdgeInsets.only(left:3,right: 3),
                child: Text(
                  vm.group.name!,
                  style: TextSystem.textS(Colors.white),
                  textAlign: TextAlign.left,
                ),
              ),
              Positioned(
                left: 0,
                bottom: 0,
                child: Row(
                  children: [
                    FlyoutTarget(
                      key: GlobalKey(),
                      controller: controller,
                      child: IconButton(
                          icon: Icon(
                            FluentIcons.delete,
                            color: Colors.red,
                            size: 12,
                          ),
                          onPressed: () => showFlyConfirm(
                              "Are you sure?",
                              "yeh",
                              controller,
                              FlyoutPlacementMode.topCenter,
                              "delete&&${vm.group.id}",
                              vm.onActionCaller)),
                    ),
                    IconButton(
                        icon: const Icon(
                          FluentIcons.edit,
                          color: Colors.white,
                          size: 12,
                        ),
                        onPressed: () => vm.onActionCaller!("edit&&${vm.group.id}")),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
