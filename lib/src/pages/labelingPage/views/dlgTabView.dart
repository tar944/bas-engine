import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/assets/values/textStyle.dart';
import 'package:bas_dataset_generator_engine/src/data/models/labelModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/labelingPage/views/dlgLabelManagementItem.dart';
import 'package:fluent_ui/fluent_ui.dart';

class DlgTabView extends StatelessWidget {
  DlgTabView({
    Key? key,
    required this.allLabels,
    required this.levelName,
    required this.onActionCaller})
      : super(key: key);

  final List<LabelModel> allLabels;
  final String levelName;
  final ValueSetter<String> onActionCaller;

  @override
  Widget build(BuildContext context) {
    var ctlTitle = TextEditingController();
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
          if (levelName != "objects")
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
                          flex: 82,
                          child: TextBox(
                            controller: ctlTitle,
                            placeholder: Strings.dlgSoftwareTitleHint,
                            expands: false,
                          ),
                        ),
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
                                onPressed: () =>
                                    onActionCaller('create&&${ctlTitle.text}'))),
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
                  itemCount: allLabels.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: DlgLabelManagementItem(
                        label: allLabels[index],
                        onActionCaller: onActionCaller,
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
