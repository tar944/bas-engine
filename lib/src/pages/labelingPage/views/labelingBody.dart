import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/assets/values/textStyle.dart';
import 'package:bas_dataset_generator_engine/src/data/models/imageGroupModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/labelModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/labelingPage/viewModels/labelingBodyViewModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/labelingPage/views/objectItem.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:pmvvm/pmvvm.dart';

class LabelingBody extends StatelessWidget {
  LabelingBody({Key? key, required this.objects,required this.relatedLabels, required this.curGroup})
      : super(key: key);

  List<ObjectModel> objects;
  List<LabelModel> relatedLabels;
  ImageGroupModel curGroup;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: () => const _View(),
      viewModel: LabelingBodyViewModel(objects, curGroup),
    );
  }
}

class _View extends StatelessView<LabelingBodyViewModel> {
  const _View({Key? key}) : super(key: key);

  @override
  Widget render(context, LabelingBodyViewModel vm) {
    return SizedBox(
      height: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: vm.objects.isNotEmpty
                    ? GridView(
                        controller: ScrollController(keepScrollOffset: false),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 300,
                                childAspectRatio: 3.2 / 2,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20),
                        children: vm.objects
                            .map((item) => ObjectItem(
                                  key: GlobalKey(),
                                  allGroups: [],
                                  object: item,
                                  isSubGroup: false,
                                  onActionCaller: vm.onObjectActionHandler,
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
                                image: AssetImage(
                                    'lib/assets/images/emptyBox.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          Text(
                            Strings.emptyUnSortObjects,
                            style: TextSystem.textL(Colors.white),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
