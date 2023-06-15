import 'package:bas_dataset_generator_engine/src/data/dao/labelDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/models/labelTypeModel.dart';
import 'package:bas_dataset_generator_engine/src/items/dlgLabelManagementItem.dart';
import 'package:fluent_ui/fluent_ui.dart';
import '../../assets/values/dimens.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../assets/values/strings.dart';
import '../parts/dialogTitleBar.dart';

class DlgLabelingManagement extends HookWidget {
  DlgLabelingManagement({
    Key? key,
    required this.labelList,
    required this.onDlgCloseCaller,
    required this.isFor,
  }) : super(key: key);

  final VoidCallback onDlgCloseCaller;
  final List<LabelTypeModel> labelList;
  final String isFor;

  @override
  Widget build(BuildContext context) {
    var ctlTitle = TextEditingController();
    final labelList = useState([]);

    useEffect(() {
      Future<void>.microtask(() async {
        labelList.value=await LabelDAO().getLabelList(isFor);
      });
      return null;
    }, []);

    void onCloseClicked() {
      onDlgCloseCaller();
      Navigator.pop(context);
    }

    void onActionHandler(String action)async{
      var actions = action.split('&&');
      switch (actions[0]) {
        case 'save':
          LabelTypeModel? label =
              await LabelDAO().getLabel(int.parse(actions[1]));
          label!.name = actions[2];
          await LabelDAO().updateLabel(label);
          ctlTitle.text='';
          break;
        case 'delete':
          await LabelDAO().deleteLabel(int.parse(actions[1]));
          break;
        case 'create':
          await LabelDAO().addLabel(LabelTypeModel(0, actions[1], isFor));
          break;
      }
      labelList.value=await LabelDAO().getLabelList(isFor);
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
            width: Dimens.dialogNormalWidth,
            height: Dimens.dialogLargeHeight,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                    Radius.circular(Dimens.dialogCornerRadius)),
                color: Colors.grey[190],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  DialogTitleBar(
                    title: Strings.dlgLabeling,
                    onActionListener: onCloseClicked,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:15.0,right: 15,bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(Strings.createNewLabel),
                        const SizedBox(height: 5,),
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
                              const SizedBox(width: 5,),
                              Expanded(
                                  flex: 7,
                                  child: IconButton(
                                      style: ButtonStyle(
                                          padding: ButtonState.all(const EdgeInsets.all(6))),
                                      icon: Icon(
                                        FluentIcons.save,
                                        size: 20,
                                        color: Colors.blue.lighter,
                                      ),
                                      onPressed: () => onActionHandler('create&&${ctlTitle.text}'))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child:ListView.builder(
                          itemCount: labelList.value.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: DlgLabelManagementItem(
                                label: labelList.value[index],
                                onActionListener: onActionHandler,
                                isFor: isFor,
                              ),
                            );
                          }),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
