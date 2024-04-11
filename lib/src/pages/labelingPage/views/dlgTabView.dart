import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/assets/values/textStyle.dart';
import 'package:bas_dataset_generator_engine/src/data/models/labelModel.dart';
import 'package:bas_dataset_generator_engine/src/dialogs/flyDlgConfirm.dart';
import 'package:bas_dataset_generator_engine/src/pages/labelingPage/viewModels/tabBodyViewModel.dart';
import 'package:bas_dataset_generator_engine/src/utility/enum.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:pmvvm/pmvvm.dart';

class DlgTabView extends StatelessWidget {
  DlgTabView({
    Key? key,
    required this.allLabels,
    required this.lvlName,
    required this.selLabelId,
    required this.onActionCaller})
      : super(key: key);

  final List<LabelModel> allLabels;
  final String lvlName;
  final int selLabelId;
  final ValueSetter<String> onActionCaller;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: () => const _View(),
      viewModel: TabBodyViewModel(allLabels,lvlName,selLabelId,onActionCaller),
    );
  }
}

class _View extends StatelessView<TabBodyViewModel> {
  const _View({Key? key}) : super(key: key);

  @override
  Widget render(context, TabBodyViewModel vm) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[170],width: 2.0),
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          color: Colors.grey[180]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(Strings.createNewLabel,style: TextSystem.textS(Colors.white),),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 35,
                  child: Row(
                    children: [
                      Expanded(
                        flex: vm.lvlName=="objects"?65:82,
                        child: TextBox(
                          controller: vm.ctlTitle,
                          placeholder: Strings.dlgSoftwareTitleHint,
                          expands: false,
                        ),
                      ),
                      if (vm.lvlName=="objects")
                        ...[
                          const SizedBox(width: 10,),
                          ComboBox<String>(
                        value: vm.actValue,
                        items: DefaultActions.values.map((e) {
                          return ComboBoxItem(
                            value: e.name,
                            child: Text(e.name),
                          );
                        }).toList(),
                        onChanged: (e)=> vm.onComboBoxChangedHandler(e!),
                      ),],
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                          flex: 7,
                          child: IconButton(
                              style: ButtonStyle(
                                  padding:
                                  ButtonState.all(const EdgeInsets.all(6))),
                              icon: Icon(
                                FluentIcons.save,
                                size: 20,
                                color: Colors.blue.lighter,
                              ),
                              onPressed: () => vm.onSaveHandler())),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10,left: 5.0,right: 5.0),
            child:MultiSelectContainer(
                singleSelectedItem: true,
                wrapSettings: const WrapSettings(spacing: 5.0),
                itemsPadding: const EdgeInsets.all(3.0),
                textStyles: MultiSelectTextStyles(
                    textStyle: TextSystem.textS(Colors.white),
                    selectedTextStyle: TextSystem.textS(Colors.white)
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
                items: vm.allLabels.map((e)=>MultiSelectCard(
                  selected: e.id==vm.selLabelId,
                  value: e.id,
                  label: e.name,
                  suffix: MultiSelectSuffix(
                    selectedSuffix: FlyoutTarget(
                        key: GlobalKey(),
                        controller: vm.controller,
                        child:Row(
                          children: [
                            e.action!=""?
                            Text("(${e.action})",style: TextSystem.textXs(Colors.grey[160]),):Container(),
                            IconButton(
                                style: ButtonStyle(
                                    padding: ButtonState.all(const EdgeInsets.all(2))),
                                icon: Icon(
                                  FluentIcons.delete,
                                  size: 16,
                                  color: Colors.white.withOpacity(.7),
                                ),
                                onPressed: () => showFlyConfirm(
                                    Strings.deleteLabel,
                                    Strings.yes,
                                    vm.controller,
                                    FlyoutPlacementMode.topCenter,
                                    "delete&&${e.id}",
                                    vm.onActionCaller)
                            ),
                          ],
                        )
                    ),
                    disabledSuffix: Container()
                  )
                )
                ).toList(),
                onChange: (l,e)=>vm.onLabelActionHandler(e)),
            ),
          ),
        ],
      ),
    );
  }
}