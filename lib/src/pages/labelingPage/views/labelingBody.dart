import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/assets/values/textStyle.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/labelingPage/viewModels/labelingBodyViewModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/labelingPage/views/labelBodyTagLine.dart';
import 'package:bas_dataset_generator_engine/src/pages/labelingPage/views/objectItem.dart';
import 'package:bas_dataset_generator_engine/src/utility/enum.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:pmvvm/pmvvm.dart';

class LabelingBody extends StatelessWidget {
  LabelingBody({
    Key? key,
    required this.objects,
    required this.prjUUID,
    required this.partUUID,
    required this.grpUUID,
    required this.onGroupActionCaller
  }) : super(key: key);

  List<ObjectModel> objects;
  String prjUUID,partUUID,grpUUID;
  ValueSetter<String> onGroupActionCaller;


  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: () => const _View(),
      viewModel: LabelingBodyViewModel(objects,grpUUID,partUUID,prjUUID,onGroupActionCaller),
    );
  }
}

class _View extends StatelessView<LabelingBodyViewModel> {
  const _View({Key? key}) : super(key: key);

  @override
  Widget render(context, LabelingBodyViewModel vm) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        height: MediaQuery.sizeOf(context).height-300,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          color: Colors.grey[200]
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
          child: Column(
            children: [
              if(vm.tagLineState=="show")
                LabelBodyTagLine(
                    subGroups: vm.subGroups,
                    curGroup: vm.curGroup,
                    onLabelActionHandler: vm.onLabelActionHandler),
              if(vm.tagLineState!="show")
                Row(
                  children: [
                    Container(
                      width: Dimens.circleW,
                      height: Dimens.circleW,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey[170])
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left:3.0),
                        child: Icon(FluentIcons.double_chevron_right,size: 15,color: Colors.orange.dark,),
                      ),
                    ),
                    const SizedBox(width: 10,),
                    Text(vm.tagLineState=="firstStep"?Strings.groupFirstStep:Strings.groupSecondStep),
                  ],
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
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
                                    allGroups: vm.subGroups,
                                    stepStatus: vm.tagLineState=="secondStep"?"labelIt":vm.tagLineState=="firstStep"?"firstStep":"hide",
                                    isMainObject: vm.isMainObject(item),
                                    object: item,
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
      ),
    );
  }
}
