import 'package:bas_dataset_generator_engine/src/pages/labelingPage/viewModels/labelingViewModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/labelingPage/views/labelingBody.dart';
import 'package:bas_dataset_generator_engine/src/pages/labelingPage/views/navigationRow.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

typedef GroupController = void Function(
    BuildContext context, void Function() methodOfGroup);

class LabelingPage extends StatelessWidget {
  LabelingPage(
      {super.key,
      required this.partId,
      required this.prjUUID,
      required this.onGroupActionCaller});

  int partId;
  String prjUUID;
  ValueSetter<String> onGroupActionCaller;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: () => const _View(),
      viewModel: LabelingViewModel(partId,prjUUID, onGroupActionCaller),
    );
  }
}

class _View extends StatelessView<LabelingViewModel> {
  const _View({Key? key}) : super(key: key);

  @override
  Widget render(context, LabelingViewModel vm) {
    return SizedBox(
      height: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
        child:vm.allNavRows.isNotEmpty?
        ListView.builder(
          key: GlobalKey(),
            itemCount: vm.allNavRows.length+1,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              if(index!=vm.allNavRows.length){
                return NavigationRow(
                    rowController: vm.allNavRows[index],
                    onNavSelectedCaller: vm.onNavItemSelectHandler,
                    onChangeShapeCaller: vm.onChangeShapeHandler,
                  onSelectShapeCaller: vm.onShapeChangeHandler,
                );
              }else{
                return LabelingBody(
                  key: GlobalKey(),
                    bodyController: vm.bodyController,
                    onGroupActionCaller: vm.onGroupSelect,
                );
              }
            }):Container()
      ),
    );
  }
}
