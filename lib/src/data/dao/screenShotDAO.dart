import 'package:bas_dataset_generator_engine/src/data/dao/videoDAO.dart';
import 'package:bas_dataset_generator_engine/src/utility/directoryManager.dart';
import '../../../main.dart';
import '../../../objectbox.g.dart';
import '../models/scenePartModel.dart';
import '../models/screenShootModel.dart';
import 'package:path/path.dart' as p;

class ScreenDAO {
  Future<ScreenShootModel?> getScreen(int id) async {
    Box<ScreenShootModel> box = objectbox.store.box<ScreenShootModel>();
    ScreenShootModel? screen = box.get(id);
    return screen;
  }

  Future<List<ScenePartModel>> getAllParts(int id) async {
    final screen = await getScreen(id);
    if (screen == null) {
      return [];
    }
    return screen.sceneParts.toList();
  }

  Future<int> addScreen(ScreenShootModel newScreen) async {
    Box<ScreenShootModel> box = objectbox.store.box<ScreenShootModel>();
    int result = box.put(newScreen);
    newScreen.id = result;
    VideoDAO().addAScreenShoot(newScreen.video.target!.id, newScreen);
    return result;
  }

  Future<bool> addAPart(int id, ScenePartModel part) async {
    final screen = await getScreen(id);
    if (screen == null) {
      return false;
    }
    screen.sceneParts.add(part);
    updateScreen(screen);
    return true;
  }

  Future<bool> removeAPart(int id, ScenePartModel part) async {
    final screen = await getScreen(id);
    if (screen == null) {
      return false;
    }
    screen.sceneParts.remove(part);
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
    DirectoryManager().deleteImage(p.join(
        '${screen.video.target!.software.target!.id}_${screen.video.target!.software.target!.title!}',
        screen.video.target!.name!,
        screen.imageName!));
    return result;
  }
}
