import 'dart:io';

import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/projectDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/models/projectModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/mainPage/views/dlgProjectInfo.dart';
import 'package:bas_dataset_generator_engine/src/utility/directoryManager.dart';
import 'package:bas_dataset_generator_engine/src/utility/enum.dart';
import 'package:bas_dataset_generator_engine/src/utility/platform_util.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';
import 'package:window_manager/window_manager.dart';

class MainPageViewModel extends ViewModel with WindowListener {

  bool isLoading=false;
  String guideText="";
  final PageController controller = PageController();
  HeaderTabs curTab=HeaderTabs.project;
  late void Function() projectController;

  @override
  void init() async {
    // Add this line to override the default close handler
    await windowManager.setPreventClose(true);
    setGuideText();
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

  setGuideText()async{
    var projects = await ProjectDAO().getAll();
    guideText=projects.isEmpty?Strings.guideEmptyProject:Strings.guideProjects;
    notifyListeners();
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

  setProjectController(BuildContext context, void Function() methodOfProject) {
    projectController = methodOfProject;
  }

  onProjectActionHandler(int prjId)async{
    if(prjId==-1){
      await setGuideText();
    }
  }

  onNavigationChanged(HeaderTabs selTab){
    if(selTab==HeaderTabs.addProject){
      projectController.call();
    }else if(selTab==HeaderTabs.addPart){
    }else{
      if(selTab!=curTab){
        if(selTab==HeaderTabs.projectParts){
          controller.jumpToPage(1);
        }else if(selTab==HeaderTabs.imageGroups){
          controller.jumpToPage(2);
        }else if(selTab==HeaderTabs.objectLabeling){
          controller.jumpToPage(3);
        }
      }
    }
  }
}