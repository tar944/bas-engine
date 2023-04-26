import 'package:bas_dataset_generator_engine/assets/values/textStyle.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../items/floutMainPageLabelingItem.dart';

class FlyoutMainPageLabeling extends HookWidget {
  const FlyoutMainPageLabeling({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    List<String> titleList = ['mainPage','subPage','dialog','menu','submenu','rightMenu'];
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[200],
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10,right: 10),
          child: Row(children: [
            Container(
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(5)
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 5,right: 5),
                child: Row(
                  children: [
                    FlyoutMainPageLabelingItem(title: titleList[0],),
                    const SizedBox(width: 5,),
                    FlyoutMainPageLabelingItem(title: titleList[1],),
                    const SizedBox(width: 5,),
                    FlyoutMainPageLabelingItem(title: titleList[2],),
                    const SizedBox(width: 5,),
                    FlyoutMainPageLabelingItem(title: titleList[3],),
                    const SizedBox(width: 5,),
                    FlyoutMainPageLabelingItem(title: titleList[4],),
                    const SizedBox(width: 5,),
                    FlyoutMainPageLabelingItem(title: titleList[5],),


                  ],
                ),
              ),
            ),

          ],),
        ),
      ),
    );
  }
}





