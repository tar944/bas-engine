import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/assets/values/textStyle.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/recordedScreenGroupsDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/screenShotDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/models/screenShootModel.dart';
import 'package:bas_dataset_generator_engine/src/items/screenItem.dart';
import 'package:bas_dataset_generator_engine/src/utility/platform_util.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:window_manager/window_manager.dart';

class ScreenLabeling extends HookWidget with WindowListener {
  int? groupId;

  ScreenLabeling(this.groupId, {super.key});

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
        final group = await RecordedScreenGroupDAO().getGroup(groupId!);
        if (group!.screenShoots.toList().isNotEmpty) {
          allScreens.value = group.screenShoots.toList();
          for (final screen in allScreens.value) {
            if (screen.status == 'created') {
              indexImage.value = allScreens.value.indexOf(screen);
              break;
            }
          }
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
          await RecordedScreenGroupDAO().removeAScreenShoot(groupId!, screen);
          allScreens.value = await RecordedScreenGroupDAO().getAllScreens(groupId!);
          break;
      }
    }

    onBackClicked(){

    }

    return ScaffoldPage(
        padding: const EdgeInsets.only(top: 0, bottom: 0),
        content: SizedBox.expand(
          child: Column(children: [
            if (allScreens.value.isEmpty)
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.grey[150],
                  child: Column(
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
                        'your Screen list is empty...',
                        style: TextSystem.textL(Colors.white),
                      ),
                    ],
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
