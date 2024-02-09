import 'package:bas_dataset_generator_engine/main.dart';
import 'package:bas_dataset_generator_engine/objectbox.g.dart';
import 'package:bas_dataset_generator_engine/src/data/models/imageGroupModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/imageModel.dart';
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

  removeObject(int partId,ObjectModel img)async{
    ProjectPartModel? part = await getDetails(partId);
    part!.allObjects.removeWhere((element) => element.id == img.id);
    update(part);
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
    DirectoryManager().deletePartDirectory(
        '${part.prjUUID}_${part.uuid}',
        '${part.id}_${part.name!}');
    return result;
  }
}
