
import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/src/dialogs/toast.dart';
import 'package:bas_dataset_generator_engine/src/parts/dialogTitleBar.dart';
import 'package:bas_dataset_generator_engine/src/widgets/CButton.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class DlgTitle extends HookWidget {
  DlgTitle({
    Key? key,
    required this.title,
    required this.dlgTitle,
    required this.onActionCaller,
  }) : super(key: key);

  final ValueSetter<String> onActionCaller;
  String title,dlgTitle;

  @override
  Widget build(BuildContext context) {
    void onCloseClicked() {
      Navigator.pop(context);
    }

    var ctlTitle = TextEditingController(text: title);

    void onBtnSaveListener() async{
      if (ctlTitle.text == "") {
        Toast("You should enter a title for this level", false).showWarning(context);
        return;
      }
      onActionCaller('update&&${ctlTitle.text}');
      Navigator.pop(context);
    }

    onBtnRemoveHandler(){
      onActionCaller('delete&&');
      Navigator.pop(context);
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
            width: Dimens.dialogSmallWidth,
            height: Dimens.dialogSmallHeight,
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
                    title: dlgTitle,
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 5,),
                        IconButton(
                          style:ButtonStyle(
                              padding: ButtonState.all(EdgeInsets.zero)
                            ),
                            icon: Container(
                              width: Dimens.btnHeightBig,
                              height: Dimens.btnHeightBig,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(5.0))
                              ),
                              child: Icon(FluentIcons.delete,color: Colors.red.dark,size: 18,),
                            ),
                            onPressed: ()=>onBtnRemoveHandler()),
                        const SizedBox(width: 205,),
                        CButton(
                            text: Strings.save,
                            color: Colors.blue.normal,
                            textColor: Colors.white,
                            onPressed: () => onBtnSaveListener(),
                            kind: "normal"),
                        const SizedBox(
                          width: 5,
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
