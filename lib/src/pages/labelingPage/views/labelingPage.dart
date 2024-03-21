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
        child:vm.allNavsRows.isNotEmpty?ListView.builder(
            itemCount: vm.allNavsRows.length+1,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              if(index!=vm.allNavsRows.length){
                return NavigationRow(
                    allNavs: vm.allNavsRows[index],
                    rowNumber: index+1,
                    selectedNav: vm.selectedNavs[index],
                    onNavSelectedCaller: vm.onNavItemSelectHandler);
              }else{
                return LabelingBody(
                    key: GlobalKey(),
                    objects: vm.objects,
                    prjUUID: vm.prjUUID,
                    partUUID: vm.curPart!=null?vm.curPart!.uuid:"",
                    grpUUID: vm.curGroup!=null?vm.curGroup!.uuid:"",
                    onGroupActionCaller: vm.onGroupSelect,
                );
              }
            }):Container()
      ),
    );
  }
}
