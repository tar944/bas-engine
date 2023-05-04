import 'package:bas_dataset_generator_engine/src/data/models/scenePartModel.dart';
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
import '../widgets/pagePartsList.dart';

class PagePartLabeling extends HookWidget with WindowListener {
  const PagePartLabeling({super.key});

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
      if (indexImage.value == imageList.length) {
        return indexImage.value = 0;
      }
    }

    perviousImage() {
      if (indexImage.value == 0) return;
      indexImage.value = --indexImage.value;
      print(indexImage.value);
    }

    onImageHandler(int index) {
      indexImage.value = index;
    }

    final showPartList = useState(false);

    showPartListOpen() {
      showPartList.value = true;
    }

    showPartListClose() {
      showPartList.value = false;
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
                        height: MediaQuery.of(context).size.height -
                            (Dimens.topBarHeight),
                        child: LabelingItem(
                          item: imageList[indexImage.value],
                          nextClick: nextImage,
                          perviousClick: perviousImage,
                          itemBottom: imageList,
                        ),
                      ),
                      Positioned(
                          right: 0,
                          left: 0,
                          bottom: 10,
                          child: Column(
                            children: [
                              showPartList.value==true?
                              PagePartsList():
                              Container(),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 10, bottom: 5),
                                    child: Container(
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'All Parts Show :',
                                              style: TextSystem.textS(
                                                  Colors.white),
                                            ),
                                            Text(
                                              ' 112',
                                              style: TextSystem.textS(
                                                  Colors.orange),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Container(
                                  height: 100,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        height: 80,
                                        width:
                                            MediaQuery.of(context).size.width -
                                                100,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Colors.grey),
                                        child: ListView.builder(
                                            itemCount: imageList.length,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              return GestureDetector(
                                                onTap: () =>
                                                    onImageHandler(index),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  child: Container(
                                                    height: 80,
                                                    width: 150,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius
                                                          .circular(Dimens
                                                              .actionRadius),
                                                      image: DecorationImage(
                                                        image: ExactAssetImage(
                                                            imageList[index]
                                                                .imageName!),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Container(
                                                          height: 30,
                                                          width:
                                                              double.infinity,
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .grey[170]
                                                                  .withOpacity(
                                                                      0.7),
                                                              borderRadius: BorderRadius.only(
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          Dimens
                                                                              .actionRadius),
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          Dimens
                                                                              .actionRadius))),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    5, 0, 5, 0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                GestureDetector(
                                                                    onTap:
                                                                        () {showPartListClose(); },
                                                                    child: Text(
                                                                      'Create Parts',
                                                                      style: TextSystem.textXs(
                                                                          Colors
                                                                              .white),
                                                                    )),
                                                                GestureDetector(
                                                                  onTap: (){showPartListOpen();},
                                                                  child: Text(
                                                                    'Show Parts',
                                                                    style: TextSystem
                                                                        .textXs(Colors
                                                                            .white),
                                                                  ),
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
                                            }),
                                      ),
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
