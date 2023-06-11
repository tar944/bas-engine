import 'package:bas_dataset_generator_engine/src/data/dao/recordedScreenGroupsDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/videoDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/models/regionDataModel.dart';
import 'package:bas_dataset_generator_engine/src/utility/directoryManager.dart';
import '../../../main.dart';
import '../../../objectbox.g.dart';
import '../models/actionModel.dart';
import '../models/screenShootModel.dart';

class ScreenDAO {
  Future<ScreenShootModel?> getScreen(int id) async {
    Box<ScreenShootModel> box = objectbox.store.box<ScreenShootModel>();
    ScreenShootModel? screen = box.get(id);
    return screen;
  }

  Future<List<RegionDataModel>> getAllParts(int id) async {
    final screen = await getScreen(id);
    if (screen == null) {
      return [];
    }
    return screen.partsList.toList();
  }

  Future<int> addScreenToVideo(ScreenShootModel newScreen) async {
    Box<ScreenShootModel> box = objectbox.store.box<ScreenShootModel>();
    int result = box.put(newScreen);
    newScreen.id = result;
    VideoDAO().addAScreenShoot(newScreen.video.target!.id, newScreen);
    return result;
  }

  Future<int> addScreenToGroup(ScreenShootModel newScreen) async {
    Box<ScreenShootModel> box = objectbox.store.box<ScreenShootModel>();
    int result = box.put(newScreen);
    newScreen.id = result;
    RecordedScreenGroupDAO().addAScreenShoot(newScreen.group.target!.id, newScreen);
    return result;
  }

  Future<ActionModel> addAction(ActionModel newAction) async {
    Box<ActionModel> box = objectbox.store.box<ActionModel>();
    int result = box.put(newAction);
    newAction.id = result;
    return newAction;
  }

  Future<bool> addAPart(int id, RegionDataModel part) async {
    final screen = await getScreen(id);
    if (screen == null) {
      return false;
    }
    screen.partsList.add(part);
    updateScreen(screen);
    return true;
  }

  Future<bool> removeAPart(int id, RegionDataModel part) async {
    final screen = await getScreen(id);
    if (screen == null) {
      return false;
    }
    screen.partsList.remove(part);
    updateScreen(screen);
    return true;
  }

  Future<int> updateScreen(ScreenShootModel screen) async {
    Box<ScreenShootModel> box = objectbox.store.box<ScreenShootModel>();
    int result = box.put(screen);
    return result;
  }

  Future<bool> deleteScreen(ScreenShootModel screen) async {
    Box<ScreenShootModel> box = objectbox.store.box<ScreenShootModel>();
    bool result = box.remove(screen.id!);

    DirectoryManager().deleteImage(screen.path!);
    return result;
  }
}
