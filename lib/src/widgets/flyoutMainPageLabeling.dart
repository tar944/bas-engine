import 'package:bas_dataset_generator_engine/src/data/models/labelingDataModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/screenShootModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../parts/LabelingDetails.dart';

class LabelingDetails extends HookWidget {
  const LabelingDetails(
      {Key? key, required this.onActionCaller, required this.data})
      : super(key: key);

  final LabelingDataModel data;
  final ValueSetter<String> onActionCaller;

  onSaveHandler(String newValue){
    onActionCaller('edit&&${data.getId()}&&$newValue');
  }

  @override
  Widget build(BuildContext context) {
    List<String> titleList = [
      'mainPage',
      'subPage',
      'dialog',
      'menu',
      'submenu',
      'rightMenu'
    ];
    return Container(
      height: 60,
      width: 595,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[200],
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Row(
          children: [
            Container(
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.grey[150], borderRadius: BorderRadius.circular(5)),
              child: Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Row(
                  children: [
                    FlyoutMainPageLabelingItem(
                      title: titleList[0],
                      isSelected: titleList[0]==data.getType(),
                      description: data.getDescription()!=null?data.getDescription()!:'',
                      onActionListener: onSaveHandler,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    FlyoutMainPageLabelingItem(
                      title: titleList[1],
                      isSelected: titleList[1]==data.getType(),
                      description: data.getDescription()!=null?data.getDescription()!:'',
                      onActionListener: onSaveHandler,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    FlyoutMainPageLabelingItem(
                      title: titleList[2],
                      isSelected: titleList[2]==data.getType(),
                      description: data.getDescription()!=null?data.getDescription()!:'',
                      onActionListener: onSaveHandler,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    FlyoutMainPageLabelingItem(
                      title: titleList[3],
                      isSelected: titleList[3]==data.getType(),
                      description: data.getDescription()!=null?data.getDescription()!:'',
                      onActionListener: onSaveHandler,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    FlyoutMainPageLabelingItem(
                      title: titleList[4],
                      isSelected: titleList[4]==data.getType(),
                      description: data.getDescription()!=null?data.getDescription()!:'',
                      onActionListener: onSaveHandler,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    FlyoutMainPageLabelingItem(
                      title: titleList[5],
                      isSelected: titleList[5]==data.getType(),
                      description: data.getDescription()!=null?data.getDescription()!:'',
                      onActionListener: onSaveHandler,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
