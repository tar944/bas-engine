import 'dart:io';

import 'package:bas_dataset_generator_engine/src/data/dao/videoDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/models/videoModel.dart';
import 'package:bas_dataset_generator_engine/src/utility/directoryManager.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:fc_native_video_thumbnail/fc_native_video_thumbnail.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../assets/values/dimens.dart';
import '../../assets/values/textStyle.dart';
import '../dialogs/flyDlgDelete.dart';

class VideoItem extends HookWidget {
  VideoItem({Key? key, required this.video, this.onActionCaller})
      : super(key: key);

  final VideoModel video;

  final ValueSetter<String>? onActionCaller;
  final _plugin = FcNativeVideoThumbnail();

  @override
  Widget build(BuildContext context) {
    final imgPath = useState('');
    final controller = FlyoutController();

    useEffect(() {
      if (video.thumbnailPath.isNotEmpty) {
        imgPath.value = video.thumbnailPath;
      } else {
        Future<void>.microtask(() async {
          final dest = await DirectoryManager().generateThumbnailPath(
              '${video.software.target!.id}_${video.software.target!.title!}',
              video.name!);
          await _plugin.getVideoThumbnail(
              srcFile: video.path,
              destFile: dest,
              width: 450,
              height: 300,
              keepAspectRatio: true);
          video.thumbnailPath = dest;
          VideoDAO().updateVideo(video);
          imgPath.value = video.thumbnailPath;
        });
      }
      return null;
    }, const []);

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        borderRadius:
            const BorderRadius.all(Radius.circular(Dimens.dialogCornerRadius)),
        color: Colors.grey[170],
        border: Border.all(color: Colors.magenta, width: 1.5),
        image: DecorationImage(
          image: imgPath.value == ''
              ? const AssetImage('lib/assets/testImages/testImg1.png')
              : Image.file(File(video.thumbnailPath)).image,
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 35,
          ),
          IconButton(
              icon: Container(
                  width: 60,
                  height: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[170].withOpacity(0.5),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Icon(
                      CupertinoIcons.play,
                      color: Colors.white,
                      size: 45,
                    ),
                  )),
              onPressed: () => onActionCaller!('play&&${video.id}')),
          const Spacer(),
          Container(
              height: 40,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  color: Colors.grey[190].withOpacity(0.7)),
              child: Row(
                children: [
                  Expanded(
                      flex: 14,
                      child: FlyoutTarget(
                          key: GlobalKey(),
                          controller: controller,
                          child: IconButton(
                              icon: Icon(
                                FluentIcons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () => showFlyDelete(
                                  "Are you sure?",
                                  "yeh",
                                  controller,
                                  FlyoutPlacementMode.topCenter,
                                  video.id,
                                  onActionCaller)))),
                  Expanded(
                      flex: 26,
                      child: IconButton(
                        onPressed: () => onActionCaller!('screens&&${video.id}'),
                        icon: Text(
                          'Screens',
                          style: TextSystem.textS(Colors.white),
                        ),
                      )),
                  Expanded(
                      flex: 60,
                      child: IconButton(
                        onPressed: () => onActionCaller!('labeling&&${video.id}'),
                        icon: Text(
                          'Labeling page',
                          style: TextSystem.textS(Colors.magenta.lighter),
                        ),
                      )),
                ],
              )),
        ],
      ),
    );
  }
}
