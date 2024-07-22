import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/assets/values/textStyle.dart';
import 'package:bas_dataset_generator_engine/src/data/models/pascalObjectModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/exportReviewPage/viewModels/allNamesViewModel.dart';
import 'package:bas_dataset_generator_engine/src/parts/dialogTitleBar.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class DlgAllNames extends StatelessWidget {
  DlgAllNames({
    Key? key,
    required this.objects,
    required this.onObjectChangeCaller
  }) : super(key: key);

  List<PascalObjectModel> objects;
  ValueSetter<List<PascalObjectModel>> onObjectChangeCaller;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: () => const _View(),
      viewModel: AllNamesViewModel(objects,onObjectChangeCaller),
    );
  }
}

class _View extends StatelessView<AllNamesViewModel> {
  const _View({Key? key}) : super(key: key);

  @override
  Widget render(context, AllNamesViewModel vm) {
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
                      height: Dimens.dialogBigHeight-75,
                      child: ListView.builder(
                          itemCount: vm.objects.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            return SizedBox(
                              height: 50,
                                child: IconButton(
                                  icon: Row(
                                    children: [
                                      const SizedBox(width: 10,),
                                      const Icon(FluentIcons.edit),
                                      const SizedBox(width: 20,),
                                      Text(vm.objects[index].exportName!,style: TextSystem.textM(Colors.white),),
                                    ],
                                  ),
                                  onPressed:()=> vm.onEditNameHandler(vm.objects[index]),
                                )
                            );
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
