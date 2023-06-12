import 'package:bas_dataset_generator_engine/src/data/dao/screenShotDAO.dart';
import 'package:bas_dataset_generator_engine/src/utility/directoryManager.dart';
import '../../../main.dart';
import '../../../objectbox.g.dart';
import 'package:path/path.dart' as p;
import '../models/regionDataModel.dart';

class PartDAO {
  Future<RegionDataModel?> getPart(int id) async {
    Box<RegionDataModel> box = objectbox.store.box<RegionDataModel>();
    RegionDataModel? part = box.get(id);
    return part;
  }

  Future<List<RegionDataModel>> getAllObjects(int id) async {
    final part = await getPart(id);
    if (part == null) {
      return [];
    }
    return part.objectsList.toList();
  }

  Future<int> addPart(RegionDataModel newPart) async {
    Box<RegionDataModel> box = objectbox.store.box<RegionDataModel>();
    int result = box.put(newPart);
    newPart.id = result;
    ScreenDAO().addAPart(newPart.screen.target!.id!, newPart);
    return result;
  }

  Future<bool> addAObject(int id, RegionDataModel object) async {
    final part = await getPart(id);
    if (part == null) {
      return false;
    }
    part.objectsList.add(object);
    updatePart(part);
    return true;
  }

  Future<bool> removeAObject(int id, RegionDataModel object) async {
    final part = await getPart(id);
    if (part == null) {
      return false;
    }
    part.objectsList.remove(object);
    updatePart(part);
    return true;
  }

  Future<int> updatePart(RegionDataModel part) async {
    Box<RegionDataModel> box = objectbox.store.box<RegionDataModel>();
    int result = box.put(part);
    return result;
  }

  Future<bool> deletePart(RegionDataModel part) async {
    Box<RegionDataModel> box = objectbox.store.box<RegionDataModel>();
    bool result = box.remove(part.id!);
    final screen = part.screen.target;
    DirectoryManager().deleteImage(
        p.join(await DirectoryManager().getPartDir(
            '${screen!.group.target!.software.target!.id}_${screen.group.target!.software.target!.title!}',
            '${screen.group.target!.id}_${screen.group.target!.name!}'),part.imageName!));
    return result;
  }
}