import 'package:bas_dataset_generator_engine/src/data/models/labelTypeModel.dart';
import 'package:fluent_ui/fluent_ui.dart';

import '../../assets/values/strings.dart';

class DlgLabelManagementItem extends StatelessWidget {
  const DlgLabelManagementItem({
    Key? key,
    required this.label,
    required this.onActionListener, required this.isFor,
  }) : super(key: key);
  final LabelTypeModel label;
  final String isFor;
  final ValueSetter<String> onActionListener;

  @override
  Widget build(BuildContext context) {
    var ctlTitle = TextEditingController(text: label.name);
    onActionHandler(String action){
      onActionListener('$action&&${label.id}&&${ctlTitle.text}');
    }
    return Padding(
      padding: const EdgeInsets.only(left:10.0,right: 10.0),
      child: SizedBox(
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
                    onPressed: () => onActionHandler('save'))),
            Expanded(
                flex: 7,
                child: IconButton(
                    style: ButtonStyle(
                        padding: ButtonState.all(const EdgeInsets.all(6))),
                    icon: Icon(
                      FluentIcons.delete,
                      size: 20,
                      color: Colors.red,
                    ),
                    onPressed: () => onActionHandler('delete'))),
          ],
        ),
      ),
    );
  }
}
