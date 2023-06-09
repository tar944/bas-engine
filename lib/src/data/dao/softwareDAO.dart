import 'package:bas_dataset_generator_engine/main.dart';
import 'package:bas_dataset_generator_engine/src/data/models/recordedScreenGroup.dart';
import 'package:bas_dataset_generator_engine/src/data/models/softwareModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/videoModel.dart';
import 'package:bas_dataset_generator_engine/src/utility/directoryManager.dart';
import '../../../objectbox.g.dart';


class SoftwareDAO {

  Future<List<SoftwareModel>> getAllSoftware() async {
    Box<SoftwareModel> box = objectbox.store.box<SoftwareModel>();
    final softwareList =box.getAll();
    return softwareList;
  }

  Future<SoftwareModel?> getSoftware(int id) async {
    Box<SoftwareModel> box = objectbox.store.box<SoftwareModel>();
    SoftwareModel? software = box.get(id);
    return software;
  }

  Future<List<VideoModel>> getAllVideos(int id) async{
    final software = await getSoftware(id);
    if(software==null){
      return [];
    }
    return software.allVideos.toList();
  }

  Future<List<RecordedScreenGroup>> getAllGroups(int id) async{
    final software = await getSoftware(id);
    if(software==null){
      return [];
    }
    return software.allGroups.toList();
  }

  Future<int> addSoftware(SoftwareModel newSoftware) async{
    Box<SoftwareModel> box = objectbox.store.box<SoftwareModel>();
    int result = box.put(newSoftware);
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

  Future<bool> addAGroup(int id,RecordedScreenGroup group) async{
    final software = await getSoftware(id);
    if(software==null){
      return false;
    }
    software.allGroups.add(group);
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
    Box<SoftwareModel> box = objectbox.store.box<SoftwareModel>();
    int result=box.put(software);
    return result;
  }

  Future<bool>  deleteSoftware(SoftwareModel software) async{
    Box<SoftwareModel> box = objectbox.store.box<SoftwareModel>();
    bool result =box.remove(software.id);
    DirectoryManager().deleteSoftwareDirectory('${software.id}_${software.title}');
    return result;
  }
}