import 'dart:io';
import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/assets/values/textStyle.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/imageDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/objectDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/projectPartDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/models/imageModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:bas_dataset_generator_engine/src/utility/platform_util.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as p;
import 'package:bas_dataset_generator_engine/src/dialogs/flyDlgRecordMenu.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:screen_capturer/screen_capturer.dart';
import 'package:uuid/uuid.dart';
import 'package:window_manager/window_manager.dart';
import 'package:simple_animations/movie_tween/movie_tween.dart';
import 'package:simple_animations/animation_builder/custom_animation_builder.dart';
import 'package:screen_retriever/screen_retriever.dart';
import 'package:mouse_event/mouse_event.dart';

class RecordPage extends HookWidget with WindowListener {
  Offset _lastShownPosition = Offset.zero;

  int? partId;

  RecordPage(this.partId);

  void _init(BuildContext context) async {
    // Add this line to override the default close handler
    await windowManager.setPreventClose(true);

    windowManager.waitUntilReadyToShow().then((_) async {
      if (kIsLinux || kIsWindows) {
        if (kIsLinux) {
          await windowManager.setAsFrameless();
        } else {
          await windowManager.setAsFrameless();
          await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
        }
        Display primaryDisplay = await screenRetriever.getPrimaryDisplay();
        _lastShownPosition = Offset(
            primaryDisplay.size.width - (Dimens.recordPnlWidth + 10),
            primaryDisplay.size.height - 260);
        await windowManager.setPosition(_lastShownPosition);
      }
      await windowManager.setSkipTaskbar(true);
      await windowManager.setHasShadow(false);
      await windowManager.setSize(const Size(Dimens.recordPnlWidth, 200),
          animate: true);
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
  Widget build(BuildContext context) {
    var imgNumber = useState(0);
    var isRecording = useState(false);
    var dirPath = useState('');
    final controller = FlyoutController();
    useEffect(() {
      _init(context);
      Future<void>.microtask(() async {
        final part = await ProjectPartDAO().getDetails(partId!);
        dirPath.value=part!.path;
        imgNumber.value = part.allObjects.length;
      });
      return null;
    }, const []);

    void onRecordActionListener(String action) {
      switch (action) {
        case Strings.saveAndExit:
          exit(0);
        case Strings.saveNext:
          context.goNamed('screensList',params: {'partId':partId.toString()});
          break;
        case "record":
          break;
        case "stop":
          break;
      }
    }

    onRecordBtnListener() async {
      isRecording.value = !isRecording.value;
      if (isRecording.value) {
        MouseEventPlugin.startListening((mouseEvent) async {
          if (mouseEvent.mouseMsg == MouseEventMsg.WM_LBUTTONUP ||
              mouseEvent.mouseMsg == MouseEventMsg.WM_RBUTTONUP ||
              mouseEvent.mouseMsg == MouseEventMsg.WM_MBUTTONUP) {
            await Future.delayed(Duration(
                milliseconds: mouseEvent.mouseMsg == MouseEventMsg.WM_LBUTTONUP
                    ? 100
                    : 300));
            var imgPath = p.join(dirPath.value,'images', 'screen_${DateTime.now().millisecondsSinceEpoch}.png');
            await screenCapturer.capture(
              mode: CaptureMode.screen,
              imagePath: imgPath,
              copyToClipboard: false,
              silent: true,
            );

            ObjectModel obj = ObjectModel(-1,const Uuid().v4(), 0, 0, 0, 0,"");
            obj.actionType = mouseEvent.mouseMsg.toString();
            obj.actX=mouseEvent.x;
            obj.actY=mouseEvent.y;
            var img =ImageModel(-1, const Uuid().v4(), obj.uuid, p.basename(imgPath), imgPath);
            img.id= await ImageDAO().add(img);
            obj.image.target=img;
            obj.id=await ObjectDAO().addObject(obj);
            await ProjectPartDAO().addObject(partId!, obj);
            imgNumber.value += 1;
          }
        });
      } else {
        MouseEventPlugin.cancelListening();
      }
      onRecordActionListener(isRecording.value ? "record" : "stop");
    }

    Widget getIcon(value) {
      if (isRecording.value) {
        return Container(
            height: value.get("height"),
            width: value.get("width"),
            alignment: Alignment.center,
            child: Container(
              height: 23,
              width: 23,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(3))),
              child: Text(
                imgNumber.value.toString(),
                style: TextSystem.textXs(value.get("color")),
              ),
            ));
      } else {
        return Container(
          height: double.infinity,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
          child: Container(
            height: 16,
            width: 16,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        );
      }
    }

    final tween = MovieTween();
    tween
        .scene(
            begin: const Duration(milliseconds: 0),
            duration: const Duration(milliseconds: 800))
        .tween(
            'width',
            Tween(
                begin: Dimens.recordPnlHeight,
                end: Dimens.recordPnlHeight - (Dimens.recordPnlHeight * 0.2)))
        .tween(
            'height',
            Tween(
                begin: Dimens.recordPnlHeight,
                end: Dimens.recordPnlHeight + (Dimens.recordPnlHeight * 0.2)))
        .tween('color',
            ColorTween(begin: Colors.blue.normal, end: Colors.blue.darker));

    if (isRecording.value) {
      return CustomAnimationBuilder(
        control: Control.mirror,
        builder: (context, value, child) {
          return Container(
            alignment: Alignment.bottomCenter,
            width: Dimens.recordPnlHeight,
            height: Dimens.recordPnlHeight,
            decoration: const BoxDecoration(color: Colors.transparent),
            child: Button(
              onPressed: onRecordBtnListener,
              style: ButtonStyle(
                  backgroundColor: ButtonState.all(value.get("color")),
                  shape: ButtonState.all(const CircleBorder())),
              child: getIcon(value),
            ),
          );
        },
        tween: tween,
        duration: tween.duration,
      );
    } else {
      return Container(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: Dimens.recordPnlWidth,
          height: Dimens.recordPnlHeight,
          decoration: BoxDecoration(
              color: Colors.grey[190],
              borderRadius: const BorderRadius.all(
                  Radius.circular(Dimens.dialogCornerRadius))),
          child: Row(
            children: [
              Expanded(
                  flex: 1,
                  child: IconButton(
                    onPressed: () => onRecordActionListener("recordReview"),
                    icon: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Icon(
                          FluentIcons.t_v_monitor,
                          size: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            imgNumber.value.toString(),
                            style: TextSystem.textXs(Colors.white),
                          ),
                        )
                      ],
                    ),
                  )),
              Expanded(
                  flex: 1,
                  child: IconButton(
                    style: ButtonStyle(
                        padding: ButtonState.all(const EdgeInsets.all(6.0))),
                    onPressed: onRecordBtnListener,
                    icon: Container(
                      height: double.infinity,
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.red, shape: BoxShape.circle),
                      child: Container(
                        height: 16,
                        width: 16,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  )),
              Expanded(
                flex: 1,
                child: FlyoutTarget(
                  key: GlobalKey(),
                  controller: controller,
                  child: IconButton(
                      icon: Container(
                        width: double.infinity,
                        height: double.infinity,
                        alignment: Alignment.center,
                        child: const Icon(
                          FluentIcons.accept,
                          size: 30,
                        ),
                      ),
                      onPressed: () => showFlyRecordMenu(
                          controller, onRecordActionListener)),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
