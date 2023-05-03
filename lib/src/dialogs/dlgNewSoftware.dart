
import 'package:bas_dataset_generator_engine/src/dialogs/toast.dart';
import 'package:fluent_ui/fluent_ui.dart';
import '../../assets/values/dimens.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../assets/values/strings.dart';
import '../data/models/softwareModel.dart';
import '../parts/dialogTitleBar.dart';
import '../widgets/CButton.dart';

class DlgNewSoftware extends HookWidget {
  DlgNewSoftware({
    Key? key,
    this.software,
    required this.onSaveCaller,
  }) : super(key: key);

  final ValueSetter<SoftwareModel> onSaveCaller;
  SoftwareModel? software;

  @override
  Widget build(BuildContext context) {
    void onCloseClicked() {
      Navigator.pop(context);
    }

    final title = useState("");
    final description = useState("");

    void onBtnSaveListener() {
      if (title.value == "") {
        Toast("You should enter a title for course", false)
            .showWarning(context);
        return;
      }
      if (software == null) {
        onSaveCaller(
            SoftwareModel('', title.value, '', '', description.value, '', ''));
      } else {
        onSaveCaller(software!);
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
                    title: Strings.dlgNewSoftware,
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
                                            placeholder:
                                                Strings.dlgSoftwareTitleHint,
                                            expands: false,
                                            onChanged: (e) =>
                                                {title.value = e.toString()},
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          TextBox(
                                            maxLines: 8,
                                            placeholder:
                                                Strings.softwareDescriptionHint,
                                            onChanged: (e)=>{description.value=e.toString()},
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
