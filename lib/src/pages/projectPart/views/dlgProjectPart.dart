
import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/src/data/models/projectPartModel.dart';
import 'package:bas_dataset_generator_engine/src/dialogs/toast.dart';
import 'package:bas_dataset_generator_engine/src/parts/dialogTitleBar.dart';
import 'package:bas_dataset_generator_engine/src/utility/directoryManager.dart';
import 'package:bas_dataset_generator_engine/src/widgets/CButton.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:uuid/uuid.dart';

class DlgProjectPart extends HookWidget {
  DlgProjectPart({
    Key? key,
    this.part,
    required this.prjUUID,
    required this.onSaveCaller,
  }) : super(key: key);

  final ValueSetter<ProjectPartModel> onSaveCaller;
  ProjectPartModel? part;
  String prjUUID;

  @override
  Widget build(BuildContext context) {
    void onCloseClicked() {
      Navigator.pop(context);
    }

    var ctlTitle = TextEditingController(text:part!=null?part!.name:"");
    var ctlDescription = TextEditingController(text:part!=null?part!.description:"");


    void onBtnSaveListener() async{
      if (ctlTitle.text == "") {
        Toast("You should enter a title for software", false)
            .showWarning(context);
        return;
      }
      if (part == null) {
        String partUUID=const Uuid().v4();
        onSaveCaller(
            ProjectPartModel(0,prjUUID,partUUID, ctlTitle.text,await DirectoryManager().getPartDir(prjUUID, partUUID), ctlDescription.text));
      } else {
        part!.name = ctlTitle.text;
        part!.description = ctlDescription.text;
        onSaveCaller(part!);
      }
      Navigator.pop(context);
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
            width: Dimens.dialogNormalWidth,
            height: Dimens.dialogNormalHeight,
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
                    title: part!=null?Strings.dlgEditGroup:Strings.dlgNewGroup,
                    onActionListener: onCloseClicked,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      child: Column(
                                        children: [
                                          TextBox(
                                            controller: ctlTitle,
                                            placeholder:
                                                Strings.dlgSoftwareTitleHint,
                                            expands: false,
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          TextBox(
                                            controller: ctlDescription,
                                            maxLines: 8,
                                            placeholder:
                                                Strings.partDescriptionHint,
                                          ),
                                        ],
                                      ))),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: Dimens.dialogBottomSize,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          bottomLeft:
                              Radius.circular(Dimens.dialogCornerRadius),
                          bottomRight:
                              Radius.circular(Dimens.dialogCornerRadius)),
                      color: Colors.grey[200],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CButton(
                            text: Strings.save,
                            color: Colors.blue.normal,
                            textColor: Colors.white,
                            onPressed: () => onBtnSaveListener(),
                            kind: "normal"),
                        const SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                  )
                ],
              ),
            )),
      ],
    );
  }
}
