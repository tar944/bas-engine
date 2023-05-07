import 'package:bas_dataset_generator_engine/src/data/models/videoModel.dart';
import '../../../objectbox.g.dart';
import '../models/screenShootModel.dart';
import 'baseBox.dart';

class VideoDAO extends BaseBox {
  VideoDAO() : super(boxName: 'videoBox');

  Future<VideoModel?> getVideo(int id) async {
    final store = await lazyStore;
    Box<VideoModel> box = store.box<VideoModel>();
    VideoModel? software = box.get(id);
    store.close();
    return software;
  }

  Future<List<ScreenShootModel>> getAllScreens(int id) async{
    final video = await getVideo(id);
    if(video==null){
      return [];
    }
    return video.screenShoots.toList();
  }

  Future<int> addVideo(VideoModel newVideo) async{
    final store = await lazyStore;
    Box<VideoModel> box = store.box<VideoModel>();
    int result = box.put(newVideo);
    store.close();
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
    final store = await lazyStore;
    Box<VideoModel> box = store.box<VideoModel>();
    int result=box.put(video);
    return result;
  }

  Future<bool>  deleteSoftware(int id) async{
    final store = await lazyStore;
    Box<VideoModel> box = store.box<VideoModel>();
    bool result =box.remove(id);
    store.close();
    return result;
  }
}