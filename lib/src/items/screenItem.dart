import 'dart:io';

import 'package:bas_dataset_generator_engine/src/data/dao/videoDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/models/screenShootModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/videoModel.dart';
import 'package:bas_dataset_generator_engine/src/utility/directoryManager.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:fc_native_video_thumbnail/fc_native_video_thumbnail.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../assets/values/dimens.dart';
import '../../assets/values/textStyle.dart';
import '../dialogs/flyDlgDelete.dart';

class ScreenItem extends HookWidget {
  const ScreenItem({Key? key, required this.screen, this.onActionCaller})
      : super(key: key);

  final ScreenShootModel screen;
  final ValueSetter<String>? onActionCaller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        borderRadius:
            const BorderRadius.all(Radius.circular(Dimens.dialogCornerRadius)),
        color: Colors.grey[170],
        border: Border.all(color: Colors.magenta, width: 1.5),
        image: DecorationImage(
          image: Image.file(File(screen.path!)).image,
          fit: BoxFit.fill,
        ),
      ),
      child: IconButton(
          icon: Icon(
            FluentIcons.delete,
            color: Colors.red,
            size: 50,
          ),
          onPressed: () => onActionCaller!('delete&&${screen.id}')),
    );
  }
}
