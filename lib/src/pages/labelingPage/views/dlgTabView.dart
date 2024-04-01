import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/assets/values/textStyle.dart';
import 'package:bas_dataset_generator_engine/src/data/models/labelModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/labelingPage/viewModels/tabBodyViewModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/labelingPage/views/dlgLabelManagementItem.dart';
import 'package:bas_dataset_generator_engine/src/utility/enum.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class DlgTabView extends StatelessWidget {
  DlgTabView({
    Key? key,
    required this.allLabels,
    required this.lvlName,
    required this.onActionCaller})
      : super(key: key);

  final List<LabelModel> allLabels;
  final String lvlName;
  final ValueSetter<String> onActionCaller;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: () => const _View(),
      viewModel: TabBodyViewModel(allLabels,lvlName,onActionCaller),
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
                              onPressed: () => vm.onActionCaller('create&&${vm.ctlTitle.text}&&${vm.actValue}'))),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ListView.builder(
                  itemCount: vm.allLabels.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: DlgLabelManagementItem(
                        label: vm.allLabels[index],
                        onActionCaller: vm.onActionCaller,
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}