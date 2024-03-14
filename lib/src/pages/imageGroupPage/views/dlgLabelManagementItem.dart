import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/src/data/models/labelModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/imageGroupPage/viewModels/labelManageItemViewModel.dart';
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
        height: 35,
        child: Row(
          children: [
            Expanded(
              flex: 82,
              child: vm.isEditMode?
              TextBox(
                controller: vm.ctlTitle,
                placeholder: Strings.dlgSoftwareTitleHint,
                expands: false,
              ):
              IconButton(
                  icon: Container(alignment:Alignment.centerLeft,child: Text(vm.label.name)),
                  onPressed:()=> vm.onActionCaller('clicked&&${vm.label.id}')
              ),
            ),
            const SizedBox(width: 5,),
            Expanded(
                flex: 7,
                child: IconButton(
                    style: ButtonStyle(
                        padding: ButtonState.all(const EdgeInsets.all(10))),
                    icon: Icon(
                      FluentIcons.edit,
                      size: 15,
                      color: Colors.green.lighter,
                    ),
                    onPressed: () => vm.onEditBtnHandler())),
            Expanded(
                flex: 7,
                child: IconButton(
                    style: ButtonStyle(
                        padding: ButtonState.all(const EdgeInsets.all(6))),
                    icon: Icon(
                      FluentIcons.delete,
                      size: 18,
                      color: Colors.red,
                    ),
                    onPressed: () => vm.onActionCaller('delete&&${vm.label.id}'))),
          ],
        ),
      ),
    );
  }
}