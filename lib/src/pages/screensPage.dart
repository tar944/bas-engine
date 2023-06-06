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
import '../parts/topBarPanel.dart';
import '../utility/platform_util.dart';

class ScreensPage extends HookWidget with WindowListener {
  int? videoId;

  ScreensPage(this.videoId, {super.key});

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
    final indexImage = useState(0);

    useEffect(() {
      _init();
      Future<void>.microtask(() async {
        final video = await VideoDAO().getVideo(videoId!);
        if (video!.screenShoots.toList().isNotEmpty) {
          allScreens.value = video.screenShoots.toList();
          for (final screen in allScreens.value) {
            if (screen.status == 'created') {
              indexImage.value = allScreens.value.indexOf(screen);
              break;
            }
          }
        } else {
          final screenResult = await PythonHelper().generateScreenShoots(
              video.path,
              await DirectoryManager().getScreenDirectoryPath(
                  '${video.software.target!.id}_${video.software.target!.title!}',
                  video.name!));
          for (var screen in screenResult) {
            print(screen['path']);
            final newScreen = ScreenShootModel(0, screen['hashDifference'],
                screen['imageName'], screen['path'], 'created');
            newScreen.video.target = video;
            ScreenDAO().addScreen(newScreen);
          }
          allScreens.value = await VideoDAO().getAllScreens(videoId!);
        }
      });
      return null;
    }, const []);

    onImageHandler(String action) async {
      print(action);
      var actions = action.split('&&');
      ScreenShootModel? screen =
          await ScreenDAO().getScreen(int.parse(actions[1]));
      switch (actions[0]) {
        case 'delete':
          await ScreenDAO().deleteScreen(screen!);
          allScreens.value = await VideoDAO().getAllScreens(videoId!);
          break;
      }
    }

    return ScaffoldPage(
        padding: const EdgeInsets.only(top: 0, bottom: 0),
        content: SizedBox.expand(
          child: Column(children: [
            TopBarPanel(
              title: allScreens.value.isNotEmpty?'${Strings.screensPage+'   ( ' + allScreens.value[indexImage.value].imageName} )':Strings.screensPage,
              needBack: true,
              needHelp: false,
            ),
            if (allScreens.value.isEmpty)
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.grey[150],
                  child: Text(
                    "please waiting ...",
                    style: TextSystem.textL(Colors.white),
                  ),
                ),
              )
            else
              Container(
                alignment: Alignment.center,
                color: Colors.grey[190],
                width: MediaQuery.of(context).size.width ,
                height: MediaQuery.of(context).size.height -
                    (Dimens.topBarHeight),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView(
                    controller: ScrollController(
                        keepScrollOffset: false),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    gridDelegate:
                    const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 700,
                        childAspectRatio: 3 / 1.8,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10),
                    children: allScreens.value
                        .map((item) => ScreenItem(screen: item,onActionCaller: onImageHandler,))
                        .toList(),
                  ),
                ),
              ),
          ]),
        ));
  }
}
