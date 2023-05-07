import 'package:bas_dataset_generator_engine/src/data/models/softwareModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/videoModel.dart';
import '../../../objectbox.g.dart';
import 'baseBox.dart';

class SoftwareDAO extends BaseBox {
  SoftwareDAO() : super(boxName: 'softwareBox');

  Future<List<SoftwareModel>> getAllSoftware() async {
    final store = await lazyStore;
    Box<SoftwareModel> box = store.box<SoftwareModel>();
    final softwareList =box.getAll();
    store.close();
    return softwareList;
  }

  Future<SoftwareModel?> getSoftware(int id) async {
    final store = await lazyStore;
    Box<SoftwareModel> box = store.box<SoftwareModel>();
    SoftwareModel? software = box.get(id);
    store.close();
    return software;
  }

  Future<List<VideoModel>> getAllVideos(int id) async{
    final software = await getSoftware(id);
    if(software==null){
      return [];
    }
    return software.allVideos.toList();
  }

  Future<int> addSoftware(SoftwareModel newSoftware) async{
    final store = await lazyStore;
    Box<SoftwareModel> box = store.box<SoftwareModel>();
    int result = box.put(newSoftware);
    store.close();
    return result;
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
    int result=box.put(software);
    return result;
  }

  Future<bool>  deleteSoftware(int id) async{
    final store = await lazyStore;
    Box<SoftwareModel> box = store.box<SoftwareModel>();
    bool result =box.remove(id);
    store.close();
    return result;
  }
}