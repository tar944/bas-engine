import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/assets/values/textStyle.dart';
import 'package:bas_dataset_generator_engine/src/models/pageItemModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class LabelingItem extends HookWidget {
  const LabelingItem(   {
    Key? key,
    required this.item,
    required this.itemBottom,
    required this.nextClick,
    required this.perviousClick,
  }) : super(key: key);
  final PageItemModel item;
  final List<PageItemModel> itemBottom;
  final VoidCallback nextClick;
  final VoidCallback perviousClick;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(item.imagePath!),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          Row(
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
          ),
          Spacer(),

        ],
      ),

    );
  }
}
