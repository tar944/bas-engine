import 'dart:io';

import 'package:bas_dataset_generator_engine/src/data/models/screenShootModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../assets/values/dimens.dart';

class ScreenItem extends HookWidget {
  const ScreenItem({Key? key, required this.screen,required this.onActionCaller})
      : super(key: key);

  final ScreenShootModel screen;

  final ValueSetter<String> onActionCaller;

  @override
  Widget build(BuildContext context) {
    final controller = FlyoutController();

    return GestureDetector(
      onTap: () => onActionCaller!('tap&&${screen.id}'),
      child: Padding(
        padding:
        const EdgeInsets.all(5),
        child: Container(
          height: 80,
          width: 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimens.actionRadius),
            image: DecorationImage(
              image: Image.file(File(screen.path!)).image,
              fit: BoxFit.cover,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding:
                const EdgeInsets.all(5),
                child:
                Container(
                  width: 25,
                  height: 25,
                  decoration:
                  BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.red,
                  ),
                  child: Icon(CupertinoIcons.delete, color: Colors.white, size: 15,),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
