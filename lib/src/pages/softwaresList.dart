
import 'package:bas_dataset_generator_engine/assets/values/textStyle.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/softwareDAO.dart';
import 'package:bas_dataset_generator_engine/src/dialogs/dlgNewSoftware.dart';
import 'package:bas_dataset_generator_engine/src/items/softwareItem.dart';
import 'package:bas_dataset_generator_engine/src/utility/localPaths.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:window_manager/window_manager.dart';
import '../../assets/values/dimens.dart';
import '../../assets/values/strings.dart';
import '../data/models/softwareModel.dart';
import '../parts/addsOnPanel.dart';
import '../parts/topBarPanel.dart';
import '../utility/platform_util.dart';

class SoftWaresList extends HookWidget with WindowListener {
  Offset _lastShownPosition = Offset.zero;

  void _init() async {
    windowManager.addListener(this);
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

  @override
  Widget build(BuildContext context) {
    final software = useState([]);

    useEffect(() {
      _init();
      Future<void>.microtask(() async {
        software.value = await SoftwareDAO().getAllSoftware();
      });
      return null;
    }, const []);

    void onCreateCourseHandler(SoftwareModel curSoftware) async {
      final id = await SoftwareDAO().updateSoftware(curSoftware);
      await LocalPaths().createSoftwareDir('${id}_${curSoftware.title!}');
      software.value = await SoftwareDAO().getAllSoftware();
    }

    void onSoftwareSelect(String action) async{
      SoftwareModel? soft =  await SoftwareDAO().getSoftware(int.parse(action.split('&&')[1]));
      switch(action.split('&&')[0]){
        case 'edit':
          showDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) =>DlgNewSoftware(onSaveCaller: onCreateCourseHandler,software:soft),);
          break;
        case 'delete':
          await SoftwareDAO().deleteSoftware(soft!.id);
          software.value = await SoftwareDAO().getAllSoftware();
          break;
        case 'goto':
          context.goNamed('videoList',params: {'softwareId':soft!.id.toString()});
          break;
      }
    }


    void onNewSoftwareHandler(String action) {
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) =>
              DlgNewSoftware(onSaveCaller: onCreateCourseHandler));
    }

    return ScaffoldPage(
        padding: const EdgeInsets.only(top: 0, bottom: 0),
        content: SizedBox.expand(
          child: Column(children: [
            TopBarPanel(
              title: Strings.pageSoftware,
              needBack: false,
              needHelp: false,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AddsOnPanel(
                  kind: "library",
                  onActionCaller: onNewSoftwareHandler,
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
                                (Dimens.topBarHeight + 60),
                            child: software.value != null &&
                                    software.value!.isNotEmpty
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
                                              maxCrossAxisExtent: 250,
                                              childAspectRatio: 3 / 1.8,
                                              crossAxisSpacing: 20,
                                              mainAxisSpacing: 20),
                                      children: software.value!
                                          .map((item) => SoftwareItem(
                                              software: item,
                                              onActionCaller:
                                                  onSoftwareSelect))
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
                                        'your software list is empty...',
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
