import 'package:bas_dataset_generator_engine/main.dart';
import 'package:bas_dataset_generator_engine/objectbox.g.dart';
import 'package:bas_dataset_generator_engine/src/data/models/labelModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/projectModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/projectPartModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/videoModel.dart';
import 'package:bas_dataset_generator_engine/src/utility/directoryManager.dart';

class ProjectDAO {

  Future<List<ProjectModel>> getAll() async {
    Box<ProjectModel> box = objectbox.store.box<ProjectModel>();
    final softwareList =box.getAll();
    return softwareList;
  }

  Future<ProjectModel?> getDetails(int id) async {
    Box<ProjectModel> box = objectbox.store.box<ProjectModel>();
    ProjectModel? software = box.get(id);
    return software;
  }

  Future<ProjectModel?> getDetailsByUUID(String uuid) async {
    Box<ProjectModel> box = objectbox.store.box<ProjectModel>();
    ProjectModel? project = box.query(ProjectModel_.uuid.equals(uuid)).build().findFirst();
    return project;
  }

  Future<List<VideoModel>> getAllVideos(int id) async{
    final project = await getDetails(id);
    if(project==null){
      return [];
    }
    return project.allVideos.toList();
  }

  Future<List<ProjectPartModel>> getAllParts(int id) async{
    final project = await getDetails(id);
    if(project==null){
      return [];
    }
    return project.allParts.toList();
  }

  Future<int> addProject(ProjectModel newProject) async{
    Box<ProjectModel> box = objectbox.store.box<ProjectModel>();
    int result = box.put(newProject);
    return result;
  }

  Future<bool> addAVideo(String uuid,VideoModel video) async{
    final project = await getDetailsByUUID(uuid);
    if(project==null){
      return false;
    }
    project.allVideos.add(video);
    update(project);
    return true;
  }

  Future<bool> addALabel(String uuid,LabelModel lbl) async{
    final project = await getDetailsByUUID(uuid);
    if(project==null){
      return false;
    }
    project.allLabels.add(lbl);
    update(project);
    return true;
  }

  Future<bool> addAPart(int id,ProjectPartModel part) async{
    final project = await getDetails(id);
    if(project==null){
      return false;
    }
    project.allParts.add(part);
    update(project);
    return true;
  }

  Future<bool> removeAPart(int id,ProjectPartModel part) async{
    final project = await getDetails(id);
    if(project==null){
      return false;
    }
    project.allParts.removeWhere((element) => element.id == part.id);
    update(project);
    return true;
  }

  Future<bool> removeAVideo(int id,VideoModel video) async{
    final project = await getDetails(id);
    if(project==null){
      return false;
    }
    project.allVideos.remove(video);
    update(project);
    return true;
  }

  Future<int> update(ProjectModel prj) async{
    final project = await getDetails(prj.id);
    if(project==null){
      return -1;
    }
    Box<ProjectModel> box = objectbox.store.box<ProjectModel>();
    int result=box.put(prj);
    return result;
  }

  Future<bool>  delete(ProjectModel project) async{
    Box<ProjectModel> box = objectbox.store.box<ProjectModel>();
    bool result =box.remove(project.id);
    await DirectoryManager().deleteProjectDirectory(project.uuid);
    return result;
  }
}