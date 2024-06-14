import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/assets/values/textStyle.dart';
import 'package:bas_dataset_generator_engine/src/data/models/pascalObjectModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/exportReviewPage/viewModels/objectPropertiesViewModel.dart';
import 'package:bas_dataset_generator_engine/src/parts/dialogTitleBar.dart';
import 'package:bas_dataset_generator_engine/src/widgets/CButton.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:pmvvm/pmvvm.dart';

class DlgObjProperties extends StatelessWidget {
  DlgObjProperties({
    Key? key,
    required this.object,
    required this.onActionCaller,
  }) : super(key: key);

  final ValueSetter<String> onActionCaller;
  PascalObjectModel object;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: () => const _View(),
      viewModel: ObjectPropertiesViewModel(object,onActionCaller),
    );
  }
}

class _View extends StatelessView<ObjectPropertiesViewModel> {
  const _View({Key? key}) : super(key: key);

  @override
  Widget render(context, ObjectPropertiesViewModel vm) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
            width: Dimens.dialogNormalWidth,
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
                    title: Strings.objectExpProperties,
                    onActionListener: vm.onCloseClicked,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MultiSelectContainer(
                        key: GlobalKey(),
                        singleSelectedItem: true,
                        wrapSettings: const WrapSettings(
                            spacing: 5.0
                        ),
                        itemsPadding: const EdgeInsets.all(2.0),
                        textStyles: MultiSelectTextStyles(
                            textStyle: TextSystem.textXs(Colors.white),
                            selectedTextStyle: TextSystem.textXs(Colors.white)
                        ),
                        itemsDecoration: MultiSelectDecorations(
                            decoration:BoxDecoration(
                                color: Colors.grey[170],
                                borderRadius: const BorderRadius.all(Radius.circular(15)),
                                border: Border.all(color: Colors.grey[150])
                            ) ,
                            selectedDecoration: BoxDecoration(
                              color: Colors.teal.dark,
                              borderRadius: const BorderRadius.all(Radius.circular(15)),
                              border: Border.all(color: Colors.teal),
                            )
                        ),
                        items: vm.nameParts.map((e)=>MultiSelectCard(
                          selected: vm.exportParts.contains(e),
                          value: e,
                          label: e,
                        )
                        ).toList(),
                        onChange: vm.onNamePartSelected),
                  ),
                  const Spacer(),
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
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: IconButton(
                              icon: Icon(FluentIcons.delete,color: Colors.red.dark,size: 20,),
                              onPressed: ()=>vm.onBtnDeleteHandler()),
                        ),
                        const Spacer(),
                        CButton(
                            text: Strings.confirm,
                            color: Colors.blue.normal,
                            textColor: Colors.white,
                            onPressed: () => vm.onBtnConfirmListener(),
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
