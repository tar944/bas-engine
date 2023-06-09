import 'package:bas_dataset_generator_engine/src/data/models/recordedScreenGroup.dart';
import 'package:bas_dataset_generator_engine/src/dialogs/dlgNewScreenGroup.dart';
import 'package:bas_dataset_generator_engine/src/items/groupItem.dart';
import 'package:bas_dataset_generator_engine/src/utility/directoryManager.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:window_manager/window_manager.dart';
import '../../assets/values/dimens.dart';
import '../../assets/values/strings.dart';
import '../../assets/values/textStyle.dart';
import '../data/dao/recordedScreenGroupsDAO.dart';
import '../data/dao/softwareDAO.dart';
import '../parts/addsOnPanel.dart';
import '../parts/topBarPanel.dart';
import '../utility/platform_util.dart';

class ScreensSource extends HookWidget with WindowListener {
  int? softwareId;

  ScreensSource(this.softwareId);

  Offset _lastShownPosition = Offset.zero;

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

  Future<void> _windowShow() async {
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

  void onBackHandler(bool kind) {}

  @override
  Widget build(BuildContext context) {
    final groups = useState([]);

    useEffect(() {
      _init();
      Future<void>.microtask(() async {
        groups.value = await SoftwareDAO().getAllGroups(softwareId!);
      });
      return null;
    }, const []);

    void onSourceActionHandler(String action) async{
      RecordedScreenGroup? group=  await RecordedScreenGroupDAO().getGroup(int.parse(action.split('&&')[1]));
      switch(action.split('&&')[0]){
        case 'record':
          context.goNamed('recordScreens',params: {'groupId':group!.id.toString()});
          Navigator.pop(context);
          break;
        case 'delete':
          await RecordedScreenGroupDAO().deleteGroup(group!);
          groups.value = await SoftwareDAO().getAllGroups(softwareId!);
          break;
        case 'labeling':
          context.goNamed('labeling',params: {'groupId':group!.id.toString()});
          break;
        case 'screens':
          context.goNamed('screensList',params: {'groupId':group!.id.toString()});
          break;
      }
    }
    void onCreateCourseHandler(RecordedScreenGroup group) async{
      final software = await SoftwareDAO().getSoftware(softwareId!);
      group.software.target=software;
      final id = await RecordedScreenGroupDAO().addGroup(group);
      group.path=await DirectoryManager().createGroupDir('${softwareId}_${software!.title!}',  '${id}_${group.name!}');
      await RecordedScreenGroupDAO().updateGroup(group);
      groups.value = await SoftwareDAO().getAllGroups(softwareId!);
    }

    void onActionHandler(String action) async {
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) =>
              DlgNewScreenGroup(onSaveCaller: onCreateCourseHandler));
      // FilePickerResult? result =
      //     await FilePicker.platform.pickFiles(allowMultiple: true);
      //
      // if (result != null) {
      //   final software = await SoftwareDAO().getSoftware(softwareId!);
      //   for (var path in result.paths) {
      //     File newVideo = File(path!);
      //     final video = VideoModel(0, p.basename(newVideo.path),'', newVideo.path, '00:00');
      //     video.software.target=software;
      //     VideoDAO().addVideo(video);
      //     await DirectoryManager().createVideoDir('${softwareId}_${software!.title!}',  p.basename(newVideo.path));
      //   }
      //   videos.value = await SoftwareDAO().getAllVideos(softwareId!);
      // }
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
                  kind: "video",
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
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width -
                                (Dimens.actionBtnW + 15),
                            height: MediaQuery.of(context).size.height -
                                (Dimens.topBarHeight + Dimens.tabHeight + 60),
                            child: groups.value != null &&
                                    groups.value!.isNotEmpty
                                ? SizedBox(
                                    width: MediaQuery.of(context).size.width -
                                        (Dimens.actionBtnW + 15),
                                    height: MediaQuery.of(context).size.height -
                                        (Dimens.topBarHeight),
                                    child: GridView(
                                      controller: ScrollController(
                                          keepScrollOffset: false),
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      gridDelegate:
                                          const SliverGridDelegateWithMaxCrossAxisExtent(
                                              maxCrossAxisExtent: 305,
                                              childAspectRatio: 3 / 1.8,
                                              crossAxisSpacing: 20,
                                              mainAxisSpacing: 20),
                                      children: groups.value
                                          .map((item) => GroupItem(group: item,onActionCaller: onSourceActionHandler,))
                                          .toList(),
                                    ),
                                  )
                                : Column(
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
                                        'your Groups list is empty...',
                                        style: TextSystem.textL(Colors.white),
                                      ),
                                    ],
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
