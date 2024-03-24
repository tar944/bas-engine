
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
      required this.onLabelActionHandler})
      : super(key: key);

  List<ImageGroupModel> subGroups;
  ImageGroupModel? curGroup;
  ValueSetter<String> onLabelActionHandler;

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: MediaQuery.sizeOf(context).width-40,
      height: Dimens.tabHeightSmall+10,
      child: Row(
        children: [
          IconButton(
              style: ButtonStyle(padding: ButtonState.all(EdgeInsets.zero)),
              icon: Container(
                width: Dimens.tabHeightSmall+10,
                height: Dimens.tabHeightSmall+10,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey[160])
                ),
                child: Icon(FluentIcons.add,size: 18,color: Colors.orange.dark,),
              ),
              onPressed: ()=>onLabelActionHandler("showDialog&&")
          ),
          const SizedBox(width: 10,),
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
                child: Text(Strings.showAll,style: TextSystem.textS(Colors.white),),
              ),
              onPressed: ()=>onLabelActionHandler("showAll")
          ),
          const SizedBox(width: 10,),
          SizedBox(
            width: MediaQuery.sizeOf(context).width-240,
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
    );
  }
}