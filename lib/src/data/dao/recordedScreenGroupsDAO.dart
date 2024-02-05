import 'package:bas_dataset_generator_engine/src/data/dao/softwareDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/models/recordedScreenGroup.dart';
import 'package:bas_dataset_generator_engine/src/utility/directoryManager.dart';
import '../../../main.dart';
import '../../../objectbox.g.dart';
import '../models/screenShootModel.dart';

class RecordedScreenGroupDAO {
  Future<RecordedScreenGroup?> getGroup(int id) async {
    Box<RecordedScreenGroup> box = objectbox.store.box<RecordedScreenGroup>();
    RecordedScreenGroup? group = box.get(id);
    return group;
  }

  Future<List<ScreenShootModel>> getAllScreens(int id) async {
    final group = await getGroup(id);
    if (group == null) {
      return [];
    }
    return group.screenShoots.toList();
  }

  Future<int> addGroup(RecordedScreenGroup newGroup) async {
    Box<RecordedScreenGroup> box = objectbox.store.box<RecordedScreenGroup>();
    int result = box.put(newGroup);
    newGroup.id = result;
    SoftwareDAO().addAGroup(newGroup.software.target!.id, newGroup);
    return result;
  }

  Future<bool> addAScreenShoot(int id, ScreenShootModel screen) async {
    final group = await getGroup(id);
    if (group == null) {
      return false;
    }
    group.screenShoots.add(screen);
    group.imgNumber += 1;
    updateGroup(group);
    return true;
  }

  Future<bool> removeAScreenShoot(int id, ScreenShootModel screen) async {
    final group = await getGroup(id);
    if (group == null) {
      return false;
    }
    group.screenShoots.remove(screen);
    group.imgNumber -= 1;
    updateGroup(group);
    return true;
  }

  Future<int> updateGroup(RecordedScreenGroup group) async {
    Box<RecordedScreenGroup> box = objectbox.store.box<RecordedScreenGroup>();
    int result = box.put(group);
    return result;
  }

  Future<bool> deleteGroup(RecordedScreenGroup group) async {
    Box<RecordedScreenGroup> box = objectbox.store.box<RecordedScreenGroup>();
    bool result = box.remove(group.id);
    DirectoryManager().deleteGroupDirectory(
        '${group.software.target!.id}_${group.software.target!.title!}',
        '${group.id}_${group.name!}');
    return result;
  }
}
