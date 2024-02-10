import 'dart:io';
import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/assets/values/textStyle.dart';
import 'package:bas_dataset_generator_engine/src/data/models/projectPartModel.dart';
import 'package:bas_dataset_generator_engine/src/dialogs/flyDlgDelete.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ProjectPartItem extends HookWidget {
  ProjectPartItem({Key? key, required this.part, this.onActionCaller})
      : super(key: key);

  final ProjectPartModel part;

  final ValueSetter<String>? onActionCaller;

  @override
  Widget build(BuildContext context) {
    final controller = FlyoutController();
    print(part.description!.length);
    return Container(
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
              part.name!,
              style: TextSystem.textL(Colors.white),
            ),
            const SizedBox(height: 3,),
            Text(
              part.description!.length<75?part.description!:"${part.description!.substring(0,75)} ...",
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
                            part.id,
                            onActionCaller)),
                  ),
                  IconButton(
                      icon: Icon(
                        FluentIcons.edit,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: ()=> onActionCaller!("edit&&${part.id}")),
                  IconButton(
                      icon: Icon(
                        FluentIcons.photo2_add,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: ()=> onActionCaller!("chooseImages&&${part.id}")),
                  IconButton(
                      icon: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          color: Colors.red.dark
                        ),
                      ),
                      onPressed: ()=> onActionCaller!("record&&${part.id}")),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 145,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                    Radius.circular(Dimens.dialogCornerRadius)),
                color: Colors.grey[170],
                border: Border.all(color: Colors.magenta, width: 1.5),
                image: DecorationImage(
                  image: part.allGroups.isEmpty
                      ? const AssetImage('lib/assets/testImages/testImg1.png')
                      : Image.file(File(part.allGroups[0].allImages[0].path!))
                          .image,
                  fit: BoxFit.fill,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
