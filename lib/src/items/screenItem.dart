import 'dart:io';

import 'package:bas_dataset_generator_engine/src/data/models/screenShootModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../assets/values/dimens.dart';
import '../dialogs/flyDlgDelete.dart';

class ScreenItem extends HookWidget {
  const ScreenItem(
      {Key? key, required this.screen,required this.isSelected, required this.onActionCaller})
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
            border: isSelected ? Border.all(color: Colors.teal.lighter,width: 4):null,
            image: DecorationImage(
              image: Image.file(File(screen.path!)).image,
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              if(screen.status=='finished')
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.5)
                    ),
                    child: const Icon(FluentIcons.accept_medium,size: 35,),
                  ),
                ),
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
                            icon: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.red
                              ),
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
