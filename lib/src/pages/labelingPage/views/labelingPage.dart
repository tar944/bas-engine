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
      required this.onGroupActionCaller,
      required this.controller});

  int partId;
  String prjUUID;
  ValueSetter<String> onGroupActionCaller;
  final GroupController controller;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: () => _View(controller: controller),
      viewModel: LabelingViewModel(partId,prjUUID, onGroupActionCaller),
    );
  }
}

class _View extends StatelessView<LabelingViewModel> {
  const _View({Key? key, required this.controller}) : super(key: key);

  final GroupController controller;

  @override
  Widget render(context, LabelingViewModel vm) {
    controller.call(context, vm.createGroup);

    return SizedBox(
      height: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
        child:vm.allNavsRows.isNotEmpty?ListView.builder(
            itemCount: vm.allNavsRows.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              if(index!=vm.allNavsRows.length-1){
                return NavigationRow(
                    allNavs: vm.allNavsRows[index],
                    rowNumber: index,
                    onNavSelectedCaller: vm.onNavItemSelectHandler);
              }else{
                return LabelingBody(objects: vm.objects, curGroup: vm.curGroup);
              }
            }):Container()
      ),
    );
  }
}
