import 'dart:io';
import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/assets/values/textStyle.dart';
import 'package:bas_dataset_generator_engine/src/data/models/imageGroupModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:bas_dataset_generator_engine/src/dialogs/flyDlgConfirm.dart';
import 'package:bas_dataset_generator_engine/src/pages/labelingPage/viewModels/objectItemViewModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:pmvvm/pmvvm.dart';

class ObjectItem extends StatelessWidget {
  ObjectItem(
      {Key? key,
        required this.allGroups,
        required this.object,
        required this.isState,
        required this.stepStatus,
        required this.onActionCaller})
      : super(key: key);

  final ObjectModel object;
  final String stepStatus;
  final bool isState;
  final List<ImageGroupModel> allGroups;
  final ValueSetter<String> onActionCaller;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: () => const _View(),
      viewModel:
          ObjectItemViewModel( allGroups,isState,stepStatus, object, onActionCaller),
    );
  }
}

class _View extends StatelessView<ObjectItemViewModel> {
  const _View({Key? key}) : super(key: key);

  @override
  Widget render(context, ObjectItemViewModel vm) {
    final controller = FlyoutController();
    return IconButton(
      onPressed: vm.stepStatus=="hide"?null:()=>vm.onActionCaller(vm.stepStatus=="firstStep"?"setMainState&&${vm.object.id}":"goToCuttingPage&&${vm.object.id}"),
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
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                if(vm.stepStatus!="hide"&&vm.showLabel)
                  Container(
                    width: Dimens.btnWidthNormal+(vm.stepStatus=="firstStep"?100:0),
                    height: Dimens.btnHeightBig,
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                            Radius.circular(Dimens.btnHeightBig / 2)),
                        color: Colors.white.withOpacity(.7),
                        border: Border.all(color: Colors.orange,width: 1)),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 7,
                        ),
                        Icon(
                          FluentIcons.label,
                          size: 20,
                          color: Colors.orange.dark,
                        ),
                        Text(
                          vm.stepStatus=="firstStep"?Strings.mainState:Strings.labelIt,
                          style: TextSystem.textL(Colors.orange.dark),
                        )
                      ],
                    ),
                  ),
                if(vm.isState==false)
                  Positioned(
                    bottom: 5,
                    left: 5,
                    right: 5,
                    child: MultiSelectContainer(
                        singleSelectedItem: true,
                        wrapSettings: const WrapSettings(
                            spacing: 5.0
                        ),
                        itemsPadding: const EdgeInsets.all(2.0),
                        textStyles: MultiSelectTextStyles(
                            textStyle: TextSystem.textXs(Colors.white),
                            selectedTextStyle: TextSystem.textXs(Colors.white)
                        ),
                        itemsDecoration: MultiSelectDecorations(
                            decoration:BoxDecoration(
                              color: Colors.grey[170],
                              borderRadius: const BorderRadius.all(Radius.circular(15)),
                              border: Border.all(color: Colors.grey[150])
                            ) ,
                            selectedDecoration: BoxDecoration(
                              color: Colors.teal.dark,
                              borderRadius: const BorderRadius.all(Radius.circular(15)),
                              border: Border.all(color: Colors.teal),
                            )
                        ),
                        items: vm.allGroups.map((e)=>MultiSelectCard(
                              selected: e.id == vm.parentGroupId,
                              value: e.id,
                              label: e.name==Strings.emptyStr?Strings.notSet:e.name==""?e.label.target!.name:e.name,
                          )
                        ).toList(),
                        onChange: vm.onGroupSelected)
                ),
                Positioned(
                  left: 5,
                  top: 5,
                  child: vm.object.isMainObject?
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[180].withOpacity(0.7),
                      borderRadius: const BorderRadius.all(Radius.circular(5.0))
                    ),
                      child: Icon(FluentIcons.crown_solid,size: 22,color: Colors.orange.lightest,)):
                  Row(
                    children: [
                      IconButton(
                          style: ButtonStyle(
                              backgroundColor: ButtonState.all(Colors.grey[180].withOpacity(.7))
                          ),
                          icon: const Icon(
                            FluentIcons.picture_stretch,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () => vm.onActionCaller("showImg&&${vm.object.id}")),
                      if(vm.stepStatus=="firstStep")
                        ...[
                          const SizedBox(width: 5,),
                          FlyoutTarget(
                            key: GlobalKey(),
                            controller: controller,
                            child: IconButton(
                                style: ButtonStyle(
                                    backgroundColor: ButtonState.all(Colors.grey[180].withOpacity(.7))
                                ),
                                icon: const Text(Strings.setItMain),
                                onPressed: () => showFlyConfirm(
                                    Strings.sureToSetItMain,
                                    Strings.yes,
                                    controller,
                                    FlyoutPlacementMode.topCenter,
                                    "setItMain&&${vm.object.id!}",
                                    vm.onActionCaller)),
                          ),
                        ]
                    ],
                  ),
                ),
                Positioned(
                    right: 5,
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
                          onPressed: () => showFlyConfirm(
                              "Are you sure?",
                              Strings.yes,
                              controller,
                              FlyoutPlacementMode.topCenter,
                              "delete&&${vm.object.id!}",
                              vm.onActionCaller)),
                    ),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
