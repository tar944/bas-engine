import 'dart:io';
import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/assets/values/textStyle.dart';
import 'package:bas_dataset_generator_engine/src/data/models/imageGroupModel.dart';
import 'package:bas_dataset_generator_engine/src/dialogs/flyDlgDelete.dart';
import 'package:bas_dataset_generator_engine/src/pages/imageGroupPage/viewModels/groupItemViewModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:pmvvm/pmvvm.dart';

class ImageGroupItem extends StatelessWidget {
  ImageGroupItem({Key? key, required this.group, this.onActionCaller})
      : super(key: key);

  final ImageGroupModel group;
  final ValueSetter<String>? onActionCaller;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: () => const _View(),
      viewModel: GroupItemViewModel(group,onActionCaller),
    );
  }
}

class _View extends StatelessView<GroupItemViewModel> {
  const _View({Key? key}) : super(key: key);

  @override
  Widget render(context, GroupItemViewModel vm) {
    final controller = FlyoutController();
    return IconButton(
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
            image: vm.group.mainImage.target ==null
                ? const AssetImage(
                'lib/assets/testImages/testImg1.png')
                : Image.file(
                File(vm.group.mainImage.target!.path!)).image,
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
            Text(
              vm.group.name!,
              style: TextSystem.textM(Colors.white),
            ),
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
                            vm.group.id,
                            vm.onActionCaller)),
                  ),
                  IconButton(
                      icon: const Icon(
                        FluentIcons.edit,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () => vm.onActionCaller!("edit&&${vm.group.id}")),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}