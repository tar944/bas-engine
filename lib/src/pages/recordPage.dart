import 'dart:io';
import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/assets/values/textStyle.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/imageDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/objectDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/projectPartDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/models/imageModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as p;
import 'package:bas_dataset_generator_engine/src/dialogs/flyDlgRecordMenu.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pmvvm/pmvvm.dart';
import 'package:screen_capturer/screen_capturer.dart';
import 'package:uuid/uuid.dart';
import 'package:window_manager/window_manager.dart';
import 'package:simple_animations/movie_tween/movie_tween.dart';
import 'package:simple_animations/animation_builder/custom_animation_builder.dart';
import 'package:screen_retriever/screen_retriever.dart';
import 'package:mouse_event/mouse_event.dart';
import 'package:audioplayers/audioplayers.dart';


class RecordPage extends HookWidget with WindowListener {
  Offset _lastShownPosition = Offset.zero;

  int? partId;

  RecordPage(this.partId);

  void onCloseListener(String action) {}

  @override
  Widget build(BuildContext context) {
    var imgNumber = useState(0);
    var lastObjectId = useState(-1);
    var isRecording = useState(false);
    var shutterState = useState("normal");
    var dirPath = useState('');
    final player = AudioPlayer();

    final controller = FlyoutController();
    useEffect(() {
      Future<void>.microtask(() async {

        await windowManager.setSize(const Size(Dimens.recordPnlWidth, 200), animate: true);

        Display primaryDisplay = await screenRetriever.getPrimaryDisplay();
        _lastShownPosition = Offset(
            primaryDisplay.size.width - (Dimens.recordPnlWidth + 10),
            primaryDisplay.size.height - 260);
        await windowManager.setPosition(_lastShownPosition);
        await windowManager.setAlwaysOnTop(true);
        await Future.delayed(const Duration(milliseconds: 100));


        final part = await ProjectPartDAO().getDetails(partId!);
        if(part!.allObjects.isNotEmpty){
          lastObjectId.value=part.allObjects[part.allObjects.length-1].id!;
        }
        dirPath.value=part.path;
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
            shutterState.value="waiting";
            await Future.delayed(const Duration(milliseconds: 600));
            shutterState.value="capturing";
            await Future.delayed(const Duration(milliseconds: 100));
            await player.play(AssetSource('../lib/assets/sounds/cameraShutter.wav'));
            var imgPath = p.join(dirPath.value,'images', 'screen_${DateTime.now().millisecondsSinceEpoch}.png');
            var captureData=await screenCapturer.capture(
              mode: CaptureMode.screen,
              imagePath: imgPath,
              copyToClipboard: false,
              silent: true,
            );

            ObjectModel obj = ObjectModel(-1,const Uuid().v4(), 0, 0, 0, 0);
            obj.actionType = mouseEvent.mouseMsg.toString();
            var img =ImageModel(-1, const Uuid().v4(), obj.uuid, p.basename(imgPath),captureData!.imageWidth!.toDouble(),captureData.imageHeight!.toDouble(), imgPath);
            img.id= await ImageDAO().add(img);
            obj.image.target=img;
            obj.id=await ObjectDAO().addObject(obj);
            await ProjectPartDAO().addObject(partId!, obj);
            if(lastObjectId.value!=-1){
              var lastObj= await ObjectDAO().getDetails(lastObjectId.value);
              lastObj!.actX=mouseEvent.x;
              lastObj.actY=mouseEvent.y;
              await ObjectDAO().update(lastObj);
            }
            imgNumber.value += 1;
            shutterState.value="normal";
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
            ColorTween(
                begin: shutterState.value!="normal"?Colors.magenta.normal:Colors.teal.normal,
                end: shutterState.value!="normal"?Colors.magenta.darker:Colors.teal.darker));

    if (isRecording.value) {
      return shutterState.value!="capturing"?CustomAnimationBuilder(
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
      ):Container();
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
