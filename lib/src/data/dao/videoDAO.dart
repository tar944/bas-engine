import 'package:bas_dataset_generator_engine/main.dart';
import 'package:bas_dataset_generator_engine/objectbox.g.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/projectDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/models/imageModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/videoModel.dart';

class VideoDAO{

  Future<VideoModel?> getVideo(int id) async {
    Box<VideoModel> box = objectbox.store.box<VideoModel>();
    VideoModel? software = box.get(id);
    return software;
  }

  Future<List<ImageModel>> getAllScreens(int id) async{
    final video = await getVideo(id);
    if(video==null){
      return [];
    }
    return video.allImages.toList();
  }

  Future<int> addVideo(VideoModel newVideo) async{
    Box<VideoModel> box = objectbox.store.box<VideoModel>();
    int result = box.put(newVideo);
    newVideo.id = result;
    ProjectDAO().addAVideo(newVideo.prjUUID, newVideo);
    return result;
  }

  Future<bool> addAScreenShoot(int id,ImageModel screen) async{
    final video = await getVideo(id);
    if(video==null){
      return false;
    }
    video.allImages.add(screen);
    updateVideo(video);
    return true;
  }

  Future<bool> removeAScreenShoot(int id,ImageModel screen) async{
    final video = await getVideo(id);
    if(video==null){
      return false;
    }
    video.allImages.remove(screen);
    updateVideo(video);
    return true;
  }

  Future<int> updateVideo(VideoModel video) async{
    Box<VideoModel> box = objectbox.store.box<VideoModel>();
    int result=box.put(video);
    return result;
  }

  Future<bool>  deleteVideo(VideoModel video) async{
    Box<VideoModel> box = objectbox.store.box<VideoModel>();
    bool result =box.remove(video.id);
    // DirectoryManager().deleteVideoDirectory('${video.software.target!.id}_${video.software.target!.title!}', video.name!);
    return result;
  }
}