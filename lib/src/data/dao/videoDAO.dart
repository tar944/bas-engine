import 'package:bas_dataset_generator_engine/src/data/dao/softwareDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/models/videoModel.dart';
import '../../../main.dart';
import '../../../objectbox.g.dart';
import '../models/screenShootModel.dart';

class VideoDAO{

  Future<VideoModel?> getVideo(int id) async {
    Box<VideoModel> box = objectbox.store.box<VideoModel>();
    VideoModel? software = box.get(id);
    return software;
  }

  Future<List<ScreenShootModel>> getAllScreens(int id) async{
    final video = await getVideo(id);
    if(video==null){
      return [];
    }
    return video.screenShoots.toList();
  }

  Future<int> addVideo(VideoModel newVideo,int softwareId) async{
    Box<VideoModel> box = objectbox.store.box<VideoModel>();
    int result = box.put(newVideo);
    newVideo.id = result;
    SoftwareDAO().addAVideo(softwareId, newVideo);
    return result;
  }

  Future<bool> addAScreenShoot(int id,ScreenShootModel screen) async{
    final video = await getVideo(id);
    if(video==null){
      return false;
    }
    video.screenShoots.add(screen);
    updateVideo(video);
    return true;
  }

  Future<bool> removeAScreenShoot(int id,ScreenShootModel screen) async{
    final video = await getVideo(id);
    if(video==null){
      return false;
    }
    video.screenShoots.remove(screen);
    updateVideo(video);
    return true;
  }

  Future<int> updateVideo(VideoModel video) async{
    Box<VideoModel> box = objectbox.store.box<VideoModel>();
    int result=box.put(video);
    return result;
  }

  Future<bool>  deleteVideo(int id) async{
    Box<VideoModel> box = objectbox.store.box<VideoModel>();
    bool result =box.remove(id);
    return result;
  }
}