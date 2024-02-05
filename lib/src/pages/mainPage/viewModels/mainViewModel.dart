import 'dart:io';

import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/src/utility/enum.dart';
import 'package:bas_dataset_generator_engine/src/utility/platform_util.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';
import 'package:window_manager/window_manager.dart';

class MainPageViewModel extends ViewModel with WindowListener {

  bool isLoading=false;
  final PageController controller = PageController();
  HeaderTabs curTab=HeaderTabs.software;

  @override
  void init() async {
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
      await windowManager.center();

      await windowManager.setSkipTaskbar(false);
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

  void onCloseListener() {
    exit(0);
  }
  void onMinimizeListener() {
    windowManager.minimize();
  }

  @override
  void onWindowClose() async {}

  void onActionHandler(String action) async{
    if (action == Strings.createACourse) {
    }
  }

  onNavigationChanged(HeaderTabs selTab){
    if(selTab!=curTab){
      if(selTab==HeaderTabs.groups){
        controller.jumpToPage(1);
      }else if(selTab==HeaderTabs.screenLabel){
        controller.jumpToPage(2);
      }else if(selTab==HeaderTabs.partLabel){
        controller.jumpToPage(3);
      }
    }
  }
}