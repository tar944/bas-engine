import 'package:bas_dataset_generator_engine/src/data/models/screenShootModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../widgets/partRegionExplorer.dart';


class LabelingItem extends HookWidget {
  const LabelingItem(   {
    Key? key,
    required this.item,
    required this.itemBottom,
    required this.nextClick,
    required this.perviousClick,
  }) : super(key: key);
  final ScreenShootModel item;
  final List<ScreenShootModel> itemBottom;
  final VoidCallback nextClick;
  final VoidCallback perviousClick;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(item.imageName!),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned.fill(child: PartRegionExplorer()),
        Positioned(
          top: 350,
          right: 0,
          left: 0,
          child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                icon: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[170].withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                        child: Icon(
                          CupertinoIcons.left_chevron,
                          color: Colors.white,
                          size: 40,
                        ))),
                onPressed:() =>perviousClick()),

            IconButton(
                icon: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[170].withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                        child: Icon(
                          CupertinoIcons.right_chevron,
                          color: Colors.white,
                          size: 40,
                        ))),
                onPressed: () =>nextClick()),
          ],
        ),)
      ],
    );
  }
}
