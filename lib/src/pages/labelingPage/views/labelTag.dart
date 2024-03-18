
import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/assets/values/textStyle.dart';
import 'package:bas_dataset_generator_engine/src/data/models/imageGroupModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class LabelTag extends HookWidget {
  LabelTag(
      {Key? key,
      required this.curGroup,
      required this.isSelected,
      required this.onLabelSelectedCaller})
      : super(key: key);

  ImageGroupModel curGroup;
  bool isSelected;
  ValueSetter<String> onLabelSelectedCaller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 3.0,right: 3.0),
      child: IconButton(
          style: ButtonStyle(padding: ButtonState.all(EdgeInsets.zero)),
          icon: Container(
            height: Dimens.tabHeightSmall + 10,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                    Radius.circular((Dimens.tabHeightSmall + 10 / 2))),
                border: Border.all(color: Colors.grey[160])),
            child: Row(
              children: [
                const SizedBox(width: 10,),
                Text(
                  "${curGroup.label.target!.name}.${curGroup.name}",
                  style: TextSystem.textS(Colors.white),
                ),
                const SizedBox(
                  width: 8,
                ),
                if (curGroup.subObjects.isNotEmpty)
                  Container(
                    width: Dimens.tabHeightSmall,
                    height: Dimens.tabHeightSmall,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey[180])),
                    child: Text(
                      curGroup.subObjects.length.toString(),
                      style: TextSystem.textM(Colors.teal),
                    ),
                  ),
                if(curGroup.subObjects.isEmpty)
                  IconButton(
                      style: ButtonStyle(padding: ButtonState.all(EdgeInsets.zero)),
                      icon: Container(
                        width: Dimens.tabHeightSmall,
                        height: Dimens.tabHeightSmall,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey[160])
                        ),
                        child: Icon(FluentIcons.calculator_multiply,size: 16,color: Colors.red,),
                      ),
                      onPressed: ()=>onLabelSelectedCaller("remove&&${curGroup.id}")
                  ),
                const SizedBox(
                  width: 5,
                ),
              ],
            ),
          ),
          onPressed: ()=>onLabelSelectedCaller("choose&&${curGroup.id}")),
    );
  }
}
