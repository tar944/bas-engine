import 'package:bas_dataset_generator_engine/main.dart';
import 'package:bas_dataset_generator_engine/objectbox.g.dart';
import 'package:bas_dataset_generator_engine/src/data/models/imageGroupModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/projectPartModel.dart';
import 'package:bas_dataset_generator_engine/src/utility/directoryManager.dart';

class ProjectPartDAO {
  Future<ProjectPartModel?> getDetails(int id) async {
    Box<ProjectPartModel> box = objectbox.store.box<ProjectPartModel>();
    ProjectPartModel? part = box.get(id);
    return part;
  }

  Future<List<ImageGroupModel>> getAllGroups(int id) async {
    final part = await getDetails(id);
    if (part == null) {
      return [];
    }
    return part.allGroups.toList();
  }

  Future<List<ObjectModel>> getAllObjects(int id) async {
    final part = await getDetails(id);
    if (part == null) {
      return [];
    }
    return part.allObjects.toList();
  }

  addObject(int partId,ObjectModel obj)async{
    ProjectPartModel? part = await getDetails(partId);
    part!.allObjects.add(obj);
    update(part);
  }

  removeObject(int partId,ObjectModel obj)async{
    ProjectPartModel? part = await getDetails(partId);
    part!.allObjects.removeWhere((element) => element.id == obj.id);
    update(part);
  }

  Future<bool> addGroup(int partId,ImageGroupModel grp)async{
    ProjectPartModel? part = await getDetails(partId);
    if(part == null) {
      return false;
    }
    part.allGroups.add(grp);
    update(part);
    return true;
  }

  Future<bool> removeGroup(int partId,ImageGroupModel grp)async{
    ProjectPartModel? part = await getDetails(partId);
    if(part==null) {
      return false;
    }
    part.allObjects.removeWhere((element) => element.id == grp.id);
    update(part);
    return true;
  }

  Future<int> add(ProjectPartModel newPart) async {
    Box<ProjectPartModel> box = objectbox.store.box<ProjectPartModel>();
    int result = box.put(newPart);
    return result;
  }

  Future<int> update(ProjectPartModel part) async {
    Box<ProjectPartModel> box = objectbox.store.box<ProjectPartModel>();
    int result = box.put(part);
    return result;
  }

  Future<bool> delete(ProjectPartModel part) async {
    Box<ProjectPartModel> box = objectbox.store.box<ProjectPartModel>();
    bool result = box.remove(part.id);
    DirectoryManager().deletePartDirectory(part.prjUUID, part.uuid);
    return result;
  }
}
