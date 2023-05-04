import 'package:bas_dataset_generator_engine/src/data/models/softwareModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/videoModel.dart';
import '../../../objectbox.g.dart';
import 'baseBox.dart';

class SoftwareDAO extends BaseBox {
  SoftwareDAO() : super(boxName: 'softwareBox');

  Future<List<SoftwareModel>> getAllSoftware() async {
    final store = await lazyStore;
    Box<SoftwareModel> box = store.box<SoftwareModel>();
    return box.getAll();
  }

  Future<SoftwareModel?> getSoftware(int id) async {
    final store = await lazyStore;
    Box<SoftwareModel> box = store.box<SoftwareModel>();
    return box.get(id);
  }

  Future<List<VideoModel>> getAllVideos(int id) async{
    final software = await getSoftware(id);
    if(software==null){
      return [];
    }
    return software.allVideos;
  }

  Future<int> addSoftware(SoftwareModel newSoftware) async{
    final store = await lazyStore;
    Box<SoftwareModel> box = store.box<SoftwareModel>();
    return box.put(newSoftware);
  }

  Future<bool> addAVideo(int id,VideoModel video) async{
    final software = await getSoftware(id);
    if(software==null){
      return false;
    }
    software.allVideos.add(video);
    updateSoftware(software);
    return true;
  }

  Future<bool> removeAVideo(int id,VideoModel video) async{
    final software = await getSoftware(id);
    if(software==null){
      return false;
    }
    software.allVideos.remove(video);
    updateSoftware(software);
    return true;
  }

  Future<int> updateSoftware(SoftwareModel software) async{
    final store = await lazyStore;
    Box<SoftwareModel> box = store.box<SoftwareModel>();
    return box.put(software);
  }

  Future<bool>  deleteSoftware(int id) async{
    final store = await lazyStore;
    Box<SoftwareModel> box = store.box<SoftwareModel>();
    return box.remove(id);
  }
}
