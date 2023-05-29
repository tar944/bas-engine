import 'package:bas_dataset_generator_engine/src/data/dao/screenShotDAO.dart';
import 'package:bas_dataset_generator_engine/src/utility/directoryManager.dart';
import '../../../main.dart';
import '../../../objectbox.g.dart';
import '../models/partObjectModel.dart';
import '../models/scenePartModel.dart';
import 'package:path/path.dart' as p;

class PartDAO {
  Future<ScenePartModel?> getPart(int id) async {
    Box<ScenePartModel> box = objectbox.store.box<ScenePartModel>();
    ScenePartModel? part = box.get(id);
    return part;
  }

  Future<List<PartObjectModel>> getAllObjects(int id) async {
    final part = await getPart(id);
    if (part == null) {
      return [];
    }
    return part.partObjects.toList();
  }

  Future<int> addPart(ScenePartModel newPart) async {
    Box<ScenePartModel> box = objectbox.store.box<ScenePartModel>();
    int result = box.put(newPart);
    newPart.id = result;
    ScreenDAO().addAPart(newPart.screen.target!.id!, newPart);
    return result;
  }

  Future<bool> addAObject(int id, PartObjectModel object) async {
    final part = await getPart(id);
    if (part == null) {
      return false;
    }
    part.partObjects.add(object);
    updatePart(part);
    return true;
  }

  Future<bool> removeAObject(int id, PartObjectModel object) async {
    final part = await getPart(id);
    if (part == null) {
      return false;
    }
    part.partObjects.remove(object);
    updatePart(part);
    return true;
  }

  Future<int> updatePart(ScenePartModel part) async {
    Box<ScenePartModel> box = objectbox.store.box<ScenePartModel>();
    int result = box.put(part);
    return result;
  }

  Future<bool> deletePart(ScenePartModel part) async {
    Box<ScenePartModel> box = objectbox.store.box<ScenePartModel>();
    bool result = box.remove(part.id!);
    final screen = part.screen.target;
    DirectoryManager().deleteImage(
        p.join(await DirectoryManager().getPartDir(
            '${screen!.video.target!.software.target!.id}_${screen.video.target!
                .software.target!.title!}',
            screen.video.target!.name!),part.imageName!));
    return result;
  }
}