import 'dart:io';
import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/cutToPiecesPage/viewModels/flyObjectViewModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:pmvvm/pmvvm.dart';

class FlyObjectItem extends StatelessWidget {
  FlyObjectItem(
      {Key? key,
      required this.isSelected,
      required this.object,
      required this.onActionCaller})
      : super(key: key);

  final ObjectModel object;
  final bool isSelected;
  final ValueSetter<String> onActionCaller;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: () => const _View(),
      viewModel:
          FlyObjectViewModel(isSelected, object, onActionCaller),
    );
  }
}

class _View extends StatelessView<FlyObjectViewModel> {
  const _View({Key? key}) : super(key: key);

  @override
  Widget render(context, FlyObjectViewModel vm) {

    return IconButton(
      onPressed: ()=>vm.onActionCaller("next&&${vm.object.id}"),
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
          padding: const EdgeInsets.all(5.0),
          child: Container(
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                  Radius.circular(Dimens.actionRadius)),
              color: Colors.grey[170],
              image: DecorationImage(
                image:
                Image.file(File(vm.object.image.target!.path)).image,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
