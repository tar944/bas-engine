
import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/assets/values/textStyle.dart';
import 'package:bas_dataset_generator_engine/src/data/models/imageGroupModel.dart';
import 'package:bas_dataset_generator_engine/src/utility/enum.dart';
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
    int stateNumber(){
      int num =curGroup.allStates.length;
      for(var grp in curGroup.otherShapes){
        num+=grp.allStates.length;
      }
      return num;
    }
    return Padding(
      padding: const EdgeInsets.only(top:4.0,bottom:4.0,left: 3.0,right: 3.0),
      child: IconButton(
          style: ButtonStyle(padding: ButtonState.all(EdgeInsets.zero)),
          icon: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                    Radius.circular((Dimens.tabHeightSmall + 10 / 2))),
                border: Border.all(color: isSelected?curGroup.state==GroupState.generated.name?Colors.magenta.dark:Colors.teal.dark:Colors.grey[160]),
              color: isSelected?(curGroup.state==GroupState.generated.name?Colors.magenta.light:Colors.teal.light):Colors.transparent
            ),
            child: Row(
              children: [
                const SizedBox(width: 10,),
                curGroup.name!=Strings.emptyStr?
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("${curGroup.label.target!=null?curGroup.label.target!.name:'deletedLabel'}${curGroup.name!=""?".":""}${curGroup.name}", style: TextSystem.textM(Colors.white),),
                      if(curGroup.label.target!=null&&curGroup.label.target!.levelName=="objects")
                          Text(" (${curGroup.label.target!.action})",style: TextSystem.textS(Colors.grey[120]),)
                    ],
                  )
                    : Text(Strings.labelIt,style: TextSystem.textS(Colors.white),),
                const SizedBox(
                  width: 8,
                ),
                if (stateNumber()!=0&&!isSelected)
                  Container(
                    width: Dimens.tabHeightSmall,
                    height: Dimens.tabHeightSmall,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey[180])),
                    child: Text(
                      stateNumber().toString(),
                      style: TextSystem.textM(Colors.orange.dark),
                    ),
                  ),
                if(stateNumber()!=0&&isSelected)
                  ...[
                    if(curGroup.label.target!=null&&curGroup.label.target!.levelName!="objects")
                      Container(
                        width: Dimens.tabHeightSmall*2,
                        height: Dimens.tabHeightSmall,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(Dimens.tabHeightSmall/2)),
                            border: Border.all(color: Colors.teal.darker),
                            color:Colors.teal.dark
                        ),
                        child: Text(Strings.open, style: TextSystem.textM(Colors.white),),
                      ),
                    if(curGroup.label.target==null&&curGroup.state==GroupState.generated.name)
                      IconButton(
                        style: ButtonStyle(
                          padding: ButtonState.all(const EdgeInsets.all(0.0))
                        ),
                        onPressed: ()=>onLabelSelectedCaller("removeGroup&&${curGroup.id}"),
                        icon: Container(
                          width: Dimens.tabHeightSmall,
                          height: Dimens.tabHeightSmall,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(Dimens.tabHeightSmall/2)),
                              border: Border.all(color: Colors.magenta.darkest),
                              color:Colors.magenta.dark
                          ),
                          child: const Icon(FluentIcons.remove_link),
                        ),
                      ),
                    if(curGroup.state!=GroupState.generated.name)
                      ...[
                        const SizedBox(width: 5.0,),
                        IconButton(
                          style: ButtonStyle(
                            padding: ButtonState.all(EdgeInsets.zero)
                          ),
                          onPressed: ()=>onLabelSelectedCaller("editGroup&&${curGroup.id}"),
                          icon: Container(
                          width: Dimens.tabHeightSmall,
                          height: Dimens.tabHeightSmall,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.teal.dark)),
                          child: const Icon(FluentIcons.edit,size: 16,color: Colors.white,),
                      ),
                        ),]
                  ],
                if(stateNumber()==0)
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
                  width: 3,
                ),
              ],
            ),
          ),
          onPressed: stateNumber()==0 ?null:
              ()=>onLabelSelectedCaller(
                  isSelected?
                    (curGroup.state==GroupState.generated.name?
                        "labelIt&&${curGroup.id}":"open&&${curGroup.id}"):
                                    "choose&&${curGroup.id}")),
    );
  }
}
