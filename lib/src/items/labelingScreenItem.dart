import 'dart:io';

import 'package:bas_dataset_generator_engine/src/data/models/screenShootModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../assets/values/dimens.dart';
import '../dialogs/flyDlgDelete.dart';

class LabelingScreenItem extends HookWidget {
  const LabelingScreenItem(
      {Key? key,
      required this.screen,
      required this.isSelected,
      required this.onActionCaller})
      : super(key: key);

  final ScreenShootModel screen;
  final bool isSelected;

  final ValueSetter<String> onActionCaller;

  @override
  Widget build(BuildContext context) {
    final controller = FlyoutController();

    return GestureDetector(
      onTap: () => onActionCaller('show&&${screen.id}'),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Container(
          height: 80,
          width: 160,
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimens.actionRadius),
            border: isSelected
                ? Border.all(color: Colors.teal.lighter, width: 4)
                : null,
            image: DecorationImage(
              image: Image.file(File(screen.path!)).image,
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              if (isSelected && screen.sceneParts.isNotEmpty)
                Expanded(
                  child: IconButton(
                    style:
                        ButtonStyle(padding: ButtonState.all(EdgeInsets.zero)),
                    onPressed: () => onActionCaller('goto&&${screen.id}'),
                    icon: Container(
                      alignment: Alignment.center,
                      decoration:
                          BoxDecoration(color: Colors.black.withOpacity(.5)),
                      child: const Text('Show parts'),
                    ),
                  ),
                ),
              if ((screen.type != null && screen.type!.isNotEmpty)) ...[
                Positioned(
                  top: 5,
                  left: 5,
                  child: Container(
                    width: 10,
                    height: 10,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.green.lighter),
                  ),
                ),
                if (screen.description != null &&
                    screen.description!.isNotEmpty)
                  Positioned(
                    top: 5,
                    left: 18,
                    child: Container(
                      width: 10,
                      height: 10,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.magenta.lighter),
                    ),
                  ),
              ],
              Positioned(
                right: 0,
                bottom: 0,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FlyoutTarget(
                        key: GlobalKey(),
                        controller: controller,
                        child: IconButton(
                            style: ButtonStyle(
                                padding: ButtonState.all(EdgeInsets.all(2))),
                            icon: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.red),
                              child: const Icon(
                                FluentIcons.delete,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                            onPressed: () => showFlyDelete(
                                "Are you sure?",
                                "yeh",
                                controller,
                                FlyoutPlacementMode.topCenter,
                                screen.id!,
                                onActionCaller))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
