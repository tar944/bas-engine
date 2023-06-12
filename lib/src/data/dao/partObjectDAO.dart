import 'package:bas_dataset_generator_engine/src/data/dao/screenPartDAO.dart';
import 'package:bas_dataset_generator_engine/src/utility/directoryManager.dart';
import '../../../main.dart';
import '../../../objectbox.g.dart';
import 'package:path/path.dart' as p;
import '../models/regionDataModel.dart';

class PartObjectDAO {
  Future<RegionDataModel?> getObject(int id) async {
    Box<RegionDataModel> box = objectbox.store.box<RegionDataModel>();
    RegionDataModel? part = box.get(id);
    return part;
  }

  Future<int> addObject(RegionDataModel newObject) async {
    Box<RegionDataModel> box = objectbox.store.box<RegionDataModel>();
    int result = box.put(newObject);
    newObject.id = result;
    PartDAO().addAObject(newObject.part.target!.id!, newObject);
    return result;
  }

  Future<int> updateObject(RegionDataModel object) async {
    Box<RegionDataModel> box = objectbox.store.box<RegionDataModel>();
    int result = box.put(object);
    return result;
  }

  Future<bool> deleteObject(RegionDataModel object) async {
    Box<RegionDataModel> box = objectbox.store.box<RegionDataModel>();
    bool result = box.remove(object.id!);
    final screen = object.part.target!.screen.target;
    DirectoryManager().deleteImage(
        p.join(await DirectoryManager().getPartDir(
            '${screen!.video.target!.software.target!.id}_${screen.video.target!
                .software.target!.title!}',
            screen.video.target!.name!),object.imageName!));
    return result;
  }
}