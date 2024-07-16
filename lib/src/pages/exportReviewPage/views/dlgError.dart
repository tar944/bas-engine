import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/assets/values/textStyle.dart';
import 'package:bas_dataset_generator_engine/src/data/models/pascalObjectModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/exportReviewPage/viewModels/DlgErrorViewModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/exportReviewPage/viewModels/objectPropertiesViewModel.dart';
import 'package:bas_dataset_generator_engine/src/parts/dialogTitleBar.dart';
import 'package:bas_dataset_generator_engine/src/widgets/CButton.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:pmvvm/pmvvm.dart';

class DlgError extends StatelessWidget {
  DlgError({
    Key? key,
    required this.errors,
  }) : super(key: key);

  List<String> errors;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: () => const _View(),
      viewModel: DlgErrorViewModel(errors),
    );
  }
}

class _View extends StatelessView<DlgErrorViewModel> {
  const _View({Key? key}) : super(key: key);

  @override
  Widget render(context, DlgErrorViewModel vm) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
            width: Dimens.dialogLargeWidth-100,
            height: Dimens.dialogBigHeight,
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
                    title: '${Strings.dlgError} (${vm.errors.length})',
                    onActionListener: vm.onCloseClicked,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      height: Dimens.dialogBigHeight-75,
                      child: ListView.builder(
                          itemCount: vm.errors.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            return SizedBox(
                              height: 50,
                                child: Text('${index+1}: ${vm.errors[index]}',style: TextSystem.textM(Colors.white),));
                          }),
                    ),
                  )
                ],
              ),
            )),
      ],
    );
  }
}
