import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/assets/values/textStyle.dart';
import 'package:bas_dataset_generator_engine/src/pages/exportReviewPage/viewModels/exportObjectsViewModel.dart';
import 'package:bas_dataset_generator_engine/src/parts/dialogTitleBar.dart';
import 'package:bas_dataset_generator_engine/src/widgets/CButton.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class DlgExportObjects extends StatelessWidget {
  DlgExportObjects({
    Key? key,
    required this.objNames,
    required this.onObjectSelectCaller
  }) : super(key: key);

  List<String> objNames;
  ValueSetter<List<String>> onObjectSelectCaller;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: () => const _View(),
      viewModel: ExportObjectsViewModel(objNames,onObjectSelectCaller),
    );
  }
}

class _View extends StatelessView<ExportObjectsViewModel> {
  const _View({Key? key}) : super(key: key);

  @override
  Widget render(context, ExportObjectsViewModel vm) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
            width: Dimens.dialogBigWidth,
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
                    title: Strings.dlgExportNames,
                    onActionListener: vm.onCloseClicked,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      height: Dimens.dialogBigHeight-130,
                      child: ListView.builder(
                          itemCount: vm.objNames.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            return Container(
                              height: 50,
                                decoration: BoxDecoration(
                                  color: vm.exportNames.contains(vm.objNames[index])?Colors.green.light.withOpacity(.3):Colors.transparent
                                ),
                                child: IconButton(
                                  icon: Row(
                                    children: [
                                      const SizedBox(width: 10,),
                                      vm.exportNames.contains(vm.objNames[index])?Icon(FluentIcons.circle_fill,color: Colors.green.dark):Icon(FluentIcons.circle_ring),
                                      const SizedBox(width: 20,),
                                      Text(vm.objNames[index],style: TextSystem.textM(Colors.white),),
                                    ],
                                  ),
                                  onPressed:()=> vm.onSelectNameHandler(vm.objNames[index]),
                                )
                            );
                          }),
                    ),
                  ),
                  Row(
                    children: [
                      const Spacer(),
                      CButton(
                          text: Strings.nextStep,
                          color: Colors.blue.normal,
                          textColor: Colors.white,
                          onPressed: () => vm.onNextLevelHandler(),
                          kind: "normal"),
                      const SizedBox(width: 10,)
                    ],
                  )
                ],
              ),
            )),
      ],
    );
  }
}
