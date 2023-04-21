import 'dart:convert';
import 'dart:io';
import 'package:bas_dataset_generator_engine/src/dialogs/toast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import '../../assets/values/dimens.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../assets/values/strings.dart';
import '../../assets/values/textStyle.dart';
import '../items/dlgSoftwareItem.dart';
import '../parts/dialogTitleBar.dart';
import '../widgets/CButton.dart';

class DlgNewSoftware extends HookWidget {
  DlgNewSoftware({Key? key,
    this.course,
    required this.onSaveCaller,
    required this.availableSoftware})
      : super(key: key);

  final ValueSetter<String>? onSaveCaller;
  String? course;
  final List<String> availableSoftware;

  @override
  Widget build(BuildContext context) {
    void onCloseClicked() {
      Navigator.pop(context);
    }

    final FocusNode _focusNode = FocusNode();
    final path = useState("");
    final title = useState("");
    final kind = useState(Strings.projectTypeList[0]);

    void onBtnSaveListener(String action) {
      if (title.value == "") {
        Toast("You should enter a title for course", false)
            .showWarning(context);
        return;
      }
      onSaveCaller!(course!);
      Navigator.pop(context);
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
                    title: Strings.dlgNewCourse,
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
                                            Strings.dlgCourseTitleHint,
                                            expands: false,
                                            onChanged: (e) =>
                                            {title.value = e.toString()},
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius: const BorderRadius
                                                    .all(
                                                    Radius.circular(Dimens
                                                        .dialogCornerRadius)),
                                                color: Colors.grey[170],
                                                border: Border.all(
                                                    color: Colors.grey[150])),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.only(
                                                      left: 10, right: 10),
                                                  child: Container()
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ))),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Button(
                                      style: ButtonStyle(
                                          backgroundColor: ButtonState.all(
                                              Colors.transparent),
                                          border: ButtonState.all(BorderSide(
                                              color: Colors.grey[150]))),
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Container(
                                            height: 90,
                                            width: 123,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: path.value == ""
                                                      ? AssetImage(
                                                    path.value == ""
                                                        ? 'lib/assets/images/addImage.png'
                                                        : path.value,
                                                  )
                                                      : Image
                                                      .file(
                                                      File(path.value))
                                                      .image,
                                                  fit: BoxFit.fill),
                                              borderRadius:
                                              const BorderRadius.all(
                                                  Radius.circular(
                                                      Dimens.actionRadius)),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Text(Strings.chooseImage,
                                              style: TextSystem.textS(
                                                  Colors.white)),
                                          const SizedBox(
                                            height: 8,
                                          )
                                        ],
                                      ),
                                      onPressed: () async {
                                        FilePickerResult? result =
                                        await FilePicker.platform
                                            .pickFiles();

                                        if (result != null) {
                                          print(result.files.single.path);
                                          path.value =
                                          result.files.single.path!;
                                        } else {
                                          // User canceled the picker
                                        }
                                      }),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Default language :",
                                    style: TextSystem.textXs(Colors.grey[120]),
                                  ),
                                  const SizedBox(height: 5,),
                                  ComboBox<dynamic>(
                                    value: 'Word',
                                    items: ['Word','Photoshop','Excel','Access'].map((e) {
                                      return ComboBoxItem(
                                        value: e,
                                        child: DDSoftwareItem(name: e),
                                      );
                                    }).toList(),
                                    onChanged: (e){},
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Type of project :",
                                    style: TextSystem.textXs(Colors.grey[120]),
                                  ),
                                  const SizedBox(height: 5,),
                                  ComboBox<String>(
                                    value: kind.value,
                                    items: Strings.projectTypeList.map((e) {
                                      return ComboBoxItem(
                                        value: e,
                                        child: Text(e,style:TextSystem.textS(Colors.white)),
                                      );
                                    }).toList(),
                                    onChanged: (e){
                                      kind.value = e!;
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 10,
                              )
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
                            text: Strings.saveAndRecord,
                            color: Colors.orange.darker,
                            textColor: Colors.white,
                            onPressed: () => onBtnSaveListener("saveRecord"),
                            kind: "big"),
                        const SizedBox(
                          width: 10,
                        ),CButton(
                            text: Strings.save,
                            color: Colors.blue.normal,
                            textColor: Colors.white,
                            onPressed: ()=>onBtnSaveListener("save"),
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
