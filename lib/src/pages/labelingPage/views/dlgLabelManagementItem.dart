import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/assets/values/textStyle.dart';
import 'package:bas_dataset_generator_engine/src/data/models/labelModel.dart';
import 'package:bas_dataset_generator_engine/src/dialogs/flyDlgConfirm.dart';
import 'package:bas_dataset_generator_engine/src/pages/labelingPage/viewModels/labelManageItemViewModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class DlgLabelManagementItem extends StatelessWidget {
  const DlgLabelManagementItem({
    Key? key,
    required this.label,
    required this.onActionCaller,
  }) : super(key: key);
  final LabelModel label;
  final ValueSetter<String> onActionCaller;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: () => const _View(),
      viewModel:
      LabelManageItemViewModel(label,onActionCaller),
    );
  }
}

class _View extends StatelessView<LabelManageItemViewModel> {
  const _View({Key? key}) : super(key: key);

  @override
  Widget render(context, LabelManageItemViewModel vm) {
    return Padding(
      padding: const EdgeInsets.only(left:10.0,right: 10.0),
      child: SizedBox(
        width: double.infinity,
        height: 40,
        child: Row(
          children: [
            Expanded(
              flex: 93,
              child: IconButton(
                  icon: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(vm.label.name,style: TextSystem.textL(Colors.white),),
                      const SizedBox(width: 5,),
                      if(vm.label.action!="")
                        Padding(
                          padding: const EdgeInsets.only(bottom: 3.0),
                          child: Text("(action: ${vm.label.action})",style: TextSystem.textXs(Colors.grey[80]),),
                        )
                    ],
                  ),
                  onPressed:()=> vm.onActionCaller('clicked&&${vm.label.id}')
              ),
            ),
            const SizedBox(width: 5,),
            Expanded(
                flex: 7,
                child: IconButton(
                    style: ButtonStyle(
                        padding: ButtonState.all(const EdgeInsets.all(6))),
                    icon: Icon(
                      FluentIcons.choice_column,
                      size: 18,
                      color: Colors.green.dark,
                    ),
                    onPressed: () => vm.onActionCaller('finalSelect&&${vm.label.id}'))
            ),
            Expanded(
                flex: 7,
                child: FlyoutTarget(
                    key: GlobalKey(),
                    controller: vm.controller,
                    child:IconButton(
                    style: ButtonStyle(
                        padding: ButtonState.all(const EdgeInsets.all(6))),
                    icon: Icon(
                      FluentIcons.delete,
                      size: 18,
                      color: Colors.red,
                    ),
                    onPressed: () => showFlyConfirm(
                        Strings.deleteLabel,
                        Strings.yes,
                        vm.controller,
                        FlyoutPlacementMode.topCenter,
                        "delete&&${vm.label.id}",
                        vm.onActionCaller)
                    )
                )
            ),
          ],
        ),
      ),
    );
  }
}