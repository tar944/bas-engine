import 'dart:io';
import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ImageItem extends HookWidget {
  const ImageItem({Key? key, required this.obj, this.onActionCaller})
      : super(key: key);

  final ObjectModel obj;
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
          image: Image.file(File(obj.image.target!.path)).image,
          fit: BoxFit.fill,
        ),
      ),
      child: IconButton(
          icon: Icon(
            FluentIcons.delete,
            color: Colors.red,
            size: 50,
          ),
          onPressed: () => onActionCaller!('delete&&${obj.id}')),
    );
  }
}
