
import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/assets/values/textStyle.dart';
import 'package:bas_dataset_generator_engine/src/data/models/imageGroupModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/labelingPage/views/labelTag.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class LabelBodyTagLine extends HookWidget {
  LabelBodyTagLine(
      {Key? key,
      required this.subGroups,
      required this.curGroup,
        required this.isParentGroup,
      required this.onLabelActionHandler})
      : super(key: key);

  List<ImageGroupModel> subGroups;
  ImageGroupModel? curGroup;
  bool isParentGroup;
  ValueSetter<String> onLabelActionHandler;

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: Dimens.tabHeightSmall+20,
      child: Row(
        children: [
          if(isParentGroup)
            ...[
              IconButton(
                  style: ButtonStyle(padding: ButtonState.all(EdgeInsets.zero)),
                  icon: Container(
                    width: Dimens.tabHeightSmall*2.8,
                    height: Dimens.tabHeightSmall+10,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular((Dimens.tabHeightSmall+10/2))),
                        border: Border.all(color: Colors.grey[160])
                    ),
                    child: Text(Strings.showStates,style: TextSystem.textS(Colors.white),),
                  ),
                  onPressed: ()=>onLabelActionHandler("allStates")
              ),
              const SizedBox(width: 6.0,),
              IconButton(
                  style: ButtonStyle(padding: ButtonState.all(EdgeInsets.zero)),
                  icon: Container(
                    width: Dimens.tabHeightSmall*2.8,
                    height: Dimens.tabHeightSmall+10,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular((Dimens.tabHeightSmall+10/2))),
                        border: Border.all(color: Colors.grey[160])
                    ),
                    child: Text(Strings.showStates,style: TextSystem.textS(Colors.white),),
                  ),
                  onPressed: ()=>onLabelActionHandler("allStates")
              ),
              const SizedBox(width: 10,),
            ],
          Container(
            height: Dimens.tabHeightSmall+20,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(Dimens.tabHeightSmall+10)),
              border: Border.all(color: Colors.grey[150]),
              color: Colors.grey[210]
            ),
            child: Row(
              children: [
                const SizedBox(width: 4.0,),
                IconButton(
                      style: ButtonStyle(
                          padding: ButtonState.all(EdgeInsets.zero)),
                      icon: Container(
                        width: Dimens.tabHeightSmall + 10,
                        height: Dimens.tabHeightSmall + 10,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey[160])),
                        child: Icon(
                          FluentIcons.add,
                          size: 18,
                          color: Colors.orange.dark,
                        ),
                      ),
                      onPressed: () => onLabelActionHandler("showDialog&&")),
                  const SizedBox(width: 10,),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width-(isParentGroup?240:131),
                  child: ListView.builder(
                      key: GlobalKey(),
                      itemCount: subGroups.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return LabelTag(
                          curGroup: subGroups[index],
                          isSelected: curGroup==null || subGroups[index].id!=curGroup!.id?false:true,
                          onLabelSelectedCaller: onLabelActionHandler,
                        );
                      }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
