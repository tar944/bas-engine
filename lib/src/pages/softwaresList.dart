import 'package:bas_dataset_generator_engine/src/dialogs/dlgNewSoftware.dart';
import 'package:bas_dataset_generator_engine/src/items/softwareItem.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:window_manager/window_manager.dart';

import '../../assets/values/dimens.dart';
import '../../assets/values/strings.dart';
import '../dialogs/dlgExit.dart';
import '../parts/addsOnPanel.dart';
import '../parts/topBarPanel.dart';
import '../utility/fakeData.dart';
import '../utility/platform_util.dart';

class SoftWaresList extends StatefulWidget {
  const SoftWaresList({super.key});

  @override
  State<SoftWaresList> createState() => _SoftWaresList();
}

class _SoftWaresList extends State<SoftWaresList> with WindowListener {
  Offset _lastShownPosition = Offset.zero;


  @override
  void initState() {
    windowManager.addListener(this);
    _init();
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

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
        await windowManager.setPosition(_lastShownPosition);
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
      await windowManager.setPosition(_lastShownPosition);
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

  void onCloseListener(String action) {}

  @override
  void onWindowClose() async {
    bool isPreventClose = await windowManager.isPreventClose();
    if (isPreventClose) {
      showContentDialog(context, true, onCloseListener);
    }
  }

  void onBackHandler(bool kind) {}

  @override
  Widget build(BuildContext context) {
    const skills = <String>[
      'Graphic',
      'Programming',
      '3D Arts',
      'Word',
      'Windows',
      'Crypto currency',
    ];

    void onSoftwareSelect(String title) {
      print(title);
    }

    void onCreateCourseHandler(String createdSoftware) {
    }

    void onActionHandler(String action) {
      if (action == Strings.createACourse) {
        showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) => DlgNewSoftware(
                availableSoftware: const ['Adobe PhotoShop','Adobe Primire','Microsoft Word','Microsoft Excel','Microsoft Access','Microsoft Powerpoint','Microsoft Teams','Telegram',],
                onSaveCaller: onCreateCourseHandler));
      } else {}
    }

    return ScaffoldPage(
        padding: const EdgeInsets.only(top: 0, bottom: 0),
        content: SizedBox.expand(
          child: Column(children: [
            TopBarPanel(
              title: Strings.pageLibrary,
              needBack: false,
              needHelp: false,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AddsOnPanel(
                  kind: "library",
                  onActionCaller: onActionHandler,
                ),
                Container(
                  width: MediaQuery.of(context).size.width -
                      (Dimens.actionBtnW + 15),
                  decoration: BoxDecoration(color: Colors.grey[190]),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 20.0, left: 20.0, right: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 20),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width -
                                (Dimens.actionBtnW + 15),
                            height: MediaQuery.of(context).size.height -
                                (Dimens.topBarHeight + Dimens.tabHeight + 60),
                            child: GridView(
                              controller:
                              ScrollController(keepScrollOffset: false),
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 250,
                                  childAspectRatio: 3 / 1.8,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20),
                              children: FakeData()
                                  .generateSoftware()
                                  .map((item) => SoftwareItem(
                                  software: item,
                                  onActionListener: onSoftwareSelect))
                                  .toList(),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            )
          ]),
        ));
  }
}
