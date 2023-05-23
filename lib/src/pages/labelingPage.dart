import 'package:bas_dataset_generator_engine/src/data/dao/screenShotDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/videoDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/models/screenShootModel.dart';
import 'package:bas_dataset_generator_engine/src/items/screenItem.dart';
import 'package:bas_dataset_generator_engine/src/python/pythonHelper.dart';
import 'package:bas_dataset_generator_engine/src/utility/directoryManager.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:window_manager/window_manager.dart';
import '../../assets/values/dimens.dart';
import '../../assets/values/strings.dart';
import '../../assets/values/textStyle.dart';
import '../items/labelingItem.dart';
import '../parts/topBarPanel.dart';
import '../utility/platform_util.dart';
import '../widgets/flyoutMainPageLabeling.dart';

class LabelingPage extends HookWidget with WindowListener {
  int? videoId;

  LabelingPage(this.videoId, {super.key});

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
    final allScreens = useState([]);

    useEffect(() {
      _init();
      Future<void>.microtask(() async {
        final video = await VideoDAO().getVideo(videoId!);
        if (video!.screenShoots.toList().isNotEmpty) {
          allScreens.value = video.screenShoots.toList();
        } else {
          final screenResult = await PythonHelper().generateScreenShoots(
              video.path,
              await DirectoryManager().getScreenDirectoryPath(
                  '${video.software.target!.id}_${video.software.target!.title!}',
                  video.name!));
          for(var screen in screenResult){
            final newScreen = ScreenShootModel(0, screen['hashDifference'],screen['imageName'], screen['path'], 'created');
            newScreen.video.target=video;
            ScreenDAO().addScreen(newScreen);
          }
          allScreens.value = await VideoDAO().getAllScreens(videoId!);
        }
      });
      return null;
    }, const []);

    final indexImage = useState(0);

    nextImage() {
      indexImage.value = ++indexImage.value;
      if (indexImage.value == allScreens.value.length) {
        return indexImage.value = 0;
      }
    }

    perviousImage() {
      if (indexImage.value == 0) return;
      indexImage.value = --indexImage.value;
    }

    onImageHandler(String action) {
      // indexImage.value = index;
    }

    return ScaffoldPage(
        padding: const EdgeInsets.only(top: 0, bottom: 0),
        content: SizedBox.expand(
          child: Column(children: [
            TopBarPanel(
              title: '${'${Strings.pageLabeling}   ( '+allScreens.value[indexImage.value].imageName} )',
              needBack: true,
              needHelp: false,
            ),
            if (allScreens.value.isEmpty)
              Expanded(
                child: Container(
                      alignment: Alignment.center,
                      color: Colors.grey[150],
                      child: Text("please waiting ...",style: TextSystem.textL(Colors.white),),
                    ),
              ) else Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width ,
                            height: MediaQuery.of(context).size.height -
                                (Dimens.topBarHeight),
                            child: LabelingItem(
                              item: allScreens.value[indexImage.value],
                              nextClick: nextImage,
                              perviousClick: perviousImage,
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
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10, bottom: 20),
                                    child: Container(
                                      height: 110,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius:
                                            BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10,right: 10,top: 5,bottom: 5),
                                        child: Container(
                                          height: 80,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      5),
                                              color: Colors.grey),
                                          child: ListView.builder(
                                              itemCount:
                                                  allScreens.value.length,
                                              scrollDirection:
                                                  Axis.horizontal,
                                              itemBuilder:
                                                  (context, index) {
                                                return ScreenItem(screen: allScreens.value[index],onActionCaller: onImageHandler,);
                                              }),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ))
                        ],
                      )
                    ],
                  )
          ]),
        ));
  }
}
