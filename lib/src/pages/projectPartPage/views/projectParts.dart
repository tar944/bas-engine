import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/assets/values/textStyle.dart';
import 'package:bas_dataset_generator_engine/src/pages/projectPartPage/viewModels/projectPartsViewModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/projectPartPage/views/projectPartItem.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

typedef PartController = void Function(BuildContext context, void Function() methodOfPart);

class ProjectParts extends StatelessWidget {
  ProjectParts(
      {
        super.key,
        required this.prjId,
        required this.onPartActionCaller,
        required this.controller,
      });

  int prjId;
  ValueSetter<int> onPartActionCaller;
  final PartController controller;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: () => _View(controller: controller,),
      viewModel: ProjectPartsViewModel(prjId, onPartActionCaller),
    );
  }
}

class _View extends StatelessView<ProjectPartsViewModel> {
  const _View({Key? key,required this.controller}) : super(key: key);

  final PartController controller;

  @override
  Widget render(context, ProjectPartsViewModel vm) {
    controller.call(context,vm.createPart);
    return SizedBox(
      height: double.infinity,
      child:Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
        child:Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: vm.parts.isNotEmpty
                  ? GridView(
                key: GlobalKey(),
                controller: ScrollController(keepScrollOffset: false),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                gridDelegate:
                const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 280,
                    childAspectRatio: 3.2 / 3.2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20),
                children: vm.parts
                    .map((item) => ProjectPartItem(
                  part: item,
                  onActionCaller: vm.onPartSelect,
                ))
                    .toList(),
              )
                  : Column(
                children: [
                  const SizedBox(
                    height: 150,
                  ),
                  Container(
                    height: 350,
                    width: 350,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('lib/assets/images/emptyBox.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Text(
                    Strings.emptyPart,
                    style: TextSystem.textL(Colors.white),
                  ),
                ],
              ),
            ),
            if(vm.needLoading)
              Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    color: Colors.grey[190].withOpacity(.6),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 350,
                        ),
                        Text(Strings.waitToImportFile,style: TextSystem.textL(Colors.white),),
                        const SizedBox(height: 10,),
                        SizedBox(width:150,height:50,child: ProgressBar(value: vm.importedValue,)),
                      ],
                    ),
                  )
              )
          ],
        )
      ),
    );
  }
}
