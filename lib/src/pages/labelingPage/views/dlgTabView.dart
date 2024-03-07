
import 'package:bas_dataset_generator_engine/src/data/models/labelModel.dart';
import 'package:bas_dataset_generator_engine/src/items/dlgLabelManagementItem.dart';
import 'package:fluent_ui/fluent_ui.dart';

class DlgTabView extends StatelessWidget {
  DlgTabView({Key? key, required this.allLabels,required this.onActionCaller}) : super(key: key);

  final List<LabelModel>? allLabels;
  final ValueSetter<String> onActionCaller;

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child:ListView.builder(
                itemCount: allLabels!.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: DlgLabelManagementItem(
                      label: allLabels![index],
                      onActionListener: onActionCaller,
                    ),
                  );
                }),
          ),
        ),
      ],
    );
  }
}
