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

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        borderRadius:
            const BorderRadius.all(Radius.circular(Dimens.dialogCornerRadius)),
        color: Colors.grey[170],
        border: Border.all(color: Colors.magenta, width: 1.5),
        image: DecorationImage(
          image: part.allGroups.isEmpty
              ? const AssetImage('lib/assets/testImages/testImg1.png')
              : Image.file(File(part.allGroups[0].allImages[0].path!)).image,
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 35,
          ),
          IconButton(
              icon: Container(
                  width: 60,
                  height: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[190].withOpacity(0.5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 2),
                    child: Icon(
                      CupertinoIcons.add,
                      color: Colors.red.lightest,
                      size: 45,
                    ),
                  )),
              onPressed: () => onActionCaller!('record&&${part.id}')),
          const Spacer(),
          Container(
              height: 40,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  color: Colors.grey[190].withOpacity(0.7)),
              child: Row(
                children: [
                  Expanded(
                      flex: 14,
                      child: FlyoutTarget(
                          key: GlobalKey(),
                          controller: controller,
                          child: IconButton(
                              icon: Icon(
                                FluentIcons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () => showFlyDelete(
                                  "Are you sure?",
                                  "yeh",
                                  controller,
                                  FlyoutPlacementMode.topCenter,
                                  part.id,
                                  onActionCaller)))),
                  Expanded(
                      flex: 26,
                      child: IconButton(
                        onPressed: () => onActionCaller!('screens&&${part.id}'),
                        icon: Text(
                          'Screens',
                          style: TextSystem.textS(Colors.white),
                        ),
                      )),
                  Expanded(
                      flex: 60,
                      child: IconButton(
                        onPressed: () => onActionCaller!('labeling&&${part.id}'),
                        icon: Text(
                          'Labeling page',
                          style: TextSystem.textS(Colors.magenta.lighter),
                        ),
                      )),
                ],
              )),
        ],
      ),
    );
  }
}
