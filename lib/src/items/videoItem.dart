import 'package:bas_dataset_generator_engine/src/data/dao/videoDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/models/videoModel.dart';
import 'package:bas_dataset_generator_engine/src/utility/localPaths.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:fc_native_video_thumbnail/fc_native_video_thumbnail.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../assets/values/dimens.dart';
import '../../assets/values/textStyle.dart';

class VideoItem extends HookWidget {
  VideoItem( {Key? key, required this.video, this.onActionCaller}) : super(key: key);

  final VideoModel video;

  final ValueSetter<String>? onActionCaller;
  final _plugin = FcNativeVideoThumbnail();

  @override
  Widget build(BuildContext context) {

    final imgPath = useState('');
    useEffect(() {
      if(video.thumbnailPath.isNotEmpty){
        imgPath.value = video.thumbnailPath;
      }else{
        Future<void>.microtask(() async {
        final dest=await LocalPaths().generateThumbnailPath('${video.software.target!.id}_${video.software.target!.title!}',video.name!);
          await _plugin.getVideoThumbnail(
              srcFile: video.path,
              destFile:dest,
              width: 450,
              height: 300,
              keepAspectRatio: true);
          video.thumbnailPath=dest;
          VideoDAO().updateVideo(video);
          imgPath.value=video.thumbnailPath;
        });
      }
      return null;
    }, const []);


    return  Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                  Radius.circular(Dimens.dialogCornerRadius)),
              color: Colors.grey[170],
              border: Border.all(color: Colors.magenta, width: 1.5),
            image: DecorationImage(
              image: AssetImage(
                  'lib/assets/testImages/testImg1.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 50,),
              Container(
                  width: 80,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[170].withOpacity(0.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(CupertinoIcons.play,color: Colors.white,size: 25,),
                      SizedBox(width: 5,),
                      Text('3:45',style: TextSystem.textM(Colors.white),)
                    ],
                  )),

              Spacer(),
              Container(
                height: 40,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10),),
                  color: Colors.grey[170].withOpacity(0.7)
                ),
                child: Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: IconButton(
                          onPressed: () {},
                          icon: Text('Videos',style: TextSystem.textM(Colors.white),),
                        )),
                    Expanded(
                        flex: 1,
                        child: IconButton(
                          onPressed: () {},
                          icon: Text('Main pages',style: TextSystem.textM(Colors.blue.lighter),),
                        ))
                  ],
                ),
              ),
            ],
          ),
        );
  }
}
