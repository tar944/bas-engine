import 'dart:io';

import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/projectDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/projectPartDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/models/projectModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/projectPartModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/projectListPage/views/dlgProjectInfo.dart';
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
  ProjectModel? curProject;
  ProjectPartModel? curPart;
  late void Function() projectController;
  late void Function() partController;
  late void Function() groupController;

  @override
  void init() async {
    // Add this line to override the default close handler
    await windowManager.setPreventClose(true);
    setProjectGuideText();
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

  setProjectGuideText()async{
    var projects = await ProjectDAO().getAll();
    guideText=projects.isEmpty?Strings.guideEmptyProject:Strings.guideProjects;
    notifyListeners();
  }

  setPartGuideText()async{
    guideText=curProject!.allParts.isEmpty?Strings.guideEmptyParts:Strings.guideParts;
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

  setPartController(BuildContext context, void Function() methodOfPart) {
    partController = methodOfPart;
  }

  setGroupController(BuildContext context, void Function() methodOfGroup) {
    groupController = methodOfGroup;
  }

  onProjectActionHandler(int prjId)async{
    if(prjId==-1){
      await setProjectGuideText();
    }else{
      curProject = await ProjectDAO().getDetails(prjId);
      onNavigationChanged(HeaderTabs.projectParts);
      curTab = HeaderTabs.projectParts;
      await setPartGuideText();
      notifyListeners();
    }
  }
  onGroupActionHandler(String action)async{

  }

  onPartActionHandler(int partId)async{
    if(partId==-1){
      curProject = await ProjectDAO().getDetails(curProject!.id);
      await setPartGuideText();
    }else{
      curPart = await ProjectPartDAO().getDetails(partId);
      onNavigationChanged(HeaderTabs.imageGroups);
      curTab = HeaderTabs.imageGroups;
      guideText=Strings.guideImageGroup;
      notifyListeners();
    }
  }

  onNavigationChanged(HeaderTabs selTab){
    if(selTab==HeaderTabs.addProject){
      projectController.call();
    }else if(selTab==HeaderTabs.addPart){
      partController.call();
    }else if(selTab==HeaderTabs.addGroup){
      groupController.call();
    }else{
      if(selTab!=curTab){
        if(selTab==HeaderTabs.project){
          controller.jumpToPage(0);
          curProject=null;
          curTab=HeaderTabs.project;
          setProjectGuideText();
          notifyListeners();
        }else if(selTab==HeaderTabs.projectParts){
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