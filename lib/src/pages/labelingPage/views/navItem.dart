import 'dart:io';

import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/assets/values/textStyle.dart';
import 'package:bas_dataset_generator_engine/src/data/models/navModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/labelingPage/viewModels/navItemViewModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pmvvm/pmvvm.dart';

class NavItem extends StatelessWidget {
  NavItem({
    Key? key,
    required this.navItem,
    required this.selectStatus,
    required this.showAddBtn,
    required this.rowNumber,
    required this.onItemSelectedCaller,
    required this.onAddNewShapeCaller,
    required this.onSelectShapeCaller
  }) : super(key: key);

  NavModel navItem;
  final String selectStatus;
  final int rowNumber;
  final bool showAddBtn;
  ValueSetter<NavModel> onItemSelectedCaller;
  ValueSetter<NavModel> onAddNewShapeCaller;
  ValueSetter<NavModel> onSelectShapeCaller;

  @override
  Widget build(BuildContext context) {
    navItem.rowNumber =rowNumber;
    return MVVM(
      view: () => const _View(),
      viewModel: NavItemViewModel(navItem,selectStatus,showAddBtn,onItemSelectedCaller,onAddNewShapeCaller,onSelectShapeCaller),
    );
  }
}

class _View extends StatelessView<NavItemViewModel> {
  const _View({Key? key}) : super(key: key);

  @override
  Widget render(context, NavItemViewModel vm) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Opacity(
        opacity: vm.selectStatus=="notSelected"?0.5:1.0,
        child: IconButton(
          onPressed: ()=>vm.onItemSelectedCaller(vm.navItem),
          style: ButtonStyle(
              padding: ButtonState.all(EdgeInsets.zero)
          ),
          icon: Row(
            children: [
              Container(
                width: Dimens.navItemW,
                height: Dimens.navH,
                decoration: BoxDecoration(
                  border: Border.all(color: vm.selectStatus=="selected"?Colors.teal:Colors.white),
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                ),
                child: Row(children: [
                  Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Container(
                        width: Dimens.navH*1.5,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                          image: DecorationImage(
                            image: vm.navItem.imgPath!=""?Image.file(File(vm.navItem.imgPath)).image:const AssetImage(
                                'lib/assets/testImages/testImg1.png'),
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      )
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(vm.navItem.title.length>16?"${vm.navItem.title.substring(0,15)}...":vm.navItem.title,style: TextSystem.textM(vm.selectStatus=="selected"?Colors.teal:Colors.white),),
                        const SizedBox(height: 2,),
                        if(vm.selectStatus=="notSelected"||(vm.selectStatus=="selected"&&vm.navItem.otherShapes.isEmpty))
                          Text(vm.navItem.kind=="part"?"${vm.navItem.description.length>20?vm.navItem.description.substring(0,20):vm.navItem.description}...":vm.navItem.lblName,style: TextSystem.textXs(vm.selectStatus=="selected"?Colors.teal:Colors.white),),
                        if(vm.selectStatus=="selected"&&vm.navItem.otherShapes.isNotEmpty)
                          SizedBox(
                            width: Dimens.navItemW-(Dimens.navH*1.5)-14,
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 15,
                                    child: vm.showAddBtn?IconButton(
                                      style: ButtonStyle(
                                          padding: ButtonState.all(const EdgeInsets.all(3.0))
                                      ),
                                      icon: Icon(FluentIcons.chevron_left,color: Colors.teal.light,),
                                      onPressed: ()=>vm.onPreviousShapeHandler(),
                                    ):Container()
                                ),
                                Expanded(flex:70,child: Text(vm.navItem.shapeIndex==0?vm.navItem.title:vm.navItem.otherShapes[vm.navItem.shapeIndex-1].name!,style: TextSystem.textS(Colors.teal.light,),)),
                                Expanded(
                                    flex: 15,
                                    child: vm.showAddBtn?IconButton(
                                      style: ButtonStyle(
                                          padding: ButtonState.all(const EdgeInsets.all(3.0))
                                      ),
                                      icon: Icon(FluentIcons.chevron_right,color: Colors.teal.light,),
                                      onPressed: ()=>vm.onNextShapeHandler(),
                                    ):Container()
                                ),
                              ],
                            ),
                          )
                      ],
                    ),
                  )],),
              ),
              if(vm.navItem.kind!='part'&&vm.selectStatus=="selected"&&vm.showAddBtn)
                ...[
                  const SizedBox(width: 7,),
                  IconButton(
                      style: ButtonStyle(
                          padding: ButtonState.all(EdgeInsets.zero)
                      ),
                      icon: Container(
                        width: Dimens.navH,
                        height: Dimens.navH,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                            color: Colors.teal.dark
                        ),
                        child: const Icon(FluentIcons.add,size: 16,),
                      ), onPressed: ()=>vm.onAddNewShapeCaller(vm.navItem)),
                  const SizedBox(width: 5.0,)
                ]
            ],
          ),
        ),
      ),
    );
  }
}
