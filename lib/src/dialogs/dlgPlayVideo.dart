import 'dart:io';

import 'package:bas_dataset_generator_engine/src/data/models/videoModel.dart';
import 'package:bas_dataset_generator_engine/src/widgets/videoWidget.dart';
import 'package:fluent_ui/fluent_ui.dart';
import '../../assets/values/dimens.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';

import '../../assets/values/strings.dart';
import '../parts/dialogTitleBar.dart';

class DlgPlayVideo extends HookWidget {
  DlgPlayVideo({Key? key, required this.video}) : super(key: key);

  final VideoModel? video;

  @override
  Widget build(BuildContext context) {
    initMeeduPlayer();
    final _controller = MeeduPlayerController(
      screenManager: const ScreenManager(forceLandScapeInFullscreen: false),
    );
    void onCloseClicked() {
      _controller.dispose();
      Navigator.pop(context);
    }

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        File file = File(video!.path);
        _controller.setDataSource(
          DataSource(
            type: DataSourceType.file,
            file: file,
          ),
          autoplay: true,
        );
      });
      return null;
    }, const []);

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: Dimens.dialogLargeWidth,
          height: Dimens.dialogBigHeight,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
                Radius.circular(Dimens.dialogCornerRadius)),
            color: Colors.grey[190],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              DialogTitleBar(
                title: Strings.dlgNewSoftware,
                onActionListener: onCloseClicked,
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: VideoWidget(path: video!.path,controller: _controller,)
                          )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
