import 'dart:io';
import 'package:bas_dataset_generator_engine/src/data/dao/videoDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/models/videoModel.dart';
import 'package:bas_dataset_generator_engine/src/utility/localPaths.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:window_manager/window_manager.dart';
import '../../assets/values/dimens.dart';
import '../../assets/values/strings.dart';
import '../../assets/values/textStyle.dart';
import '../data/dao/softwareDAO.dart';
import '../items/videoItem.dart';
import '../parts/addsOnPanel.dart';
import '../parts/topBarPanel.dart';
import '../utility/platform_util.dart';
import 'package:path/path.dart' as p;

class VideoList extends HookWidget with WindowListener {
  int? softwareId;

  VideoList(this.softwareId);

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
    final videos = useState([]);

    useEffect(() {
      _init();
      Future<void>.microtask(() async {
        videos.value = await SoftwareDAO().getAllVideos(softwareId!);
      });
      return null;
    }, const []);

    void onVideoActionHandler(String action) async{
      VideoModel? video=  await VideoDAO().getVideo(int.parse(action.split('&&')[1]));
      switch(action.split('&&')[0]){
        case 'delete':
          await VideoDAO().deleteVideo(video!.id);
          videos.value = await SoftwareDAO().getAllVideos(softwareId!);
          break;
        case 'goto':
          context.goNamed('screenList',params: {'videoId':video!.id.toString()});
          break;
      }
    }
    void onCreateCourseHandler(String createdSoftware) {}

    void onActionHandler(String action) async {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(allowMultiple: true);

      if (result != null) {
        final software = await SoftwareDAO().getSoftware(softwareId!);
        for (var path in result.paths) {
          File newVideo = File(path!);
          final video = VideoModel(0, p.basename(newVideo.path),'', newVideo.path, '00:00');
          video.software.target=software;
          VideoDAO().addVideo(video);
          await LocalPaths().createVideoDir('${softwareId}_${software!.title!}',  p.basename(newVideo.path));
        }
        videos.value = await SoftwareDAO().getAllVideos(softwareId!);
      }
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
                            child: videos.value != null &&
                                    videos.value!.isNotEmpty
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
                                              maxCrossAxisExtent: 300,
                                              childAspectRatio: 3 / 1.8,
                                              crossAxisSpacing: 20,
                                              mainAxisSpacing: 20),
                                      children: videos.value
                                          .map((item) => VideoItem(video: item,onActionCaller: onVideoActionHandler,))
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
                                        'your Video list is empty...',
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
