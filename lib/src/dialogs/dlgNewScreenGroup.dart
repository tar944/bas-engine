
import 'package:bas_dataset_generator_engine/src/data/models/recordedScreenGroup.dart';
import 'package:bas_dataset_generator_engine/src/dialogs/toast.dart';
import 'package:fluent_ui/fluent_ui.dart';
import '../../assets/values/dimens.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../assets/values/strings.dart';
import '../parts/dialogTitleBar.dart';
import '../widgets/CButton.dart';

class DlgNewScreenGroup extends HookWidget {
  DlgNewScreenGroup({
    Key? key,
    this.group,
    required this.onSaveCaller,
  }) : super(key: key);

  final ValueSetter<RecordedScreenGroup> onSaveCaller;
  RecordedScreenGroup? group;

  @override
  Widget build(BuildContext context) {
    void onCloseClicked() {
      Navigator.pop(context);
    }

    var ctlTitle = TextEditingController(text:group!=null?group!.name:"");
    var ctlDescription = TextEditingController(text:group!=null?group!.description:"");


    void onBtnSaveListener() {
      if (ctlTitle.text == "") {
        Toast("You should enter a title for software", false)
            .showWarning(context);
        return;
      }
      if (group == null) {
        onSaveCaller(
            RecordedScreenGroup(0, ctlTitle.text, '', ctlDescription.text,0));
      } else {
        group!.name = ctlTitle.text;
        group!.description = ctlDescription.text;
        onSaveCaller(group!);
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
                    title: group!=null?Strings.dlgEditGroup:Strings.dlgNewGroup,
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
                                                Strings.groupDescriptionHint,
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
