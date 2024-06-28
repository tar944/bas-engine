import 'dart:io';
import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/src/data/models/pascalVOCModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/exportReviewPage/viewModels/screenViewModel.dart';
import 'package:bas_dataset_generator_engine/src/widgets/CButton.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:pmvvm/pmvvm.dart';

class ScreenItem extends StatelessWidget {
  ScreenItem(
      {Key? key,
        required this.isSelected,
        required this.showObject,
        required this.object,
        required this.onActionCaller})
      : super(key: key);

  final PascalVOCModel object;
  final bool isSelected;
  final bool showObject;
  final ValueSetter<String> onActionCaller;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: () => const _View(),
      viewModel: ScreenViewModel(isSelected, showObject,object, onActionCaller),
    );
  }
}

class _View extends StatelessView<ScreenViewModel> {
  const _View({Key? key}) : super(key: key);

  @override
  Widget render(context, ScreenViewModel vm) {

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Opacity(
        opacity: vm.showObjects?1.0:0.5,
        child: SizedBox(
          width: 190,
          child: IconButton(
            onPressed: ()=>vm.onActionCaller("selected&&${vm.object.objUUID}"),
            style: ButtonStyle(
                padding: ButtonState.all(const EdgeInsets.all(0.0)),
            ),
            icon: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(Dimens.dialogCornerRadius)),
                color: Colors.grey[170],
                border: Border.all(
                    color: vm.isSelected?Colors.teal.dark:Colors.grey, width: 1.3),
              ),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(Dimens.actionRadius+2)),
                      color: Colors.grey[170],
                      image: DecorationImage(
                        image: Image.file(File(vm.object.path!)).image,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                    if(!vm.isSelected)
                      Positioned(
                          left: 10,
                          right: 10,
                          bottom: 10,
                          child: IconButton(
                            style: ButtonStyle(
                              padding: ButtonState.all(EdgeInsets.zero)
                            ),
                            onPressed: ()=>vm.onActionCaller('showHideObjects&&${vm.object.objUUID}'),
                            icon: Container(
                              height: 30,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: const BorderRadius.all(Radius.circular(5.0))
                              ),
                              child: Text(vm.showObjects?Strings.hideObjects:Strings.showObjects),
                            ),
                          )
                      )
                  ]
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
