
import 'dart:io';

import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/assets/values/textStyle.dart';
import 'package:bas_dataset_generator_engine/src/data/models/navModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class NavItem extends HookWidget {
  NavItem({
    Key? key,
    required this.navItem,
    required this.selectStatus,
    required this.onItemSelectedCaller
  }) : super(key: key);

  NavModel navItem;
  String selectStatus;
  ValueSetter<NavModel> onItemSelectedCaller;

  @override
  Widget build(BuildContext context) {

    return Opacity(
      opacity: selectStatus=="notSelected"?0.5:1.0,
      child: IconButton(
        onPressed: ()=>{},
        icon: Container(
          width: Dimens.navItemW,
          height: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: selectStatus=="selected"?Colors.teal:Colors.white),
            borderRadius: const BorderRadius.all(Radius.circular(3.0)),
          ),
          child: Row(
            children: [
              Container(
                width: Dimens.navItemW,
                height: Dimens.navItemW*2.2,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(2.0)),
                  image: DecorationImage(
                    image: Image.file(File(navItem.imgPath)).image,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Column(
                children: [
                  Text(navItem.title,style: TextSystem.textM(selectStatus=="selected"?Colors.teal:Colors.white),),
                  const SizedBox(height: 10,),
                  Text("${navItem.imgNumber} ${navItem.imgNumber==1?"image":"images"}",style: TextSystem.textS(selectStatus=="selected"?Colors.teal:Colors.white),),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
