
import 'dart:io';

import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/assets/values/textStyle.dart';
import 'package:bas_dataset_generator_engine/src/data/models/navModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class NavItem extends HookWidget {
  NavItem({
    Key? key,
    required this.navItem,
    required this.selectStatus,
    required this.showAddBtn,
    required this.onItemSelectedCaller,
    required this.onAddNewShapeCaller,
  }) : super(key: key);

  final NavModel navItem;
  final String selectStatus;
  final bool showAddBtn;
  ValueSetter<NavModel> onItemSelectedCaller;
  ValueSetter<NavModel> onAddNewShapeCaller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Opacity(
        opacity: selectStatus=="notSelected"?0.5:1.0,
        child: IconButton(
          onPressed: ()=>onItemSelectedCaller(navItem),
          style: ButtonStyle(
            padding: ButtonState.all(EdgeInsets.zero)
          ),
          icon: Row(
            children: [
              Container(
                width: Dimens.navItemW,
                height: Dimens.navH,
                decoration: BoxDecoration(
                  border: Border.all(color: selectStatus=="selected"?Colors.teal:Colors.white),
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
                            image: navItem.imgPath!=""?Image.file(File(navItem.imgPath)).image:const AssetImage(
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
                          Text(navItem.title.length>16?"${navItem.title.substring(0,15)}...":navItem.title,style: TextSystem.textM(selectStatus=="selected"?Colors.teal:Colors.white),),
                          const SizedBox(height: 2,),
                          Text(navItem.kind=="part"?"${navItem.description.length>20?navItem.description.substring(0,20):navItem.description}...":navItem.lblName,style: TextSystem.textXs(selectStatus=="selected"?Colors.teal:Colors.white),),
                        ],
                      ),
                    )],),
              ),
              if(selectStatus=="selected"&&showAddBtn)
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
                      ), onPressed: ()=>onAddNewShapeCaller(navItem)),
                  const SizedBox(width: 5.0,)
                ]
            ],
          ),
        ),
      ),
    );
  }
}
