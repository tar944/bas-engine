import 'package:bas_dataset_generator_engine/src/data/models/screenShootModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:window_manager/window_manager.dart';
import '../../assets/values/dimens.dart';
import '../../assets/values/strings.dart';

import '../../assets/values/textStyle.dart';
import '../items/labelingItem.dart';
import '../parts/addsOnPanel.dart';
import '../parts/topBarPanel.dart';
import '../utility/platform_util.dart';
import '../widgets/flyoutMainPageLabeling.dart';

class MainPageLabeling extends HookWidget with WindowListener {
  const MainPageLabeling({super.key});

  void _init() async {
    // Add this line to override the default close handler
    await windowManager.setPreventClose(true);

    windowManager.waitUntilReadyToShow().then((_) async {
      if (kIsLinux || kIsWindows) {
        if (kIsLinux) {
          await windowManager.setAsFrameless();
        } else {
          await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
        }
        await windowManager.setPosition(Offset.zero);
      }
      await windowManager.setSkipTaskbar(true);
      await windowManager.setFullScreen(true);
      await Future.delayed(const Duration(milliseconds: 100));
      await _windowShow();
    });
  }

  Future<void> _windowShow({
    bool isShowBelowTray = false,
  }) async {
    bool isAlwaysOnTop = await windowManager.isAlwaysOnTop();
    if (kIsLinux) {
      await windowManager.setPosition(Offset.zero);
    }

    bool isVisible = await windowManager.isVisible();
    if (!isVisible) {
      await windowManager.show();
    } else {
      await windowManager.focus();
    }

    if (kIsLinux && !isAlwaysOnTop) {
      await windowManager.setAlwaysOnTop(true);
      await Future.delayed(const Duration(milliseconds: 10));
      await windowManager.setAlwaysOnTop(false);
      await Future.delayed(const Duration(milliseconds: 10));
      await windowManager.focus();
    }
  }

  @override
  Widget build(BuildContext context) {


    useEffect(() {
      _init();
      return null;
    }, const []);

    final List<ScreenShootModel> imageList = [];

    final indexImage = useState(0);

    nextImage() {
      indexImage.value = ++indexImage.value;
      if (indexImage.value== imageList.length) {
        return indexImage.value=0;
      }
    }

    perviousImage() {
      if(indexImage.value==0)
        return;
      indexImage.value = --indexImage.value;
      print(indexImage.value);
    }


    onImageHandler(int index){
        indexImage.value = index;
    }






    return ScaffoldPage(
        padding: const EdgeInsets.only(top: 0, bottom: 0),
        content: SizedBox.expand(
          child: Column(children: [
            TopBarPanel(
              title: Strings.pageVideo,
              needBack: true,
              needHelp: false,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AddsOnPanel(
                  kind: "library",
                  onActionCaller: (String) {},
                ),
                Container(
                  width: MediaQuery.of(context).size.width -
                      (Dimens.actionBtnW + 15),
                  decoration: BoxDecoration(color: Colors.grey[190]),
                  child: Stack(

                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width -
                            (Dimens.actionBtnW + 15),
                        height: MediaQuery.of(context).size.height - (Dimens.topBarHeight),
                        child: LabelingItem(
                          item: imageList[indexImage.value],
                          nextClick: nextImage,
                          perviousClick: perviousImage, itemBottom: imageList,
                        ),
                      ),
                      Positioned(
                          right: 0,
                          left: 0,
                          bottom: 10,
                          child: Column(
                            children: [
                              FlyoutMainPageLabeling(),

                              Padding(
                                padding: const EdgeInsets.only(left: 10,right: 10,bottom: 20),
                                child: Container(
                                  height: 100,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10),

                                  ),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 10),
                                        child: Container(
                                          height: 80,
                                          width: MediaQuery.of(context).size.width-150,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),color: Colors.grey
                                          ),
                                          child: ListView.builder(
                                              itemCount: imageList.length,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context,index){
                                                return GestureDetector(
                                                  onTap: ()=> onImageHandler(index),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(5),
                                                    child: Container(
                                                      height: 80,

                                                      width: 150,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(Dimens.actionRadius),
                                                        image:  DecorationImage(
                                                          image: ExactAssetImage(imageList[index].imageName!),
                                                          fit: BoxFit.cover,
                                                        ),

                                                      ),
                                                      child: Row(
                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.all(5),
                                                            child: Container(
                                                              width: 25,
                                                              height: 25,
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(5),
                                                                color: Colors.red,
                                                              ),
                                                              child: Icon(
                                                                CupertinoIcons.delete,color: Colors.white,size: 15,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }),
                                        ),
                                      ),
                                      Spacer(),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: 35,
                                              height: 35,
                                              decoration: BoxDecoration(
                                                color: Colors.grey,
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                              child: Center(child: Text('All',style: TextSystem.textS(Colors.white),)),
                                            ),
                                            Container(
                                              width: 35,
                                              height: 35,
                                              decoration: BoxDecoration(
                                                color: Colors.grey,
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                              child: Center(child: Text('All',style: TextSystem.textS(Colors.white),)),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ))
                    ],
                  ),
                )
              ],
            )
          ]),
        ));
  }
}