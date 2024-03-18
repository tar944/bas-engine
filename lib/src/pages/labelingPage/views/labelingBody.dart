import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/assets/values/textStyle.dart';
import 'package:bas_dataset_generator_engine/src/data/models/imageGroupModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/labelingPage/viewModels/labelingBodyViewModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/labelingPage/views/labelTag.dart';
import 'package:bas_dataset_generator_engine/src/pages/labelingPage/views/objectItem.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:pmvvm/pmvvm.dart';

class LabelingBody extends StatelessWidget {
  LabelingBody({
    Key? key,
    required this.objects,
    required this.prjUUID,
    required this.partUUID,
    required this.grpUUID
  }) : super(key: key);

  List<ObjectModel> objects;
  String prjUUID,partUUID,grpUUID;


  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: () => const _View(),
      viewModel: LabelingBodyViewModel(objects,grpUUID,partUUID,prjUUID),
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
              SizedBox(
                width: MediaQuery.sizeOf(context).width-40,
                height: Dimens.tabHeightSmall+10,
                child: Row(
                  children: [
                    IconButton(
                        style: ButtonStyle(padding: ButtonState.all(EdgeInsets.zero)),
                        icon: Container(
                          width: Dimens.tabHeightSmall+10,
                          height: Dimens.tabHeightSmall+10,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey[160])
                          ),
                          child: Icon(FluentIcons.add,size: 18,color: Colors.teal,),
                        ),
                        onPressed: ()=>vm.onLabelActionHandler("showDialog&&")
                    ),
                    const SizedBox(width: 10,),
                    IconButton(
                        style: ButtonStyle(padding: ButtonState.all(EdgeInsets.zero)),
                        icon: Container(
                          width: Dimens.tabHeightSmall*2.8,
                          height: Dimens.tabHeightSmall+10,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular((Dimens.tabHeightSmall+10/2))),
                            border: Border.all(color: Colors.grey[160])
                          ),
                          child: Text(Strings.showAll,style: TextSystem.textS(Colors.white),),
                        ),
                        onPressed: (){}
                    ),
                    const SizedBox(width: 10,),
                    SizedBox(
                      width: 700,
                      child: ListView.builder(
                          key: GlobalKey(),
                          itemCount: vm.subGroups.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return LabelTag(
                                    curGroup: vm.subGroups[index],
                                    isSelected: vm.curGroup==null || vm.subGroups[index].id!=vm.curGroup!.id?false:true,
                                    onLabelSelectedCaller: vm.onLabelActionHandler,
                                );
                          }),
                    ),
                  ],
                ),
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
