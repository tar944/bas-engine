import 'dart:io';
import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/assets/values/textStyle.dart';
import 'package:bas_dataset_generator_engine/src/data/models/imageGroupModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:bas_dataset_generator_engine/src/dialogs/flyDlgDelete.dart';
import 'package:bas_dataset_generator_engine/src/pages/imageGroupPage/viewModels/objectItemViewModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:pmvvm/pmvvm.dart';

class ObjectItem extends StatelessWidget {
  ObjectItem(
      {Key? key,
      required this.isSubGroup,
      required this.allGroups,
      required this.object,
      required this.onActionCaller})
      : super(key: key);

  final ObjectModel object;
  final List<ImageGroupModel> allGroups;
  final bool isSubGroup;
  final ValueSetter<String> onActionCaller;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: () => const _View(),
      viewModel:
          ObjectItemViewModel(isSubGroup, allGroups, object, onActionCaller),
    );
  }
}

class _View extends StatelessView<ObjectItemViewModel> {
  const _View({Key? key}) : super(key: key);

  @override
  Widget render(context, ObjectItemViewModel vm) {

    final controller = FlyoutController();
    return IconButton(
      onPressed: vm.isSubGroup?()=>vm.onActionCaller("gotoLabeling&&${vm.object.id}"):null,
      style: ButtonStyle(
          padding: ButtonState.all(const EdgeInsets.all(0.0)),
      ),
      icon: MouseRegion(
        onEnter: (e)=>vm.onMouseEnter(e),
        onExit: (e)=>vm.onMouseExit(e),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
                Radius.circular(Dimens.dialogCornerRadius)),
            color: Colors.grey[170],
            border: Border.all(
                color: Colors.grey, width: 1.3),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: double.infinity,
                  height: 155,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                        Radius.circular(Dimens.actionRadius)),
                    color: Colors.grey[170],
                    image: DecorationImage(
                      image:
                      Image.file(File(vm.object.image.target!.path!)).image,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                if(vm.isSubGroup&&vm.showLabel)
                  Container(
                  width: Dimens.btnWidthNormal,
                  height: Dimens.btnHeightBig,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(Dimens.btnHeightBig/2)),
                      color: Colors.white.withOpacity(.7),
                    border: Border.all(color: Colors.magenta.dark)

                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 7,),
                      Icon(FluentIcons.label,size: 20,color: Colors.magenta.darkest,),
                      Text(Strings.labelIt,style: TextSystem.textL(Colors.magenta.darkest),)
                    ],
                  ),
                ),
                Positioned(
                    bottom: 5,
                    left: 5,
                    right: 5,
                    child: MultiSelectContainer(
                        singleSelectedItem: true,
                        wrapSettings: const WrapSettings(
                            spacing: 3.0
                        ),
                        itemsPadding: const EdgeInsets.fromLTRB(3.0,3.0,3.0,5.0),
                        textStyles: MultiSelectTextStyles(
                            textStyle: TextSystem.textT(Colors.white),
                            selectedTextStyle: TextSystem.textT(Colors.white)
                        ),
                        itemsDecoration: MultiSelectDecorations(
                            decoration:BoxDecoration(
                              color: vm.isSubGroup?Colors.teal.darkest:Colors.grey[170],
                              borderRadius: const BorderRadius.all(Radius.circular(15)),
                            ) ,
                            selectedDecoration: BoxDecoration(
                              color: vm.isSubGroup?Colors.grey[170]:Colors.teal.darkest,
                              borderRadius: const BorderRadius.all(Radius.circular(15)),
                            )
                        ),
                        items: vm.allGroups.map((e) =>
                            MultiSelectCard(value: e.id,label: e.name)
                        ).toList(),
                        onChange: vm.onGroupSelected)
                ),
                Positioned(
                  left: 5,
                  top: 5,
                  child: FlyoutTarget(
                    key: GlobalKey(),
                    controller: controller,
                    child: IconButton(
                      style: ButtonStyle(
                        backgroundColor: ButtonState.all(Colors.grey[180].withOpacity(.7))
                      ),
                        icon: Icon(
                          FluentIcons.delete,
                          color: Colors.red,
                          size: 20,
                        ),
                        onPressed: () => showFlyDelete(
                            "Are you sure?",
                            "yeh",
                            controller,
                            FlyoutPlacementMode.topCenter,
                            vm.object.id!,
                            vm.onActionCaller)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
