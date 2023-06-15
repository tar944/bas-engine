import 'package:bas_dataset_generator_engine/src/data/dao/labelDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/models/labelTypeModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/labelingDataModel.dart';
import 'package:bas_dataset_generator_engine/src/dialogs/dlgLabelingManagement.dart';
import 'package:bas_dataset_generator_engine/src/items/labelingItem.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class LabelingDetails extends HookWidget {
  const LabelingDetails(
      {Key? key, required this.onActionCaller, required this.data})
      : super(key: key);

  final LabelingDataModel data;
  final ValueSetter<String> onActionCaller;

  onSaveHandler(String newValue){
    onActionCaller('edit&&${data.getId()}&&$newValue');
  }

  @override
  Widget build(BuildContext context) {
    final actions = useState(['','']);
    final labelList = useState([]);
    useEffect(() {
      actions.value=data.kind=='object'?data.getActions():[];
      Future<void>.microtask(() async {
       labelList.value=await LabelDAO().getLabelList(data.kind);
      });
      return null;
    }, [data]);

    onDlgCloseHandler()async{
      labelList.value=await LabelDAO().getLabelList(data.kind);
    }

    return Container(
      height: 60,
      width: (60 + (labelList.value.length * 99.25)) > (MediaQuery.of(context).size.width - 80)
          ? MediaQuery.of(context).size.width - 90
          : (60 + (labelList.value.length * 99.25)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[200],
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left:8.0),
            child: IconButton(icon: const Icon(FluentIcons.edit), onPressed: (){
              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (context) => DlgLabelingManagement(
                      labelList: labelList.value as List<LabelTypeModel>,
                      isFor: data.kind,
                      onDlgCloseCaller: onDlgCloseHandler,
                    ),
                  );
                }),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.grey[150], borderRadius: BorderRadius.circular(5)),
                child: ListView.builder(
                    itemCount: labelList.value.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: LabelingItem(
                          title: labelList.value[index].name,
                          actions: actions.value,
                          isSelected: labelList.value[index].name==data.getType(),
                          description: data.getDescription()!=null?data.getDescription()!:'',
                          onActionListener: onSaveHandler,
                        ),
                      );
                    }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}